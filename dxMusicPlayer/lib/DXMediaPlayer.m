//
//  MediaLibrary.m
//  dxMusicPlayer
//
//  Created by Matt Hackmann on 10/4/13.
//  Copyright (c) 2013 Matt Hackmann. All rights reserved.
//

#import "DXMediaPlayer.h"

@interface DXMediaPlayer() <NSURLConnectionDataDelegate, AVAudioPlayerDelegate>

@property AVQueuePlayer *player;
@property (weak, nonatomic) id <DXMediaPlayerDelegate> delegate;
@property (weak, nonatomic) DXSong *currentSong;
@property (strong, nonatomic) NSString *userName;

@end

@implementation DXMediaPlayer

/**
 Plays a song
 @param song The song to play
 */
+ (void)playSong:(DXSong *)song {
    [[DXMediaPlayer getInstance] playSong:song];
}

/**
 Sets the player delegate on the singleton instance
 @param delegate Delegate to set
 */
+ (void)setDelegate:(id <DXMediaPlayerDelegate>)delegate {
    DXMediaPlayer *player = [DXMediaPlayer getInstance];
    player.delegate = delegate;
}

/**
 Pauses/plays the music depending on play state
 @todo name doesn't reflect action; rename
 */
+ (void)togglePause {
    [[DXMediaPlayer getInstance] togglePause];
}

/**
 Singleton for internal data structure
 */
+ (instancetype)getInstance {
    static DXMediaPlayer *internalMediaPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalMediaPlayer = [[DXMediaPlayer alloc] init];
    });
    return internalMediaPlayer;
}

/**
 Returns the percentage of playback through the current song
 */
+ (double)getPlaybackPercent {
    return [[DXMediaPlayer getInstance] getPlaybackPercent];
}

/**
 Initializes the player and the audio session
 */
- (id)init {
    self = [super init];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.userName = @"Matt";
    return self;
}

/**
 Begins playback of a song
 @param song The song to play
 */
