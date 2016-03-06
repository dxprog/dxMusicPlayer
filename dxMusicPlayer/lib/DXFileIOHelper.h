//
//  DXFileIOHelper.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 12/8/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXFileIOHelper : NSObject

+ (NSData *)loadDataFromFile:(NSString *)fileName;
+ (void)saveData:(NSData *)data toFile:(NSString *)fileName;

@end
