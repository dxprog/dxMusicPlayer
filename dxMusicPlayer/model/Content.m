//
//  Content.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "Content.h"

@implementation Content



+ (NSArray *)initFromArray:(NSArray *)array {

    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (int i = 0, count = [array count]; i < count; i++) {
        Content *content = [[Content alloc] initFromDictionary:array[i]];
        if (content.title != nil) {
            [retVal addObject:content];
        }
    }

    return retVal;
}

+ (NSArray *)initFromArray:(NSArray *)array
             ByContentType:(NSString *)type {
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (int i = 0, count = [array count]; i < count; i++) {
        NSDictionary *item = (NSDictionary *)[array objectAtIndex:i];
        if ([(NSString *)[item valueForKey:@"type"] isEqualToString:type] && nil != [item valueForKey:@"title"]) {
            [retVal addObject:[[self alloc] initFromDictionary:item]];
        }
    }
    
    return retVal;
}

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

- (int)numberFromString:(NSString *)string {
    return [string intValue];
}

@end
