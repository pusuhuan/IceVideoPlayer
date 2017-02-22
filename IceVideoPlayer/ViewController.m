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
    NSURL *url = [NSURL URLWithString:@"http://vid.music.joox.com/video.music.joox.com/1035_4baf5abe560e11e581e6d4ae5278cc05.f10.mp4?vkey=8CE1201BC339BC2D275B691B7A233BB1259A483AFF912B52E156088C93E8E5CC11F16D1C68A59096CA59F7F6742F18B221BEA8441596FEAF1629879AF7A3D7AB9A2533F33870DA541C69205B35C85"];
    
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
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
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
    self.aviLabel.text = [NSString stringWithFormat:@"缓冲时间%.0f",_videoManager.availableTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
