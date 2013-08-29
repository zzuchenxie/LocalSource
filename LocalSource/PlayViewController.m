//
//  PlayViewController.m
//  AudioTest
//
//  Created by chenxie on 13-2-19.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () {
    
    AVAudioPlayer* m_player;
    UIImageView  *m_imgView;
    UILabel  *m_titleLbl;

}


-(void)createControlView; //创建控制器界面
-(void)btnPressed:(UIButton *)sender;
-(void)setInfo;


@end

@implementation PlayViewController

@synthesize m_item;
@synthesize m_audioList;
@synthesize m_index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        m_audioList = [[NSMutableArray  alloc]initWithCapacity:0];
        m_index = 0;
        
    }
    return self;
}


-(void)dealloc {

    [m_imgView release], m_imgView = nil;
    [m_titleLbl release], m_titleLbl = nil;
    [m_audioList  release], m_audioList = nil;
    [m_player release], m_player = nil;
    [super  dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    [self  playSongs:m_item];
    [self  addSoundSlider];
    [self  createControlView];
    
    [self  setInfo];
}


-(void)setInfo {
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        
        NSString  *title = [m_item valueForProperty:MPMediaItemPropertyTitle];
        NSString  *artist = [m_item valueForProperty:MPMediaItemPropertyArtist];
        
        NSLog(@">>>>>>>----%@---%@",title,artist);
        
        m_titleLbl.text = [NSString  stringWithFormat:@"%@ - %@",title,artist];
        
        
        NSURL  *url = [m_item valueForProperty:MPMediaItemPropertyAssetURL];
        UIImage *img = nil;
        img = [self readItemImg:url];

        //设置的图片不能为空
        if (!img) {
            img = [UIImage  imageNamed:@"sound.png"];
        }
        
        m_imgView.image = img;
        
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dict setObject:title forKey:MPMediaItemPropertyTitle];
        [dict setObject:artist forKey:MPMediaItemPropertyArtist];
        
        MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:img];
        [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        [dict release];
    }


}

-(UIImage *)readItemImg:(NSURL *)url {
    
    
    UIImage *image = nil;
    AVURLAsset *avURLAsset = [AVURLAsset URLAssetWithURL:url
                                                 options:nil];
    for (NSString *format in [avURLAsset availableMetadataFormats]) {
        //NSLog(@"-------format:%@",format);
        for (AVMetadataItem *metadataItem in [avURLAsset metadataForFormat:format]) {
            //NSLog(@"commonKey:%@",metadataItem.commonKey);
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                //取出封面artwork，从data转成image显示
                //MPMediaItemArtwork *mArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[(NSDictionary*)metadataItem.value objectForKey:@"data"]]];
                //[dict setObject:mArt  forKey:MPMediaItemPropertyArtwork];
                
                
                image = [UIImage imageWithData:[(NSDictionary*)metadataItem.value objectForKey:@"data"]];
                break;
                
                
            }
        }
    }
    
    
    return image;
}


- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    [ [UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear:animated];
    [ [UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                //[self playPauseToggle: nil];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                //[self nextTrack: nil];
                break;
        }
    }
}


-(void)createControlView {

    
    m_titleLbl = [[UILabel  alloc]initWithFrame:CGRectMake(20, 20, 280, 20)];
    m_titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.view  addSubview:m_titleLbl];
    
    m_imgView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 50, 260, 260)];
    [self.view  addSubview:m_imgView];
    
    
    UIButton  *preBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    preBtn.tag = preAction;
    preBtn.frame = CGRectMake(20, 330, 50, 35);
    [preBtn  setTitle:@"<<" forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:preBtn];

    UIButton  *nextBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.tag = nextAction;
    nextBtn.frame = CGRectMake(80, 330, 50, 35);
    [nextBtn  setTitle:@">>" forState:UIControlStateNormal];
    [nextBtn  addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:nextBtn];
    
    UIButton  *playBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    playBtn.tag = playAction;
    playBtn.frame = CGRectMake(140, 330, 50, 35);
    [playBtn  setTitle:@"play" forState:UIControlStateNormal];
    [playBtn  addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:playBtn];

    
    UIButton  *pauseBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    pauseBtn.tag = pauseAction;
    pauseBtn.frame = CGRectMake(200, 330, 50, 35);
    [pauseBtn  setTitle:@"pause" forState:UIControlStateNormal];
    [pauseBtn  addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:pauseBtn];
    
    UIButton  *exitBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    exitBtn.tag = exitAction;
    exitBtn.frame = CGRectMake(260, 330, 50, 35);
    [exitBtn  setTitle:@"exit" forState:UIControlStateNormal];
    [exitBtn  addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:exitBtn];
     
    
}

