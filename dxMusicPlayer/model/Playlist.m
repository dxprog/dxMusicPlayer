//
//  Playlist.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/4/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "Playlist.h"

@interface Playlist()

@property NSMutableArray *queue;
@property NSInteger currentSong;

@end

@implementation Playlist

+ (void) queueSong:(Song *)song {
    Playlist *playlist = [self getPlaylistManager];
    [playlist.queue addObject:song];
}

+ (Song *) nextSong {
    Playlist *playlist = [self getPlaylistManager];
    Song *retVal = nil;
    if ([playlist.queue count] > playlist.currentSong - 1) {
        playlist.currentSong++;
        retVal = (Song *)[playlist.queue objectAtIndex:playlist.currentSong];
    }
    return retVal;
}

/**
 * Singleton instance of playlist
 */
+ (id) getPlaylistManager {
    static Playlist* internalPlaylist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalPlaylist = [[Playlist alloc] init];
    });
    return internalPlaylist;
}

/**
 * Returns a pointer to the internal song queue
 */
+ (NSMutableArray *)getQueue {
    return [[self getPlaylistManager] queue];
}

@end
