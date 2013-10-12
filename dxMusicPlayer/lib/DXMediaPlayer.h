//
//  MediaLibrary.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/4/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "../model/DXSong.h"
#import "MediaPlayerDelegate.h"

@interface DXMediaPlayer : NSObject

+ (void)setDelegate:(id <DXMediaPlayerDelegate>) delegate;
+ (void)playSong:(DXSong *) song;

@end
