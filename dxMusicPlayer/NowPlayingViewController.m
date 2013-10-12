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

@property (weak, nonatomic) IBOutlet UITableView *lstItems;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlbumArt;
@property (weak, nonatomic) NSMutableArray *queue;

@end

@implementation NowPlayingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lstItems registerClass:[UITableViewCell class] forCellReuseIdentifier:(NSString *)TABLECELLIDENT_PLAYLIST_ITEM];
    self.lstItems.delegate = self;
    self.lstItems.dataSource = self;
    [self.lstItems reloadData];
    self.queue = [DXPlaylistController getQueue];
    [DXPlaylistController setPlaylistDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)TABLECELLIDENT_PLAYLIST_ITEM forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(NSString *)TABLECELLIDENT_PLAYLIST_ITEM];
    }
    DXSong *song = [self.queue objectAtIndex:indexPath.row];
    cell.textLabel.text = [song title];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.queue count];
}

- (void)itemQueued:(DXSong *)song {
    if (nil != song) {
        [self.lstItems reloadData];
    }
}

-(void) itemPlaying:(DXSong *)song {
    if (nil != song) {
        DXDataManager *dataManager = [DXDataManager getDataManager];
        DXAlbum *album = [dataManager getAlbumById:[song parent]];
        self.imgAlbumArt.image = [album loadAlbumArtThumbnail:350 by:350];
    }
}

@end
