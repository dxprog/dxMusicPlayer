//
//  Album.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXContent.h"
#import "../lib/DXFileIOHelper.h"

@interface DXAlbum : DXContent

@property (strong, nonatomic) NSString *artwork;
@property (strong, nonatomic) NSString *wallpaper;

+ (NSArray *)initFromArray:(NSArray *)content;
- (UIImage *)loadAlbumArtThumbnail;
- (UIImage *)loadAlbumArtThumbnail:(NSInteger)width by:(NSInteger)height;
- (instancetype) initFromDictionary:(NSDictionary *)dictionary;

@end
