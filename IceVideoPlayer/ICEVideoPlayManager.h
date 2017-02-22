//
//  ICEVideoDataManager.h
//  IceVideoPlayer
//
//  Created by 夏欢 on 2017/2/21.
//  Copyright © 2017年 icemanXiceman. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

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
@property (nonatomic ,readonly) ICEVideoStatus videoStatus;


/*
 */
+ (ICEVideoPlayManager *)shareVideoDataManager;


/*
 */
- (void)play;

/*
 */
- (void)pause;

/*
 */
- (void)addVideoViewTo:(AVPlayerLayer *)layer;

/*
 */
- (void)seek:(NSTimeInterval)time;

@end
