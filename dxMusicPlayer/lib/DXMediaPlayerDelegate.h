//
//  MediaPlayerDelegate.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/12/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../model/DXSong.h"

@protocol DXMediaPlayerDelegate <NSObject>

- (void) songDidFinishPlaying;

@end
