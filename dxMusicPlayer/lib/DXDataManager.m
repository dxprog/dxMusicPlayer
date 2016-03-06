//
//  DataManager.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 9/20/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXDataManager.h"

@interface DXDataManager()

@property (nonatomic) NSMutableArray *searchCache;
@property (nonatomic) NSString *lastSearchTerm;

@end

@implementation DXDataManager

/**
 Loads data from the server and populates internal caches
 */
- (id)init {
    NSObject *data = [DXApiRequest fetchDataFromApi:@"method=dxmp.getData&musicOnly"];
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *content = (NSArray *)data;
        NSArray *albums = [DXAlbum initFromArray:content];
        self.albums = [albums sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            DXContent *contentA = (DXContent *)obj1;
            DXContent *contentB = (DXContent *)obj2;
            return [contentA.title compare:contentB.title];
        }];
        self.songs = [DXSong initFromArray:content];
    }
    
    return self;
}

/**
 Returns a random song
 */
+ (DXSong *)selectRandomSong {
    DXDataManager *manager = [DXDataManager getDataManager];
    int songIndex = arc4random() % [manager.songs count];
    return [manager.songs objectAtIndex:songIndex];
}

/**
 Singleton for internal data structure
 */
+ (instancetype)getDataManager {
    static DXDataManager* internalDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalDataManager = [[DXDataManager alloc] init];
    });
    return internalDataManager;
}

/**
 Gets songs by album ID
 @param albumId Album ID to check against
 */
- (NSArray *)getSongsByAlbumId:(NSInteger)albumId {
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (long i = 0, count = [self.songs count]; i < count; i++) {
        DXSong *song = (DXSong *)[self.songs objectAtIndex:i];
        if ([song parent] == albumId) {
            [retVal addObject:song];
        }
    }
    return retVal;
}

/**
 Returns an album by ID
 @param albumId Album ID to check against
 */
- (DXAlbum *)getAlbumById:(NSInteger)albumId {
    return (DXAlbum *)[self getContent:_albums byId:albumId];
}

/**
 Returns a song by ID
 @param songId Song ID to check against
 */
- (DXSong *)getSongById:(NSInteger)songId {
    return (DXSong *)[self getContent:_songs byId:songId];
}

/**
 Returns any piece of content from an array by ID
 @param source The array to search through
 @param contentId The ID to check against
 */
- (DXContent *)getContent:(NSArray *)source byId:(NSInteger)contentId {
    DXContent *retVal = nil;
    for (long i = 0, count = [source count]; i < count; i++) {
        if ([(DXContent *)[source objectAtIndex:i] id] == contentId) {
            retVal = (DXAlbum *)[source objectAtIndex:i];
        }
    }
    return retVal;
}

/**
 Retrieves a song list URL and returns the songs as an array of DXSongs
 @param url List endpoint to hit
 */
- (NSMutableArray *)loadSongsFromListURL:(NSString *)url {
    NSMutableArray *retVal = nil;
    NSObject *result = [DXApiRequest fetchDataFromApi:url];
    if ([result isKindOfClass:[NSArray class]]) {
        retVal = [[NSMutableArray alloc] init];
        for (NSDictionary *song in (NSArray *)result) {
            NSInteger id = [self numberFromString:song[@"id"]];
            DXSong *song = [self getSongById:id];
            if (nil != song) {
                [retVal addObject:song];
            }
        }
    }
    return retVal;
}

// TODO - add this to a helper lib somewhere
- (NSInteger)numberFromString:(NSString *)string {
    NSInteger retVal = nil;
    if (![string isEqual:[NSNull null]]) {
        retVal = [string intValue];
    }
    return retVal;
}

/**
 Returns a list of songs matching the passed in terms
 @param terms The terms to search for
 */
- (NSMutableArray *)searchSongs:(NSString *)terms {

    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    if ([terms length] > 0) {
        NSMutableArray *searchBucket = self.searchCache;
        
        // Clear the old search cache for new terms and search all songs
        if ((![terms isEqualToString:self.lastSearchTerm] && [terms length] < [self.lastSearchTerm length]) || nil == self.searchCache || [terms length] == 1) {
            self.searchCache = [[NSMutableArray alloc] init];
            searchBucket = (NSMutableArray *)self.songs;
        }
        
        for (DXSong *song in searchBucket) {
            NSRange cmpRange = [song.title rangeOfString:terms options:NSCaseInsensitiveSearch];
            if (cmpRange.location == 0) {
                [retVal addObject:song];
            }
        }
        
        // Set the search cache to the current results and save the search terms (only if there were results)
        if ([retVal count] > 0) {
            self.searchCache = retVal;
            self.lastSearchTerm = terms;
        }
    }
    
    return retVal;
}

@end
