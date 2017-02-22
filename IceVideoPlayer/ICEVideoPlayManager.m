    //
//  ICEVideoDataManager.m
//  IceVideoPlayer
//
//  Created by 夏欢 on 2017/2/21.
//  Copyright © 2017年 icemanXiceman. All rights reserved.
//

#import "ICEVideoPlayManager.h"


@interface ICEVideoPlayManager()

@property (nonatomic ,strong) AVPlayerLayer *playerLayer;
@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) NSLock *lock;

@property (nonatomic ,assign) NSTimeInterval availableTime;
@property (nonatomic ,assign) ICEVideoStatus videoStatus;


@end

static ICEVideoPlayManager* videoPlayManager = nil;

@implementation ICEVideoPlayManager

+ (ICEVideoPlayManager *)shareVideoDataManager {
    @synchronized(self){
        if (videoPlayManager == nil) {
            videoPlayManager = [[ICEVideoPlayManager alloc] init];
            
        }
        return videoPlayManager;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_videoURL && _player) {
        [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_player removeObserver:self forKeyPath:@"status"];
    }
}

- (void)setVideoURL:(NSURL *)videoURL
{
    [_lock lock];
    if (_videoURL && _player) {
        [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_player removeObserver:self forKeyPath:@"status"];
    }
    
    if (videoURL == nil) {
        _videoURL = nil;
        _player = nil;
    }else{
        _videoURL = videoURL;
        _player = [AVPlayer playerWithURL:_videoURL];
        _playerLayer.player = _player;
        [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:AVPlayerItemPlaybackStalledNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
        
    }
    [_lock unlock];
}

- (void)play
{
    [_player play];
}

- (void)pause
{
    [_player pause];
}

- (NSTimeInterval)totalTime
{
    return CMTimeGetSeconds(self.player.currentItem.duration);
}

- (NSTimeInterval)currentTime
{
    return CMTimeGetSeconds(self.player.currentItem.currentTime);
}

- (void)seek:(NSTimeInterval)time
{
    [_player seekToTime:CMTimeMake(time,1)];
}


- (void)addVideoViewTo:(AVPlayerLayer *)layer
{
    _playerLayer = layer;
    if (_videoURL!=nil) {
        _playerLayer.player = _player;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == _player.currentItem) {
        if([keyPath isEqualToString:@"status"]){
            switch ([[change objectForKey:@"status"] intValue] ) {
                case AVPlayerStatusUnknown:
                    NSLog(@"AVPlayerStatusUnknown");
                    break;
                    
                case AVPlayerStatusReadyToPlay:
                    NSLog(@"AVPlayerStatusReadyToPlay");
                    break;
                    
                case AVPlayerStatusFailed:
                    NSLog(@"AVPlayerStatusFailed");
                    self.videoStatus = ICEVideoStatusError;
                    break;
                    
                default:
                    break;
            }
        }else if( [keyPath isEqualToString:@"loadedTimeRanges"]){
            
            
            if (self.player.currentItem.loadedTimeRanges.count > 0) {
                CMTimeRange timeRange = [self.player.currentItem.loadedTimeRanges.firstObject CMTimeRangeValue];
                float startSeconds = CMTimeGetSeconds(timeRange.start);
                float durationSeconds = CMTimeGetSeconds(timeRange.duration);
                _availableTime = startSeconds + durationSeconds;
            }
        }
    }
}

- (void)handleEvent:(NSNotification *)notification
{
    if(notification.object == _player.currentItem){
        
        if([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]){
            self.videoStatus = ICEVideoStatusEnd;
            NSLog(@"ICEVideoStatusEnd");
        }else if ([notification.name isEqualToString:AVPlayerItemPlaybackStalledNotification]){
            self.videoStatus = ICEVideoStatusBuffering;
            NSLog(@"ICEVideoStatusBuffering");
        }else if ([notification.name isEqualToString:AVPlayerItemFailedToPlayToEndTimeNotification]){
            self.videoStatus = ICEVideoStatusError;
            NSLog(@"ICEVideoStatusError");
        }
    }
}

@end
