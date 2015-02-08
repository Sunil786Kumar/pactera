//
//  NewsTableViewController.m
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import "NewsTableViewController.h"
#import "ConnectionManager.h"
#import "Constants.h"
#import "News.h"
#import "NewsCell.h"

@interface NewsTableViewController ()
@property (nonatomic,strong) NSCache *imageCache;
@property (nonatomic,unsafe_unretained) UIBarButtonItem *barButton;
@property (nonatomic,unsafe_unretained) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, unsafe_unretained) NewsCell *newsCell;

@end

@implementation NewsTableViewController

- (void)viewDidLoad
{
    if(!self.imageCache)
        self.imageCache = [[[NSCache alloc]init]autorelease];
    
    [self registerCell];
    [self manageNotifications];
    [self startDownloadingNews];
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[News sharedInstance].rows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = NEWS_CELL_IDENTIFIER;
    NewsCell *cell = (NewsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell ==  nil){
        cell = [[[NewsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.newsImageView.image = nil;
    cell.newsHeaderLabel.text = nil;
    cell.newsSubLabel.text = nil;
    
    NSDictionary *news = [[News sharedInstance].rows objectAtIndex:indexPath.row];
    
    if(![[news objectForKey:TITLE_KEY] isEqual:[NSNull null]])
       cell.newsHeaderLabel.text = [news objectForKey:TITLE_KEY];
    if(![[news objectForKey:DESCRIPTION_KEY] isEqual:[NSNull null]])
        cell.newsSubLabel.text = [news objectForKey:DESCRIPTION_KEY];
    
    
    if(![[news objectForKey:IMAGE_KEY] isEqual:[NSNull null]])
    {
        UIImage *image = [self.imageCache objectForKey:[news objectForKey:IMAGE_KEY]];//Check if image already exist
        if(image)
        {
            cell.newsImageView.image = image;
            [cell.newsImageView setNeedsLayout];
        }
        else
        {
            dispatch_queue_t downloadQueue = dispatch_queue_create("downloadImage", NULL);
            dispatch_async(downloadQueue, ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[news objectForKey:IMAGE_KEY]]];
               
                if(imageData) // image does exist?
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NewsCell *cell = (NewsCell *)[tableView cellForRowAtIndexPath:indexPath]; // get the correct cell
                        cell.newsImageView.image=[UIImage imageWithData:imageData];
                        if(![[news objectForKey:IMAGE_KEY] isEqual:[NSNull null]]) //dont want to cache Null
                            [self.imageCache setObject:[UIImage imageWithData:imageData] forKey:[news objectForKey:IMAGE_KEY]];//Cache the images
                        [cell setNeedsLayout];
                    });
                }
            });
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.newsCell = [self.tableView dequeueReusableCellWithIdentifier:NEWS_CELL_IDENTIFIER];
   
    CGRect contentRect = self.newsCell.bounds;
    CGFloat boundsX = contentRect.origin.x;
    
    NSDictionary *news = [[News sharedInstance].rows objectAtIndex:indexPath.row];
    
    NSString *header = [news objectForKey:TITLE_KEY];
    NSString *subHeader = [news objectForKey:DESCRIPTION_KEY];
    NSString *imageUrl = [news objectForKey:IMAGE_KEY];
    
    if([imageUrl isEqual:[NSNull null]] && [header isEqual:[NSNull null]] && [subHeader isEqual:[NSNull null]])
    {
        return  0;
    }
   
    float headerHeight = 0;
  
    //get the height required by the cell based on text.
    //refactoring required - not the best approach to do it. need to look at native apis sizeToFit etc.
    
    if(![header isEqual:[NSNull null]])
    {
        UILabel *headerLabel = [[[UILabel alloc]init]autorelease];
        CGFloat headerX = boundsX + 15;
        CGFloat headerWidth = contentRect.size.width - headerX;
        headerLabel.frame = CGRectMake(headerX, 0, headerWidth, 20);//random height
        headerLabel.text = header;
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        headerLabel.numberOfLines = 0;
        headerLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        [headerLabel sizeToFit];
        headerHeight = headerLabel.frame.size.height +4 ;
    }
    else
    {
        headerHeight = 4;
    }
    
    if(![subHeader isEqual:[NSNull null]])
    {
        UILabel *subHeaderLabel = [[[UILabel alloc]init]autorelease];
        CGFloat subHeaderX = boundsX + 15;
        CGFloat subHeaderWidth = contentRect.size.width - subHeaderX - contentRect.size.width/3;
        subHeaderLabel.frame = CGRectMake(0 ,0 , subHeaderWidth, 20); //random height
        subHeaderLabel.text = subHeader;
        subHeaderLabel.textAlignment = NSTextAlignmentLeft;
        subHeaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        subHeaderLabel.numberOfLines = 0;
        subHeaderLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        [subHeaderLabel sizeToFit];
        
        if(subHeaderLabel.frame.size.height < 44)
            return subHeaderLabel.frame.size.height + headerHeight + (44 - subHeaderLabel.frame.size.height) + 5;
        
        return subHeaderLabel.frame.size.height + headerHeight + 35 ;// + 35;
    }
    
    else
        return headerHeight + self.newsCell.newsImageView.frame.size.height;
}

#pragma mark - Helper methods
-(void)registerCell
{
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:NEWS_CELL_IDENTIFIER];
}

//display activity indicator while data is getting downloaded
-(void)startDownloadingNews
{
    self.activityIndicator = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:self.activityIndicator]autorelease];
    [self.activityIndicator startAnimating];

    [[ConnectionManager sharedInstance]downloadNewsAtURL:[NSURL URLWithString:NEWS_URL]];
}
#pragma mark - Helper methods
//get notified after parsing is done
-(void)manageNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataParsingFinished:)
                                                 name:NOTIFICATION_PARSING_COMPLETED
                                               object:nil];
    
}
-(void)dataParsingFinished:(NSNotification *)notification
{
    [self.activityIndicator stopAnimating];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Refresh"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(startDownloadingNews)] autorelease];
    self.title = [News sharedInstance].title;
    [self.tableView reloadData];
}
@end


