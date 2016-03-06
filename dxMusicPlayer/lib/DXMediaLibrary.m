//
//  DXMediaLibrary.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/12/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXMediaLibrary.h"

@implementation DXMediaLibrary

/**
 Performs a search of local media to see if a song can be played off the device
 @param song The song to search for
 */
+ (NSURL *)getLocalVersionOfSong:(DXSong *)song {
    NSURL *retVal = nil;
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[song title]
                                                               forProperty:MPMediaItemPropertyTitle]];
    [query setGroupingType:MPMediaGroupingTitle];
    NSArray *matches = [query collections];
    for (MPMediaItemCollection *songs in matches) {
        if ([[songs items] count] > 0) {
            // Loop through each song and select the one that has the matching album
            DXAlbum *album = [[DXDataManager getDataManager] getAlbumById:[song parent]];
            for (MPMediaItem *song in songs.items) {
                NSString *albumTitle = (NSString *)[song valueForProperty:MPMediaItemPropertyAlbumTitle];
                if ([albumTitle isEqualToString:[album title]]) {
                    retVal = [song valueForProperty:MPMediaItemPropertyAssetURL];
                    break;
                }
            }
        }
        
        if (nil != retVal) {
            break;
        }
        
    }
    return retVal;
}

@end
