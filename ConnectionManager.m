//
//  ConnectionManager.m
//  Pactera
//
//  Created by Sunil Kumar on 6/02/2015.
//  Copyright (c) 2015 Sunil Kumar. All rights reserved.
//

#import "ConnectionManager.h"
#import "News.h"
#import "Constants.h"

static ConnectionManager *connectionManager = nil;

@interface ConnectionManager()

@end

@implementation ConnectionManager

+(ConnectionManager *)sharedInstance
{
    if (connectionManager == nil) {
        connectionManager = [[ConnectionManager alloc]init];
    }
    return connectionManager;
}


-(void)downloadNewsAtURL:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                //check if the parse is success
                NSObject *object = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error];
                
                if (object == nil) {//if not
                    //convert it to string
                    NSString *serverResponse = [[NSString alloc] initWithData:data
                                                                     encoding:NSASCIIStringEncoding];
                    //back to NSData and parse data to be a Dictionary
                    NSData *data = [serverResponse dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                   
                    [News sharedInstance].title = [json objectForKey:TITLE_KEY];
                    [News sharedInstance].rows  = [json objectForKey:ROWS_KEY];
                   
                    NSLog(@"Json : %@",[json objectForKey:@"title"]);
                    NSLog(@"Json row : %@",[[json objectForKey:@"rows"]objectAtIndex:0]);
                    
                }
            }] resume];
}
@end

