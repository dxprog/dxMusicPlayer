//
//  DXProgressBar.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 11/3/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXProgressBar.h"

@interface DXProgressBar()

@property (strong, nonatomic) UIColor *playbackColor;
@property (strong, nonatomic) UIColor *bufferColor;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DXProgressBar

- (id)initWithFrame:(CGRect)frame andTabBar:(UITabBar *)tabBar
{
    self = [super initWithFrame:frame];

    if (self) {
        self.frame = CGRectMake(0.0, self.frame.size.height - tabBar.frame.size.height - 5.0, self.frame.size.width, 5.0);
        self.playbackColor = [UIColor colorWithRed:0.368627 green:0.878431 blue:0.796078 alpha:1];
        self.bufferColor = [UIColor colorWithRed:0.368627 green:0.878431 blue:0.796078 alpha:0.5];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                      target:self
                                                    selector:@selector(updateProgress:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Clear the background
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, rect);
    
    [self drawProgressRect:1 withColor:self.bufferColor];
    [self drawProgressRect:[DXMediaPlayer getPlaybackPercent] withColor:self.playbackColor];
}

- (void)updateProgress:(NSTimer *)timer {
    [self setNeedsDisplay];
}

- (void)drawProgressRect:(double)percent withColor:(UIColor *)color {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect draw = CGRectMake(0, 0, self.frame.size.width * percent, 5.0);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, draw);
}

@end
