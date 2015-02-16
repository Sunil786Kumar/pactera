//
//  News.h
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

/*
 Data holder for the app
 */
#import <Foundation/Foundation.h>

@interface News : NSObject

@property (retain, nonatomic) NSString *title; // title of the  news
@property (retain, nonatomic) NSArray *rows;   // array of news

-(void)flushData;

+(News *)sharedInstance;
@end
