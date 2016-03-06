//
//  DXApiRequest.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 12/8/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXApiRequest.h"

@implementation DXApiRequest

/**
 Makes a request to the DXMP server
 @param endpoint The query string of the endpoint to hit
 @return Body contents of the response
 */
+ (NSObject *)fetchDataFromApi:(NSString *)endpoint {
    return [self fetchDataFromApi:endpoint withHTTPMethod:@"GET"];
}

/**
 Makes a request to the DXMP server with customizable HTTP method
 @param endpoint The query string of the endpoint to hit
 @param method The HTTP method to use
 @return Body contents of the response
 */
+ (NSObject *)fetchDataFromApi:(NSString *)endpoint withHTTPMethod:(NSString *)method {
    NSObject *retVal = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSString *url = [NSString stringWithFormat:@"http://dxmp.us/api/?type=json&%@", endpoint];
    [request setHTTPMethod:method];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 200) {
        id objData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([objData isKindOfClass:[NSDictionary class]]) {
            retVal = objData[@"body"];
            
            // Cache off a copy of the data
            [DXFileIOHelper saveData:data toFile:endpoint];
            
        }
    }
    
    return retVal;
}

/**
 Determines if the device currently has any network connectivity
 */
+ (BOOL)networkUp
{
    struct hostent *host;
    // Test against the server. If it doesn't resolve, not much point trying to make more calls to it
    host = gethostbyname("dxmp.us");
    BOOL retVal = host == NULL;
    freehostent(host);
    return retVal;
}

@end