- (void)playSong:(DXSong *)song {
    
    // Check to see if a song is currently playing and clean up as necessary
    if ([self isPlaying]) {
        NSLog(@"Is playing, cleaning up");
        [self.player removeAllItems];
        self.currentSong = nil;
    }
    
    // If the song isn't on the device, load it from the cloud
    NSURL *songUrl = [DXMediaLibrary getLocalVersionOfSong:song];
    self.currentSong = song;
    long songId = (long) [song id];
    NSString *apiUrl = nil;
    if (nil == songUrl) {
        NSLog(@"Unable to find song locally. Getting from server");
        apiUrl = [NSString stringWithFormat:@"http://dxmp.us/api/?type=xml&method=dxmp.getTrackFile&id=%ld&userName=%@", songId, self.userName];
        songUrl = [NSURL URLWithString:apiUrl];
    } else {
        // Ping the server for play logging
        NSLog(@"Song was found locally. Playing");
        apiUrl = [NSString stringWithFormat:@"method=dxmp.getTrackFile&id=%ld&userName=%@", songId, self.userName];
        [DXApiRequest fetchDataFromApi:apiUrl withHTTPMethod:@"HEAD"];
    }
    
    NSLog(@"Creating player...");
    
    if (nil == self.player) {
        self.player = [[AVQueuePlayer alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songDidFinishPlaying:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.player.currentItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeDidChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    }
    
    [self.player insertItem:[AVPlayerItem playerItemWithURL:songUrl] afterItem:nil];
    
    NSLog(@"Playing...");
    [self.player play];
    [self setSongMetaInfo:song];
    
}

/**
 Plays/pauses playback
 */
- (void)togglePause {
    if (self.player) {
        if (self.isPlaying) {
            [self.player pause];
        } else {
            [self.player play];
        }
    }
}

/**
 Returns the current playing state
 */
- (BOOL)isPlaying {
    return [self.player rate];
}

/**
 Notification delegate for when a song finishes playing. Alerts subscribers
 */
- (void)songDidFinishPlaying:(NSNotification *) notification {
    NSLog(@"Done playing");
    // Log the play before handing control off to the delegate
    if (nil != self.currentSong) {
        NSString *apiUrl = [NSString stringWithFormat:@"method=content.logContentView&id=%ld&user=%@", (long) [self.currentSong id], self.userName];
        [DXApiRequest fetchDataFromApi: apiUrl withHTTPMethod:@"HEAD"];
    }
    self.currentSong = nil;
    [self.delegate songDidFinishPlaying];
}

/**
 Notification delegate for when the audio route changes
 */
- (void)routeDidChange:(NSNotification *) notification {
    NSLog(@"Route changed: %@", notification.userInfo[AVAudioSessionRouteChangeReasonKey]);
}

/**
 Returns the percentage of playback through the current song
 */
- (double)getPlaybackPercent {
    return CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds([self.player.currentItem duration]);
}

/**
 Sets the song information for the lock screen
 */
- (void)setSongMetaInfo:(DXSong *) song {
    NSDictionary *mediaInfo = @{MPMediaItemPropertyTitle: song.title,
                                MPNowPlayingInfoPropertyPlaybackRate: @1,
                                MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithInt:song.duration]};
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
}

/**
 
 As it turns out, AVPlayer does all the network management behind the scenes super cleanly and awesomely
 But, because I'm kind of proud of the monstrousity I brewed, I'm leaving it below for posterity.
 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Allocate enough space for the MP3 data
    [self cleanUpMemory];
    self.bytesTotal = [response expectedContentLength];
    self.songBytes = [NSMutableData dataWithCapacity:self.bytesTotal];
    self.bytesLoaded = 0;
    NSLog(@"HTTP headers back, expected size: %d", self.bytesTotal);
    [self calculateLoadThreshold];
    
}

- (void)calculateLoadThreshold {
    // The threshold for playing is determined by the file size
    // 512KB or smaller must be loaded 100% before playing, anything
    // above requires less percentage of the total size with an absolute
    // minumum of 10%
    self.loadThreshold = 51200 / (double) self.bytesTotal;
    self.loadThreshold = self.loadThreshold > 1 ? 1 : self.loadThreshold;
    self.loadThreshold = self.loadThreshold < 0.1f ? 0.1f : self.loadThreshold;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.songBytes appendData:data];
    self.bytesLoaded += data.length;
    NSLog(@"Loaded: %f, Threshold: %f", [self getBufferPercent], self.loadThreshold);
    // Start playing at 10% download completion
    if ([self getBufferPercent] >= self.loadThreshold && nil == self.player) {
        NSError *err = nil;
        self.player = [[AVAudioPlayer alloc] initWithData:self.songBytes error:&err];
        self.player.delegate = self;
        if (nil == self.player) {
            NSLog(@"Player init failed: %@", err);

            // Generally this is thrown by error -39, "end of file"
            // My best guess here is that the file in question is VBR
            // encoded and the whole file must be traversed to get an accurate
            // length. That all said, set the threshold to 100% and we'll try again
            // at that point
            self.loadThreshold = 1;
        } else {
            @try {
                [self.player prepareToPlay];
                [self.player play];
            }
            @catch (NSException *e) {
                NSLog(@"Play exception: %@", e);
            }
        }
    }
    
    if (nil != self.player && [self.player isPlaying]) {
        [self.player prepareToPlay];
    }
    
    // clear the downloading flag once the download has finished
    self.downloading = self.bytesLoaded == self.bytesTotal;
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Decode error");
    [self cleanUpMemory];
    [self.delegate songDidFinishPlaying];
    
    // clean up the connection if necessary
    [self cleanupConnection];
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Song done, %d", flag);
    [self cleanUpMemory];
    [self.delegate songDidFinishPlaying];
}

- (void)cleanUpMemory {
    // Free up all our memory
    [self.player stop];
    self.player = nil;
    self.songBytes = nil;
}

- (void)cleanupConnection {
    if (nil != self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
} */

@end
