//
//  Song.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "Song.h"

@implementation Song

+ (id) initFromArray:(NSArray *) array {
    return [Song initFromArray:array ByContentType:@"song"];
}

- (instancetype) initFromDictionary:(NSDictionary *)dictionary {
    self = [super initFromDictionary:dictionary];
    self.track = [self numberFromString:[dictionary valueForKey:@"track"]];
    self.year = [self numberFromString:[dictionary valueForKey:@"year"]];
    self.disc = [self numberFromString:[dictionary valueForKey:@"disc"]];
    self.duration = [self numberFromString:[dictionary valueForKey:@"duration"]];
    self.genre = [dictionary valueForKey:@"genre"];
    return self;
}

@end
