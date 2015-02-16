//
//  Constants.h
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//url to download the news
#define NEWS_URL @"https://dl.dropboxusercontent.com/u/746330/facts.json" 

#pragma mark - JSON keys
//used to display the title in the navigation bar
#define TITLE_KEY @"title"
// all the news
#define ROWS_KEY  @"rows"
//description of the news
#define DESCRIPTION_KEY @"description"
//image url
#define IMAGE_KEY @"imageHref"

#pragma mark - TableView
//cell identifier
#define NEWS_CELL_IDENTIFIER @"NewsCell"

#pragma mark - Notifications
//notify controller , data is ready to be displayed
#define NOTIFICATION_PARSING_COMPLETED @"finished parsing downloaded data"

@end
