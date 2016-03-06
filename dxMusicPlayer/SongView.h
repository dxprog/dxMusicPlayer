//
//  SongView.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 9/24/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/DXAlbum.h"
#import "lib/DXPlaylistController.h"

@interface SongView : UITableViewController

- (id)initFromAlbum:(DXAlbum *)album;
- (void)loadFromListURL:(NSString *)endPoint withTitle:(NSString *)title;

@end
