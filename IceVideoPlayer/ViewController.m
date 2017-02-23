//
//  ViewController.m
//  IceVideoPlayer
//
//  Created by 夏欢 on 2017/2/7.
//  Copyright © 2017年 icemanXiceman. All rights reserved.
//

#import "ViewController.h"
#import "ICEVideoPlayManager.h"

@interface ViewController ()

@property (nonatomic ,strong) ICEVideoPlayManager *videoManager;
@property (nonatomic ,strong) AVPlayerLayer *playerLayer;

@property (nonatomic ,strong) UILabel *totalLabel;
@property (nonatomic ,strong) UILabel *currentLabel;
@property (nonatomic ,strong) UILabel *aviLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://103.7.28.28/video.music.joox.com/1035_24586c30f42d11e6bcc2d4ae5278cc05.f0.mp4?vkey=136FF1E8070BAAB3236F933AAEA8E118A168015E3E9EBBF6B1E7B6DC22235CD287A76D601E2560C749CD4F23811B78F69F57218B493775C9A6871B176ACEDEA076AEBCB593461E5E46CDE677F3928EF0DF4EF804EB522AB0"];
    
    _videoManager = [ICEVideoPlayManager shareVideoDataManager];
    _videoManager.videoURL = url;
    
    _playerLayer = [AVPlayerLayer layer];
    _playerLayer.frame = CGRectMake(0, 0, 320, 568);
    [self.view.layer addSublayer:_playerLayer];
    [_videoManager addVideoViewTo:self.playerLayer];
    [_videoManager play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willToBackGround:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willToActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 100, 100)];
    [self.view addSubview:_totalLabel];
    
    _currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 400, 100, 100)];
    [self.view addSubview:_currentLabel];
    
    _aviLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 100, 100)];
    [self.view addSubview:_aviLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
}

- (void)willToBackGround:(NSNotification *)notification
{
    [_videoManager pause];
}

- (void)willToActive:(NSNotification *)notification
{
    [_videoManager play];
}

- (void)refresh
{
    self.totalLabel.text = [NSString stringWithFormat:@"总时间%.0f",_videoManager.totalTime];
    self.currentLabel.text = [NSString stringWithFormat:@"当前时间%.0f",_videoManager.currentTime];
    NSLog(@"%@",self.currentLabel.text);
    self.aviLabel.text = [NSString stringWithFormat:@"缓冲时间%.0f",_videoManager.availableTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
