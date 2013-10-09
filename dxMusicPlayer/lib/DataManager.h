//
//  DataManager.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 9/20/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../model/Content.h"
#import "../model/Album.h"
#import "../model/Song.h"

@interface DataManager : NSObject

@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) NSArray *songs;

- (id)init;
+ (instancetype)getDataManager;
- (NSArray *)getSongsByAlbumId:(NSInteger)albumId;

@end
