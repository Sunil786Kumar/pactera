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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[News sharedInstance].rows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = NEWS_CELL_IDENTIFIER;
    NewsCell *cell = (NewsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell ==  nil){
        NSLog(@"Loading");
        cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.newsImageView.image = nil;
    
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
                if(imageData){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NewsCell *cell = (NewsCell *)[tableView cellForRowAtIndexPath:indexPath];
                    
                    cell.newsImageView.image=[UIImage imageWithData:imageData];
                    if(![[news objectForKey:IMAGE_KEY] isEqual:[NSNull null]])
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
    NSLog(@"height");
    return 90;
}
#pragma mark - Helper methods

-(void)registerCell
{
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:NEWS_CELL_IDENTIFIER];
}

-(void)startDownloadingNews
{
    [[ConnectionManager sharedInstance]downloadNewsAtURL:[NSURL URLWithString:NEWS_URL]];
}
#pragma mark - Helper methods
-(void)manageNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataParsingFinished:)
                                                 name:NOTIFICATION_PARSING_COMPLETED
                                               object:nil];
    
}
-(void)dataParsingFinished:(NSNotification *)notification
{
    NSLog(@"Rows : %@",[News sharedInstance].rows);
    NSLog(@"reload data");
    [self.tableView reloadData];
}
@end
