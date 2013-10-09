//
//  Song.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "Content.h"

@interface Song : Content

@property (nonatomic) NSInteger track;
@property (nonatomic) NSInteger disc;
@property (nonatomic) NSInteger year;
@property (strong, nonatomic) NSString *genre;
@property (nonatomic) NSInteger duration;

+ (id) initFromArray:(NSArray *) array;
- (instancetype) initFromDictionary:(NSDictionary *)dictionary;

@end
