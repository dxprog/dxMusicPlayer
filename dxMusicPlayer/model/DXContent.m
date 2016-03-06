//
//  Content.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXContent.h"

@implementation DXContent

/**
 Takes an array of dictionary objects and returns an array of DXContent
 @param array Array of objects to convert
 */
+ (NSArray *)initFromArray:(NSArray *)array {

    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (long i = 0, count = [array count]; i < count; i++) {
        DXContent *content = [[DXContent alloc] initFromDictionary:array[i]];
        if (content.title != nil) {
            [retVal addObject:content];
        }
    }

    return retVal;
}

/**
 Takes an array of content and builds an array of DXContent filtering by content type
 @param array Array of objects to convert
 @param type Content type to filter for
 */
+ (NSArray *)initFromArray:(NSArray *)array
             ByContentType:(NSString *)type {
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (long i = 0, count = [array count]; i < count; i++) {
        NSDictionary *item = (NSDictionary *)[array objectAtIndex:i];
        if ([(NSString *)[item valueForKey:@"type"] isEqualToString:type] && nil != [item valueForKey:@"title"]) {
            [retVal addObject:[[self alloc] initFromDictionary:item]];
        }
    }
    
    return retVal;
}

/**
 Creates a DXContent object from  a dictionary
 @param dictionary Dictionary to populate data from
 */
- (id)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.id = [self numberFromString:[dictionary valueForKey:@"id"]];
    self.title = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"title"]];
    self.perma = [dictionary valueForKey:@"perma"];
    self.type = [dictionary valueForKey:@"type"];
    self.meta = [dictionary valueForKey:@"meta"];
    self.date = [self numberFromString:[dictionary valueForKey:@"date"]];
    self.parent = [self numberFromString:[dictionary valueForKey:@"parent"]];
    
    return self;
}

/**
 @todo move to generic library
 */
- (NSInteger)numberFromString:(NSString *)string {
    NSInteger retVal = nil;
    if (![string isEqual:[NSNull null]]) {
        retVal = [string intValue];
    }
    return retVal;
}

@end
