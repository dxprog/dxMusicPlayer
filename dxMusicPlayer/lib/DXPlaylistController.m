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

/**
 Adds a song to the queue with the option of playing
 @param song The song to add to the queue
 @param play Play the song if nothing else is playing
 */
- (void)queueSong:(DXSong *)song withPlay:(BOOL)play {
    [self.queue addObject:song];
    [self.delegate itemQueued:song];
    
    // Not playing anything? Play something!
    if (self.isPlaying == NO && play) {
        [self nextSong];
    }
}

/**
 Adds a song to the queue and plays if nothing is playing
 @param song The song to add to the queue
 */
- (void) queueSong:(DXSong *)song {
    [self queueSong:song withPlay:YES];
}

/**
 Advances the playlist to the next song and plays it
 @return The song that will be played
 */
- (DXSong *) nextSong {
    DXSong *retVal = nil;
    
    // play the next song in the playlist or pick a random song
    if ([self.queue count] >= self.currentSong + 1) {
        retVal = (DXSong *)[self.queue objectAtIndex:self.currentSong];
    } else {
        retVal = [DXDataManager selectRandomSong];
        [self queueSong:retVal withPlay:NO];
    }
    
    [DXMediaPlayer playSong:retVal];
    self.isPlaying = YES;
    self.currentSong++;
    [self.delegate itemPlaying:retVal];
    
    return retVal;
}

- (void) songDidFinishPlaying {
    self.isPlaying = NO;
    [self.delegate itemPlaying:[self nextSong]];
}

/**
 Returns the song currently playing
 */
- (DXSong *) getCurrentSong {
    DXSong *retVal = nil;
    long currentSong = (long) self.currentSong;
    NSLog(@"%ld", currentSong);
    if (self.isPlaying) {
        retVal = self.queue[self.currentSong - 1];
    }
    
    return retVal;
}

/******************************************************
 * STATIC ACCESSORS                                   *
 *****************************************************/

/**
 Returns the single playlist manager instance
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
 Adds a song to the queue and plays if nothing is playing
 @param song The song to add to the queue
 */
+ (void) queueSong:(DXSong *)song {
    [[self getPlaylistManager] queueSong:song];
}

/**
 Advances the playlist to the next song and plays it
 @return The song that will be played
 */
+ (DXSong *) nextSong {
    return [[self getPlaylistManager] nextSong];
}

/**
 Get the internal playlist queue
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

/**
 Returns the current playing status of the player
 */
+ (BOOL)getIsPlaying {
    return [[self getPlaylistManager] isPlaying];
}

/**
 Returns the song currently playing
 */
+ (DXSong *) getCurrentSong {
    return [[self getPlaylistManager] getCurrentSong];
}

@end
