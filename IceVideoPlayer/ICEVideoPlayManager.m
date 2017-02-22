//
//  ICEVideoDataManager.m
//  IceVideoPlayer
//
//  Created by 夏欢 on 2017/2/21.
//  Copyright © 2017年 icemanXiceman. All rights reserved.
//

#import "ICEVideoPlayManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ICEVideoPlayManager()

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) NSLock *lock;

@end

static ICEVideoPlayManager* videoPlayManager = nil;

@implementation ICEVideoPlayManager

+ (ICEVideoPlayManager *)shareVideoDataManager {
    static ICEVideoPlayManager* manager = nil;
    @synchronized(self){
        if (videoPlayManager == nil) {
            videoPlayManager = [[ICEVideoPlayManager alloc] init];
            
        }
        return manager;
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
        [_player addObserver:self forKeyPath:@"statue" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_player addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:AVPlayerItemPlaybackStalledNotification object:_player];
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
    return CMTimeGetSeconds(self.player.currentTime);
}

- (void)seek:(NSTimeInterval)time
{
    [_player seekToTime:CMTimeMake(time,1)];
}


- (void)addDisplayView:(AVPlayerLayer *)layer
{
    [layer setPlayer:_player];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if(object == _player && [keyPath isEqualToString:@"statue"]){
        switch ([[change objectForKey:@"statue"] intValue] ) {
            case AVPlayerStatusUnknown:
                break;
            
            case AVPlayerStatusReadyToPlay:
                break;
                
            case AVPlayerStatusFailed:
                self.videoStatus = ICEVideoStatusError;
                break;
                
            default:
                break;
        }
    }else if(object == _player.currentItem && [keyPath isEqualToString:@"loadedTimeRanges"]){
        CMTime duration = _player.currentItem.duration;
        _availableTime = CMTimeGetSeconds(duration);?
    }
}

- (void)handleEvent:(NSNotification *)notification
{
    if(notification.object == _player){
        
        if([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]){
            self.videoStatus = ICEVideoStatusError;
        }else if ([notification.name isEqualToString:AVPlayerItemPlaybackStalledNotification]){
            self.videoStatus = ICEVideoStatusBuffering;
        }
    }
}

@end
