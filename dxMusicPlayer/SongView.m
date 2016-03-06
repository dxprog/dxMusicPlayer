//
//  SongView.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 9/24/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "SongView.h"
#import "model/DXAlbum.h"
#import "lib/DXDataManager.h"

const NSString *TABLECELLIDENT_SONG = @"songCell";

@interface SongView ()

@property (nonatomic, strong) NSArray *content;
@property (nonatomic, weak) DXDataManager *dataManager;
@property (nonatomic) BOOL isCreatedFromAlbum;

@end

@implementation SongView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initFromAlbum:(DXContent *)album {
    self = [super initWithStyle:UITableViewCellStyleDefault];
    self.dataManager = [DXDataManager getDataManager];
    self.title = album.title;
    if (nil != album) {
        self.content = [self.dataManager getSongsByAlbumId:[album id]];
    }
    self.isCreatedFromAlbum = YES;
    return self;
}

- (void)loadFromListURL:(NSString *)endPoint withTitle:(NSString *)title {
    self.title = title;
    self.dataManager = [DXDataManager getDataManager];
    self.content = [self.dataManager loadSongsFromListURL:endPoint];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:(NSString *)TABLECELLIDENT_SONG];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)TABLECELLIDENT_SONG forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(NSString *)TABLECELLIDENT_SONG];
    }
    
    DXContent *item = (DXContent *)[self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    
    // Anything that's not an album view (lists of various kinds) get album art since each song can be from a different album
    if (!self.isCreatedFromAlbum) {
        DXAlbum *album = [self.dataManager getAlbumById:item.parent];
        cell.imageView.image = [album loadAlbumArtThumbnail];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DXSong *song = [self.content objectAtIndex:indexPath.row];
    if (nil != song) {
        [DXPlaylistController queueSong:song];
    }
}

@end
