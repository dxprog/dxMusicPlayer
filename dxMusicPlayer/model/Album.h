//
//  Album.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "Content.h"

@interface Album : Content

@property (strong, nonatomic) NSString *artwork;
@property (strong, nonatomic) NSString *wallpaper;

+ (NSArray *)initFromArray:(NSArray *)content;
+ (UIImage *)loadAlbumArtThumbnail:(NSString *)fileName;
- (instancetype) initFromDictionary:(NSDictionary *)dictionary;

@end
