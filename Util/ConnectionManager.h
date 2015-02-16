//
//  ConnectionManager.h
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

/*
 Connects the app with the backend
 */

#import <Foundation/Foundation.h>

@interface ConnectionManager : NSObject

+(ConnectionManager *)sharedInstance;

-(void)downloadNewsAtURL:(NSURL *)url;

@end
