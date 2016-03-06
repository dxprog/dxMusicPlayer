//
//  DXMPID3Parser.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 2/3/14.
//  Copyright (c) 2014 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdint.h>

@interface DXID3Parser : NSObject

+ (NSInteger) getID3HeaderSize:(NSData *) data;

@end
