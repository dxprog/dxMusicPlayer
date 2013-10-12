//
//  DXMPSecondViewController.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lib/DXPlaylistController.h"
#import "lib/PlaylistDelegate.h"
#import "model/DXAlbum.h"
#import "lib/DXDataManager.h"
#import "lib/DXMediaPlayer.h"

@interface NowPlayingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DXPlaylistDelegate>

@end
