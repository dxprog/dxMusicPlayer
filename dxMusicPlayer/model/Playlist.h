//
//  Playlist.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/4/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../model/Song.h"

@interface Playlist : NSObject

+ (void) queueSong:(Song *)song;
+ (Song *) nextSong;

@end
