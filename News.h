//
//  News.h
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSArray *rows;

-(void)flushData;

+(News *)sharedInstance;
@end
