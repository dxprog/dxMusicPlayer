//
//  Playlist.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/4/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXPlaylistController.h"

@interface DXPlaylistController()

@property (strong, nonatomic) NSMutableArray *queue;
@property NSInteger currentSong;
@property (weak, nonatomic) id <DXPlaylistDelegate> delegate;

@end

@implementation DXPlaylistController

- (id) init {
    self = [super init];
    self.queue = [[NSMutableArray alloc] init];
    [DXMediaPlayer setDelegate:self];
    return self;
}

- (void) queueSong:(DXSong *)song {
    [self.queue addObject:song];
    [self.delegate itemQueued:song];
    
    // Not playing anything? Play something!
    if (self.isPlaying == NO) {
        [self nextSong];
    }
}

- (DXSong *) nextSong {
    DXSong *retVal = nil;
    if ([self.queue count] >= self.currentSong + 1) {
        retVal = (DXSong *)[self.queue objectAtIndex:self.currentSong];
        [DXMediaPlayer playSong:retVal];
        self.isPlaying = YES;
        self.currentSong++;
        [self.delegate itemPlaying:retVal];
    }
    return retVal;
}

- (void) songDidFinishPlaying {
    self.isPlaying = NO;
    [self.delegate itemPlaying:[self nextSong]];
}

/******************************************************
 * STATIC METHODS                                     *
 *****************************************************/

/**
 * Singleton instance of playlist
 */
+ (id) getPlaylistManager {
    static DXPlaylistController* internalPlaylist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalPlaylist = [[DXPlaylistController alloc] init];
    });
    return internalPlaylist;
}

/**
 * Adds a song to the queue
 */
+ (void) queueSong:(DXSong *)song {
    [[self getPlaylistManager] queueSong:song];
}

+ (DXSong *) nextSong {
    return [[self getPlaylistManager] nextSong];
}

/**
 * Returns a pointer to the internal song queue
 */
+ (NSMutableArray *)getQueue {
    return [[self getPlaylistManager] queue];
}

/**
 * Sets the delegate for the playlist lib. There can be only one!
 */
+ (void)setPlaylistDelegate:(id <DXPlaylistDelegate>)delegate {
    [[self getPlaylistManager] setDelegate:delegate];
}

+ (BOOL)getIsPlaying {
    return [[self getPlaylistManager] isPlaying];
}

@end
