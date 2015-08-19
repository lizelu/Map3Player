//
//  ViewController.m
//  Mp3Player
//
//  Created by ibokan on 14-8-22.
//  Copyright (c) 2014年 Mrli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//添加背景用的ImageView
@property (strong, nonatomic) UIImageView *backView;

//播放进度条
@property (strong, nonatomic) UIProgressView *progress;

//选项卡按钮，赋值播放和暂停
@property (strong, nonatomic) UISegmentedControl * segment;

//slider，用滑动器来设置音量的大小
@property (strong, nonatomic) UISlider *slider;

//timer，来更新歌曲的当前时间
@property (strong, nonatomic) NSTimer *timer;

//显示时间的lable
@property (strong, nonatomic) UILabel *label;

//加入图片，中间的图片
@property (strong, nonatomic) UIImageView *imageView;

//声明播放器，来播放我们的音频文件
@property (strong, nonatomic) AVAudioPlayer *player;

//在暂停和播放时回调此按钮
-(void)tapSegment;

//更新歌曲时间
-(void)time;

//改变声音大小
-(void) changeVo;

@end

@implementation ViewController

//视图加载后启动该方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*添加背景图片*/
    //初始化ImageView,并设置大小
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)];
    //加载图片，我们的图片名为background
    UIImage *backImage = [UIImage imageNamed:@"background"];
    //添加背景图片到ImageView
    self.backView.image = backImage;
    //把ImageView添加到view的最底层
    [self.view insertSubview:self.backView atIndex:0];
    
    
    
    /*实例化进度条,并添加到主视图*/
    self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 60, 240, 10)];
    [self.view addSubview:self.progress];
    self.progress.progress = 0;

    
    //进度条后面的时间lable
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(275, 50, 50, 20)];
    self.label.text = @"00.00 | 00.00";
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:7];
    [self.view addSubview:self.label];
    
    //添加中间的图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 90, 160, 150)];
    UIImage *image = [UIImage imageNamed:@"image.png"];
    self.imageView.image = image;
    [self.view addSubview:self.imageView];
    
    
    //添加segmentControl
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"Play", @"Pause"]];
    self.segment.frame = CGRectMake(110, 255, 100, 40);
    self.segment.tintColor = [UIColor whiteColor];
    //注册回调方法，在segment的值改变的时候回调注册的方法
    [self.segment addTarget:self action:@selector(tapSegment) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    
    
    //配置播放器
    NSBundle *bundle = [NSBundle mainBundle];
    NSString * path = [bundle pathForResource:@"music" ofType:@"mp3"];
    NSURL *musicURL = [NSURL fileURLWithPath:path];
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
    if (self.player == nil) {
        NSLog(@"error = %@", [error localizedDescription]);
    }
    
    //设置时间，每一秒钟调用一次绑定的方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
    
    
    //添加slider
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(100,300, 120 , 50)];
    [self.slider addTarget:self action:@selector(changeVo) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.slider];
    //设置slider最小值和最大值
    self.slider.minimumValue = 1;
    self.slider.maximumValue = 10;
	
}

//改变声音
-(void)changeVo
{
    self.player.volume = self.slider.value;
}

//更新时间
-(void) time
{
    //获取音频的总时间
    NSTimeInterval totalTimer = self.player.duration;
    //获取音频的当前时间
    NSTimeInterval currentTime = self.player.currentTime;
    //根据时间比设置进度条的进度
    self.progress.progress = (currentTime/totalTimer);
    
    NSLog(@"%lf", currentTime);
    //把秒转换成分钟
    NSTimeInterval currentM = currentTime/60;
    currentTime = (int)currentTime%60;
    
    NSTimeInterval totalM = totalTimer/60;
    totalTimer = (int)totalTimer%60;
    
    //把时间显示在lable上
    NSString *timeString = [NSString stringWithFormat:@"%02.0f:%02.0f|%02.0f:%02.0f",currentM, currentTime, totalM,totalTimer];
    self.label.text = timeString;
}

//segment所回调的方法
-(void) tapSegment
{
    int isOn = self.segment.selectedSegmentIndex;
    if (isOn == 0)
    {
        [self.player play];
        
    }
    else
    {
        [self.player pause];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
