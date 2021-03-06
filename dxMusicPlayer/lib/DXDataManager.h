//
//  DataManager.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 9/20/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../model/DXContent.h"
#import "../model/DXAlbum.h"
#import "../model/DXSong.h"
#import "DXApiRequest.h"

@interface DXDataManager : NSObject

@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) NSArray *songs;

- (id)init;
+ (instancetype)getDataManager;
+ (DXSong *)selectRandomSong;
- (NSArray *)getSongsByAlbumId:(NSInteger)albumId;
- (DXAlbum *)getAlbumById:(NSInteger)albumId;
- (DXSong *)getSongById:(NSInteger)songId;
- (DXContent *)getContent:(NSArray *)source byId:(NSInteger)contentId;
- (NSMutableArray *)loadSongsFromListURL:(NSString *)url;
- (NSMutableArray *)searchSongs:(NSString *)terms;

@end
