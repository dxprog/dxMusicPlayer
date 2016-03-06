//
//  DXApiRequest.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 12/8/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <unistd.h>
#import <netdb.h>

#import "DXFileIOHelper.h"

@interface DXApiRequest : NSObject

+ (NSObject *)fetchDataFromApi:(NSString *)endpoint;
+ (NSObject *)fetchDataFromApi:(NSString *)endpoint withHTTPMethod:(NSString *)method;

@end
