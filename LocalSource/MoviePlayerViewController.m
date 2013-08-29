
//
//  MoviePlayerViewController.m
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import "AppDelegate.h"
#import "AppDelegate.h"

@interface MoviePlayerViewController () {

    MPMoviePlayerController *_player;
    
}

-(void)playFinished:(NSNotification *)noti;
-(void)orientationChange;
-(void)airPlayStatChanged;

@end

@implementation MoviePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
        
    }
    return self;
}

-(void)dealloc {
    
    [_player release] ,_player = nil;
    [super  dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(playFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(orientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(airPlayStatChanged) name:MPMoviePlayerIsAirPlayVideoActiveDidChangeNotification object:nil];
    
    
    NSString  *path = [[NSBundle  mainBundle]pathForResource:@"Movie" ofType:@"m4v"];
    NSURL  *url = [[NSURL  alloc]initFileURLWithPath:path];
    _player = [[MPMoviePlayerController  alloc]initWithContentURL:url];
    
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
    
    [url  release];

    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {

//    AppDelegate *app = [[UIApplication sharedApplication] delegate];
//    app.window.rootViewController = self;
    
    [[UIApplication  sharedApplication] setStatusBarHidden:YES];
    
    
    [ [UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated {

    [[UIApplication  sharedApplication] setStatusBarHidden:NO];
    [[UIApplication  sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
   
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
}


- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                
                break;
            case UIEventSubtypeRemoteControlNextTrack:
               
                
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidUnload {

    [super viewDidUnload];
    [[NSNotificationCenter  defaultCenter] removeObserver:self];

}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
}

-(BOOL)shouldAutorotate {

    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
        
    return  (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
    
}


#else

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation  {
    
    return  (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
}

#endif



//视图旋转之前自动调用
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"视图旋转之前自动调用");
    
    [[UIApplication  sharedApplication] setStatusBarOrientation:toInterfaceOrientation];
    [[UIApplication  sharedApplication] setStatusBarHidden:YES];
   
       
}

//视图旋转方向发生改变时会自动调用
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"视图旋转方向发生改变时会自动调用");
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        _player.view.frame = CGRectMake(0, 0, 480+(iPhone5?88:0), 320);

    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        _player.view.frame = CGRectMake(0, 0, 480+(iPhone5?88:0), 320);

    }

}

//视图旋转完成之后会自动调用
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"视图旋转完成之后自动调用");
}


-(void)playFinished:(NSNotification *)noti {
    
    [self  dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)orientationChange {

    NSLog(@"设备方向发生了变化");

}

-(void)airPlayStatChanged {

    UIAlertView  *alert = [[UIAlertView  alloc]initWithTitle:nil message:@"State Changed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];

}

@end
