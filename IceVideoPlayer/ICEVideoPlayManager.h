//
//  ICEVideoDataManager.h
//  IceVideoPlayer
//
//  Created by 夏欢 on 2017/2/21.
//  Copyright © 2017年 icemanXiceman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayerLayer;

typedef enum : NSUInteger {
    ICEVideoStatusInit = 0,
    ICEVideoStatusAlreadyPlay,
    ICEVideoStatusBuffering,
    ICEVideoStatusEnd,
    ICEVideoStatusError
} ICEVideoStatus;

@interface ICEVideoPlayManager : NSObject

@property (nonatomic ,strong) NSURL *videoURL;
@property (nonatomic ,readonly) NSTimeInterval availableTime;
@property (nonatomic ,readonly) NSTimeInterval totalTime;
@property (nonatomic ,readonly) NSTimeInterval currentTime;
@property (nonatomic ,assign) ICEVideoStatus videoStatus;


/*
 */
+ (ICEVideoPlayManager *)shareVideoDataManager;


/*
    no matter if already play,the method will refresh status and player
 */
- (void)play;

- (void)pause;

- (void)addDisplayView:(AVPlayerLayer *)layer;

- (void)seek:(NSTimeInterval)time;

@end
