//
//  News.m
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import "News.h"

static News *news = nil;

@implementation News

+(News *)sharedInstance
{
    if (news == nil) {
        news = [[News alloc]init];
    }
    return news;
}
-(void)setRows:(NSArray *)rows
{
    _rows = rows;
    //data is ready, show it on view
}
@end
