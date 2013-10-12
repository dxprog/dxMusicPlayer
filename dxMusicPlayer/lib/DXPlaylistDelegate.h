//
//  PlaylistDelegate.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/8/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../model/Song.h"

@protocol DXPlaylistDelegate <NSObject>

- (void)itemQueued:(Song *)song;
- (void)itemPlaying:(Song *)song;

@end
