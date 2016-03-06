//
//  Album.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXAlbum.h"

@implementation DXAlbum

/**
 Takes an array of dictionary objects and returns an array of albums
 @overload
 @param array Array to parse
 */
+ (NSArray *)initFromArray:(NSArray *)array {
    return [DXAlbum initFromArray:array ByContentType:@"album"];
}

/**
 Creates an album object from a dictionary
 @overload
 @param dictionary Dictionary to populate object data from
 */
- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super initFromDictionary:dictionary];
    
    if (nil != self.meta) {
        self.artwork = [self.meta valueForKey:@"art"];
        self.wallpaper = [self.meta valueForKey:@"wallpaper"];
    }
    
    return self;
}

/**
 Loads an image either from the server or from local cache
 */
- (UIImage *)loadAlbumArtThumbnail {
    return [self loadAlbumArtThumbnail:76 by:76];
}

/**
 Loads an image either from the server or from local cache with custom size
 @param width Image width in pixels
 @param height Image height in pixels
 */
- (UIImage *)loadAlbumArtThumbnail:(NSInteger) width by:(NSInteger)height {
    // Check for cached data
    UIImage *retVal = nil;
    if (nil != self.artwork) {
        long lWidth = (long) width;
        long lHeight = (long) height;
        NSString *fileName = [NSString stringWithFormat:@"%ld_%ld_%@", lWidth, lHeight, self.artwork];
        NSData *cache = [DXFileIOHelper loadDataFromFile:fileName];
        if (nil == cache) {
            NSString *url = [NSString stringWithFormat:@"http://dxmp.us/thumb.php?width=%ld&height=%ld&file=%@", lWidth, lHeight, self.artwork];
            cache = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            [DXFileIOHelper saveData:cache toFile:fileName];
        }
        retVal = [UIImage imageWithData:cache];
    }
    return retVal;
}

@end
