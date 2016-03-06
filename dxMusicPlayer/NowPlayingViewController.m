//
//  DXMPSecondViewController.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "NowPlayingViewController.h"

const NSString *TABLECELLIDENT_PLAYLIST_ITEM = @"cellPlaylistItem";

@interface NowPlayingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAlbumArt;
@property (weak, nonatomic) IBOutlet UIImageView *imgWallpaper;
@property (weak, nonatomic) IBOutlet UILabel *lblSong;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbum;
@property (weak, nonatomic) NSMutableArray *queue;
@property (strong, nonatomic) DXProgressBar *progressBar;

@end

@implementation NowPlayingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queue = [DXPlaylistController getQueue];

    [DXPlaylistController setPlaylistDelegate:self];

    self.progressBar = [[DXProgressBar alloc] initWithFrame:self.view.frame andTabBar:[self tabBarController].tabBar];
    [self.view addSubview:self.progressBar];

    // In case music has already started playing, we need to load the info for the current song
    [self itemPlaying:[DXPlaylistController getCurrentSong]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemQueued:(DXSong *)song {
    // implementation for if something needs to be done when an item is queued
}

-(void) itemPlaying:(DXSong *)song {
    if (nil != song) {
        DXDataManager *dataManager = [DXDataManager getDataManager];
        DXAlbum *album = [dataManager getAlbumById:[song parent]];
        self.imgAlbumArt.image = [album loadAlbumArtThumbnail:350 by:350];
        self.lblAlbum.text = [album title];
        self.lblSong.text = [song title];
    }
}

- (IBAction)tapped:(UITapGestureRecognizer *)sender {
    [DXMediaPlayer togglePause];
}

- (IBAction)swiped:(UISwipeGestureRecognizer *)sender {
    [DXPlaylistController nextSong];
}

@end
