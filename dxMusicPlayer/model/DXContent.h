//
//  Content.h
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXContent : NSObject

@property (nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *perma;
@property (strong, nonatomic) NSString *type;
@property (nonatomic) NSInteger date;
@property (nonatomic) NSInteger parent;
@property (strong, nonatomic) NSDictionary *meta;

+ (NSMutableArray *) initFromArray:(NSArray *)array;
+ (NSMutableArray *) initFromArray:(NSArray *)array ByContentType:(NSString *)type;
- (instancetype) initFromDictionary:(NSDictionary *)dictionary;
- (NSInteger)numberFromString:(NSString *)string;

@end
