//
//  DXMPID3Parser.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 2/3/14.
//  Copyright (c) 2014 Matt Hackmann. All rights reserved.
//

#import "DXID3Parser.h"

@implementation DXID3Parser

/**
 Reports the size of an ID3v2 header
 */
+ (NSInteger)getID3HeaderSize:(NSData *)data
{
    NSInteger retVal = 0;
    
    // Check for an ID3v2 header
    if (data.length >= 10) {
        int32_t signature;
        [data getBytes:&signature length:4];
        if ((signature >> 8 & 0xffffff) == 0x494433) {

        }
    }
    
    return retVal;
    
}

@end
