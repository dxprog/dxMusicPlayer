//
//  DXMPFirstViewController.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "AlbumViewController.h"

const NSString *TABLECELLIDENT_ALBUM = @"cellAlbum";
const NSString *TABLECELLIDENT_SEARCH = @"cellSearch";

@interface AlbumViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *lstItems;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;
@property (weak, nonatomic) DXDataManager *dataManager;
@property (weak, nonatomic) NSMutableArray *searchResults;
@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:(NSString *)TABLECELLIDENT_ALBUM];
    self.lstItems.delegate = self;
    self.dataManager = [DXDataManager getDataManager];
    [self.lstItems reloadData];
    self.title = @"Albums";
    
    // Search bar
    self.searchBarController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchBarController.delegate = self;
    self.searchBarController.searchResultsDataSource = self;
    self.searchBarController.searchResultsDelegate = self;
    [self.searchBarController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:(NSString *)TABLECELLIDENT_SEARCH];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchBarController.searchResultsTableView) {
        return [self.searchResults count];
    }
    return [[self.dataManager albums] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchBarController.searchResultsTableView) {
        return [self tableView:tableView songCellForRowAtIndexPath:indexPath];
        
    }
    return [self tableView:tableView albumCellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView albumCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)TABLECELLIDENT_ALBUM forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(NSString *)TABLECELLIDENT_ALBUM];
    }
    
    
    DXAlbum *item = (DXAlbum *)[[self.dataManager albums] objectAtIndex:indexPath.row];
    cell.textLabel.text = [item title];
    cell.imageView.image = [item loadAlbumArtThumbnail];
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchBarController.searchResultsTableView) {
        [self songSelectedAtIndexPath:indexPath];
        return;
    }
    [self albumSelectedAtIndexPath:indexPath];
}

- (void)albumSelectedAtIndexPath:(NSIndexPath *)indexPath {
    DXAlbum *item = (DXAlbum *)[[self.dataManager albums] objectAtIndex:indexPath.row];
    SongView *newView = [[SongView alloc] initFromAlbum:item];
    [[self navigationController] pushViewController:newView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Search bar delegate callbacks (or whatever they're called)
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchResults = [self.dataManager searchSongs:searchText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView songCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)TABLECELLIDENT_SEARCH forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(NSString *)TABLECELLIDENT_SEARCH];
    }
    
    DXContent *item = (DXContent *)[self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    DXAlbum *album = [self.dataManager getAlbumById:item.parent];
    cell.imageView.image = [album loadAlbumArtThumbnail];
    
    return cell;
}

- (void)songSelectedAtIndexPath:(NSIndexPath *)indexPath {
    DXSong *song = [self.searchResults objectAtIndex:indexPath.row];
    if (nil != song) {
        [DXPlaylistController queueSong:song];
    }
}

@end
