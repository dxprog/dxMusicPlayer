//
//  DXFileIOHelper.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 12/8/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXFileIOHelper.h"

@implementation DXFileIOHelper

/**
 Loads data from app file cache
 @param fileName Name of file to load
 */
+ (NSData *)loadDataFromFile:(NSString *)fileName {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *localFileName = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
    NSLog(@"%@", localFileName);
    return [NSData dataWithContentsOfFile:localFileName];
}

/**
 Writes the data to the app file cache
 @param data Data to write to file
 @param fileName Name of file to write to
 */
+ (void)saveData:(NSData *)data toFile:(NSString *)fileName {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *localFileName = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
    [data writeToFile:localFileName atomically:YES];
}

@end
