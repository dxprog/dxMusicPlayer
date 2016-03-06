//
//  PlaylistDelegate.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/8/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../model/DXSong.h"

@protocol DXPlaylistDelegate <NSObject>

- (void)itemQueued:(DXSong *)song;
- (void)itemPlaying:(DXSong *)song;

@end
