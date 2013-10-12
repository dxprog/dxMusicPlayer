//
//  MediaLibrary.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/4/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXMediaPlayer.h"

@interface DXMediaPlayer() <NSURLConnectionDataDelegate, AVAudioPlayerDelegate>

@property AVAudioPlayer *player;

@property void *songBytes;
@property (strong, nonatomic) NSData *songBuffer;
@property NSUInteger bytesLoaded;
@property NSUInteger bytesTotal;
@property (weak, nonatomic) id <DXMediaPlayerDelegate> delegate;

@end

@implementation DXMediaPlayer

- (void)playSong:(DXSong *)song {
    NSString *url = [NSString stringWithFormat:@"http://dxmp.s3.amazonaws.com/songs/%@", [song filename]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
    // [self.player play];
}

+ (void)playSong:(DXSong *)song {
    [[DXMediaPlayer getInstance] playSong:song];
}

+ (void)setDelegate:(id <DXMediaPlayerDelegate>)delegate {
    DXMediaPlayer *player = [DXMediaPlayer getInstance];
    player.delegate = delegate;
}

/**
 * Singleton for internal data structure
 */
+ (instancetype)getInstance {
    static DXMediaPlayer *internalMediaPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalMediaPlayer = [[DXMediaPlayer alloc] init];
    });
    return internalMediaPlayer;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Allocate enough space for the MP3 data
    [self cleanUpMemory];
    self.bytesTotal = [response expectedContentLength];
    self.songBytes = malloc(self.bytesTotal);
    self.songBuffer = [[NSData alloc] initWithBytesNoCopy:self.songBytes length:self.bytesTotal];
    self.bytesLoaded = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    memcpy(&_songBytes[self.bytesLoaded], data.bytes, data.length);
    self.bytesLoaded += data.length;
    // Start playing after a 256KB buffer
    if (self.bytesLoaded > 262144 && nil == self.player) {
        NSError *err = nil;
        self.player = [[AVAudioPlayer alloc] initWithData:self.songBuffer error:&err];
        self.player.delegate = self;
        if (nil == self.player) {
            NSLog([err localizedFailureReason]);
        } else {
            @try {
                [self.player prepareToPlay];
                [self.player play];
            }
            @catch (NSException *e) {
                NSLog(@"%@", e);
            }
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Encode error");
    [self cleanUpMemory];
    [self.delegate songDidFinishPlaying];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Song done");
    [self cleanUpMemory];
    [self.delegate songDidFinishPlaying];
}

- (void)cleanUpMemory {
    // Free up all our memory
    NSLog(@"Stopping playing");
    [self.player stop];
    NSLog(@"Nulling player");
    self.player = nil;
    NSLog(@"Nulling song buffer");
    self.songBuffer = nil;
}

@end
