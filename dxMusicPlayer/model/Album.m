//
//  Album.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "Album.h"

@implementation Album

+ (NSArray *)initFromArray:(NSArray *)array {
    return [Album initFromArray:array ByContentType:@"album"];
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super initFromDictionary:dictionary];
    
    self.artwork = [dictionary valueForKey:@"art"];
    self.wallpaper = [dictionary valueForKey:@"wallpaper"];
    
    return self;
}

/**
 * Loads an image either from the server or from local cache
 */
+ (UIImage *)loadAlbumArtThumbnail:(NSString *)fileName {
    // Check for cached data
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *localFileName = [NSString stringWithFormat:@"%@/76_76_%@", docDir, fileName];
    NSData *cache = [NSData dataWithContentsOfFile:localFileName];
    if (nil == cache) {
        NSString *url = [NSString stringWithFormat:@"%@%@",  @"http://dxmp.us/thumb.php?width=76&height=76&file=", fileName];
        cache = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [cache writeToFile:localFileName atomically:YES];
    }
    return [UIImage imageWithData:cache];
}

@end
