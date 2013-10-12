//
//  Album.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXAlbum.h"

@implementation DXAlbum

+ (NSArray *)initFromArray:(NSArray *)array {
    return [DXAlbum initFromArray:array ByContentType:@"album"];
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super initFromDictionary:dictionary];
    
    if (nil != self.meta) {
        self.artwork = [self.meta valueForKey:@"art"];
        self.wallpaper = [self.meta valueForKey:@"wallpaper"];
    }
    
    return self;
}

/**
 * Loads an image either from the server or from local cache
 */
- (UIImage *)loadAlbumArtThumbnail {
    return [self loadAlbumArtThumbnail:76 by:76];
}

/**
 * Loads an image either from the server or from local cache
 */
- (UIImage *)loadAlbumArtThumbnail:(NSInteger) width by:(NSInteger)height {
    // Check for cached data
    UIImage *retVal = nil;
    if (nil != self.artwork) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *localFileName = [NSString stringWithFormat:@"%@/%d_%d_%@", docDir, width, height, self.artwork];
        NSData *cache = [NSData dataWithContentsOfFile:localFileName];
        if (nil == cache) {
            NSString *url = [NSString stringWithFormat:@"http://dxmp.us/thumb.php?width=%d&height=%d&file=%@", width, height, self.artwork];
            cache = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            [cache writeToFile:localFileName atomically:YES];
        }
        retVal = [UIImage imageWithData:cache];
    }
    return retVal;
}

@end
