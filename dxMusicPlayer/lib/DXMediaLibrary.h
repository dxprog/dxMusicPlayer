//
//  DXMediaLibrary.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/12/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "../model/DXSong.h"
#import "../model/DXAlbum.h"
#import "DXDataManager.h"

@interface DXMediaLibrary : NSObject

+ (NSURL *)getLocalVersionOfSong:(DXSong *)song;

@end
