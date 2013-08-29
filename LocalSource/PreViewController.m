//
//  PreViewController.m
//  LocalSource
//
//  Created by chenxie on 13-2-17.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "PreViewController.h"

@interface PreViewController () {
     
    TouchImgView  *imgView;
    UIImageView  *tempImgView;
}


-(void)readImg:(NSURL *)url;

@end

@implementation PreViewController

@synthesize m_urlArr;
@synthesize imgTag;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        m_urlArr = [[NSMutableArray  alloc]initWithCapacity:0];
        imgTag = 0;
                
    }
    return self;
}

-(void)dealloc {
   
    [imgView release], imgView = nil;
    [m_urlArr release] ,m_urlArr = nil;
    [super dealloc];

}

-(void)readImg:(NSURL *)url {
       
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
    
        UIImage *image=[UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        imgView.image = image;
        
        
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:0];
          
            MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:image];
            [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
            [dict release];
        }
        
        
        /*
        MPMoviePlayerController *_player = [[MPMoviePlayerController  alloc]initWithContentURL:url];
        
        if (_player)
        {
            _player.view.frame = CGRectMake(0, 0, 20,80);
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
        
        
        
        CGFloat  height = 0.f;
        CGFloat  width = 0.f;
        
        if (image.size.width/320.f > image.size.height/460.f) {
            
            width = 320.f;
            height = 320.f*image.size.height/image.size.width;
            
        }
        else
        {
        
            height = 460.f;
            width = 460*image.size.width/image.size.height;
        
        }
              
        imgView.frame = CGRectMake(0, 0, width, height);
        imgView.center = self.view.center;
        
        NSLog(@"----->%f---->%f",width,height);
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
      

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

-(void)loadView {

    [super loadView];
    UIView  *myView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view = myView;
    [myView release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    imgView = [[TouchImgView  alloc]initWithFrame:CGRectZero];
    imgView.backgroundColor = [UIColor  lightGrayColor];
    imgView.userInteractionEnabled = YES;
    imgView.imgDelegate = self;
    //imgView.center = self.view.center;
    [self.view  addSubview:imgView];
   
             
    [self  readImg:[m_urlArr  objectAtIndex:imgTag]];
     
           
    MPVolumeView *volumeView = [ [MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(20, 400, 280, 80);
    volumeView.backgroundColor = [UIColor clearColor];
    [volumeView setShowsVolumeSlider:NO];
    [volumeView sizeToFit];
    //[volumeView  setRouteButtonImage:[UIImage  imageNamed:@"routeBtn.png"] forState:UIControlStateNormal];
    [self.view  addSubview:volumeView];
        
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}


#pragma mark - TouchImgCallBack

-(void)touchImgCallBack:(UIImageView *)imgV {
    
    [self  dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    [self  dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
