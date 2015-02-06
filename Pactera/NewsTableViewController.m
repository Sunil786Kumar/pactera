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

@interface NewsTableViewController ()<UITableViewDataSource,UITabBarDelegate>

@end

@implementation NewsTableViewController

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    NSDictionary *news = [[News sharedInstance].rows objectAtIndex:indexPath.row];
    
    if(![[news objectForKey:TITLE_KEY] isEqual:[NSNull null]])
       cell.newsHeaderLabel.text = [news objectForKey:TITLE_KEY];
    if(![[news objectForKey:DESCRIPTION_KEY] isEqual:[NSNull null]])
        cell.newsSubLabel.text = [news objectForKey:DESCRIPTION_KEY];
   
    
    
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
