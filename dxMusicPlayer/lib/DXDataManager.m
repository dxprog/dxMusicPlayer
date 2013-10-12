//
//  DataManager.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 9/20/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXDataManager.h"

@implementation DXDataManager

- init {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:@"http://dxmp.us/api/?method=dxmp.getData&type=json"]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] != 200) {
        NSLog(@"Somting fahkked up");
    } else {
        id objData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([objData isKindOfClass:[NSDictionary class]] && [objData[@"body"] isKindOfClass:[NSArray class]]) {
            NSArray *content = [objData valueForKey:@"body"];
            NSArray *albums = [DXAlbum initFromArray:content];
            self.albums = [albums sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                DXContent *contentA = (DXContent *)obj1;
                DXContent *contentB = (DXContent *)obj2;
                return [contentA.title compare:contentB.title];
            }];
            
            self.songs = [DXSong initFromArray:content];
            
        }
    }
    
    return self;
    
}

/**
 * Singleton for internal data structure
 */
+ (instancetype)getDataManager {
    static DXDataManager* internalDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalDataManager = [[DXDataManager alloc] init];
    });
    return internalDataManager;
}

- (NSArray *)getSongsByAlbumId:(NSInteger)albumId {
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (int i = 0, count = [self.songs count]; i < count; i++) {
        DXSong *song = (DXSong *)[self.songs objectAtIndex:i];
        if ([song parent] == albumId) {
            [retVal addObject:song];
        }
    }
    return retVal;
}

- (DXAlbum *)getAlbumById:(NSInteger)albumId {
    DXAlbum *retVal = nil;
    for (int i = 0, count = [self.albums count]; i < count; i++) {
        if ([(DXContent *)[self.albums objectAtIndex:i] id] == albumId) {
            retVal = (DXAlbum *)[self.albums objectAtIndex:i];
        }
    }
    return retVal;
}

@end
