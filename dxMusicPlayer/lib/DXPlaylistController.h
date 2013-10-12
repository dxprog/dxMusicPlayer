//
//  Playlist.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/4/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../model/DXSong.h"
#import "PlaylistDelegate.h"
#import "DXMediaPlayer.h"
#import "MediaPlayerDelegate.h"

@interface DXPlaylistController : NSObject <DXMediaPlayerDelegate>

@property BOOL isPlaying;

- (id) init;
- (void) queueSong:(DXSong *)song;

+ (void) queueSong:(DXSong *)song;
+ (DXSong *) nextSong;
+ (NSMutableArray *)getQueue;
+ (void)setPlaylistDelegate:(id <DXPlaylistDelegate>)delegate;
+ (BOOL)getIsPlaying;

@end