-(void)btnPressed:(UIButton *)sender {


    switch (sender.tag) {
        case preAction: {
        
            if (m_index > 0)
            {
                m_index--;
                self.m_item = [m_audioList objectAtIndex:m_index];
                [self  setInfo];
                [self  playSongs:m_item];
                                
            }
            
        
        }
            
            break;
        case nextAction: {
            
            if (m_index < [m_audioList count]-1)
            {
                m_index++;
                self.m_item = [m_audioList objectAtIndex:m_index];
                [self  setInfo];
                [self  playSongs:m_item];
            }
            
        }
            
            break;

        case playAction: {
            
            [m_player  play];
        }
            
            break;

        case pauseAction: {
            
            [m_player pause];
            
        }
            
            break;

        case exitAction: {
            
            if (m_player) {
                
                [m_player stop];
            }
            
            [self  dismissViewControllerAnimated:YES completion:NULL];
            
        }
            
            break;

        default:
            break;
    }
    


}


-(void)addSoundSlider {

    MPVolumeView *volumeView = [ [MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(20, 400, 280, 100);
    volumeView.backgroundColor = [UIColor redColor];
    [volumeView setShowsVolumeSlider:YES];
    [volumeView sizeToFit];
    //[volumeView  setRouteButtonImage:[UIImage  imageNamed:@"routeBtn.png"] forState:UIControlStateNormal];
    [self.view  addSubview:volumeView];
  
}


-(void)playSongs:(MPMediaItem *)mediaItem {
    
    
    NSURL  *url = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
    NSError* err;
    if (!m_player)
    {
                
        m_player = [[AVAudioPlayer alloc]
                  initWithContentsOfURL:url
                  error:&err ];//使用本地URL创建
        m_player.delegate = self;
        m_player.volume=0.8;//0.0~1.0之间
        m_player.numberOfLoops = 1;//默认只播放一次
        m_player.currentTime = 0.0;//可以指定从任意位置开始播放
        
        //NSUInteger channels = player.numberOfChannels;//只读属性
        //NSTimeInterval duration = player.duration;//获取采样的持续时间
        
        m_player.meteringEnabled = YES;//开启仪表计数功能
        [m_player updateMeters];//更新仪表读数
        
        //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
        //for(int i = 0; i<player.numberOfChannels;i++){
        //    float power = [player averagePowerForChannel:i];
        //   float peak = [player peakPowerForChannel:i];
        // }
        
        
        /*
        //也可以用MPMoviePlayerController进行音频的播放
        MPMoviePlayerController  *_player = [[MPMoviePlayerController  alloc]initWithContentURL:url];
        
        if (_player)
        {
            _player.view.frame = CGRectMake(0, 0, 320,480+(iPhone5?88:0));
            _player.allowsAirPlay = YES;
            [_player setMovieSourceType:MPMovieSourceTypeFile];
            [_player view].backgroundColor = [UIColor lightGrayColor];
            [_player  setFullscreen:YES animated:YES];
            _player.controlStyle = MPMovieControlStyleFullscreen;
            _player.scalingMode = MPMovieScalingModeAspectFit;
            
        }
        
        [self.view   addSubview:_player.view];
        [_player  prepareToPlay];
        [_player play];
        */

        
    }
    else
    {
        [m_player stop];
        [m_player release], m_player = nil;
        
        m_player = [[AVAudioPlayer alloc]
                  initWithContentsOfURL:url
                  error:&err ];//使用本地URL创建
        m_player.delegate = self;
        m_player.volume=0.8;//0.0~1.0之间
        m_player.numberOfLoops = 1;//默认只播放一次
        m_player.currentTime = 0.0;//可以指定从任意位置开始播放
        
        //NSUInteger channels = player.numberOfChannels;//只读属性
        //NSTimeInterval duration = player.duration;//获取采样的持续时间
        
        m_player.meteringEnabled = YES;//开启仪表计数功能
        [m_player updateMeters];//更新仪表读数
        
        //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
        //for(int i = 0; i<player.numberOfChannels;i++){
        //    float power = [player averagePowerForChannel:i];
        //   float peak = [player peakPowerForChannel:i];
        //}
        
        
    }
    
    [m_player prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
    [m_player play];//播放
    
    
    
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束时执行的动作
    [m_player stop];//停止
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
    [m_player stop];//停止
}

- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
    [m_player stop];//停止
}

- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
    [m_player prepareToPlay];//停止
    [m_player play];//停止
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"action sheet");

}



@end
