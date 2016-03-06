//
//  DXTrendingListViewController.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 12/8/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXTrendingListViewController.h"

@interface DXTrendingListViewController ()

@end

@implementation DXTrendingListViewController

- (void)viewDidLoad
{
    
    [super loadFromListURL:@"method=stats.getBest" withTitle:@"Trending"];
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
