//
//  Song.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXSong.h"

@implementation DXSong

+ (id) initFromArray:(NSArray *) array {
    return [DXSong initFromArray:array ByContentType:@"song"];
}

- (instancetype) initFromDictionary:(NSDictionary *)dictionary {
    self = [super initFromDictionary:dictionary];
    self.track = [self numberFromString:[self.meta valueForKey:@"track"]];
    self.year = [self numberFromString:[self.meta valueForKey:@"year"]];
    self.disc = [self numberFromString:[self.meta valueForKey:@"disc"]];
    self.duration = [self numberFromString:[self.meta valueForKey:@"duration"]];
    self.genre = [self.meta valueForKey:@"genre"];
    self.filename = [self.meta valueForKey:@"filename"];
    return self;
}

@end
