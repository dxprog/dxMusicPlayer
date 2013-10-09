//
//  DataManager.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 9/20/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

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
            NSArray *albums = [Album initFromArray:content];
            self.albums = [albums sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                Content *contentA = (Content *)obj1;
                Content *contentB = (Content *)obj2;
                return [contentA.title compare:contentB.title];
            }];
            
            self.songs = [Song initFromArray:content];
            
        }
    }
    
    return self;
    
}

/**
 * Singleton for internal data structure
 */
+ (instancetype)getDataManager {
    static DataManager* internalDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalDataManager = [[DataManager alloc] init];
    });
    return internalDataManager;
}

- (NSArray *)getSongsByAlbumId:(NSInteger)albumId {
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (int i = 0, count = [self.songs count]; i < count; i++) {
        Song *song = (Song *)[self.songs objectAtIndex:i];
        if ([song parent] == albumId) {
            [retVal addObject:song];
        }
    }
    return retVal;
}

@end
