//
//  DXMPFirstViewController.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 8/26/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXMPFirstViewController.h"
#import "model/Content.h"

@interface DXMPFirstViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *lstItems;
@property (strong, nonatomic) NSMutableArray *content;
@end

@implementation DXMPFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
            self.content = [Content initFromArray:[objData valueForKey:@"body"] ByContentType:@"album"];
            self.content = [self.content sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                Content *contentA = (Content *)obj1;
                Content *contentB = (Content *)obj2;
                return [contentA.title compare:contentB.title];
            }];
        }
        
        
    }
    
    _lstItems.delegate = self;
    [self.lstItems reloadData];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Album"];
    }
    
    
    Content *item = (Content *)[self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = [item title];
    
    NSString *art = [[item meta] valueForKey:@"art"];
    if (nil != art) {
        cell.imageView.image = [self loadAlbumArtThumbnail:art];
    }
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Content *item = (Content *)[self.content objectAtIndex:indexPath.row];
    DXMPFirstViewController *newView = [[DXMPFirstViewController alloc] init];
}

/**
 * Loads an image either from the server or from local cache
 */
- (UIImage *)loadAlbumArtThumbnail:(NSString *)fileName {
    // Check for cached data
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *localFileName = [NSString stringWithFormat:@"%@/76_76_%@", docDir, fileName];
    NSData *cache = [NSData dataWithContentsOfFile:localFileName];
    if (nil == cache) {
        NSString *url = [NSString stringWithFormat:@"%@%@",  @"http://dxmp.us/thumb.php?width=76&height=76&file=", fileName];
        cache = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [cache writeToFile:localFileName atomically:YES];
    }
    return [UIImage imageWithData:cache];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
