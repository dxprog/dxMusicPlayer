//
//  Song.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXContent.h"

@interface DXSong : DXContent

@property (nonatomic) NSInteger track;
@property (nonatomic) NSInteger disc;
@property (nonatomic) NSInteger year;
@property (strong, nonatomic) NSString *genre;
@property (nonatomic) NSInteger duration;
@property (strong, nonatomic) NSString *filename;

+ (id) initFromArray:(NSArray *) array;
- (instancetype) initFromDictionary:(NSDictionary *)dictionary;

@end
