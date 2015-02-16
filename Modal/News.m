//
//  News.m
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import "News.h"
#import "Constants.h"

static News *news = nil;

@implementation News

+(News *)sharedInstance
{
    if (news == nil) {
        news = [[News alloc]init];
    }
    return news;
}
//clear all the previous news before refreshing
-(void)flushData
{
    self.rows = nil;
    self.title = nil;
}
@end
