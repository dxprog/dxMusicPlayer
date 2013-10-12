//
//  DXMPFirstViewController.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "AlbumViewController.h"

const NSString *TABLECELLIDENT_ALBUM = @"cellAlbum";

@interface AlbumViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *lstItems;
@property (weak, nonatomic) DXDataManager *dataManager;
@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:(NSString *)TABLECELLIDENT_ALBUM];
    self.lstItems.delegate = self;
    self.dataManager = [DXDataManager getDataManager];
    [self.lstItems reloadData];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataManager albums] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    DXAlbum *item = (DXAlbum *)[[self.dataManager albums] objectAtIndex:indexPath.row];
    SongView *newView = [[SongView alloc] initFromAlbum:item];
    [[self navigationController] pushViewController:newView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
