//
//  RootViewController.m
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "RootViewController.h"
#import "MoviePlayerViewController.h"
#import "WebViewController.h"
#import "ImageViewController.h"
#import "SoundPlayerViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()


-(IBAction)buttonPressed:(UIButton *)sender;


@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {

    [[UIApplication  sharedApplication]  setStatusBarHidden:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor  yellowColor];
    
    UIButton  *imgPickBtn = [UIButton   buttonWithType:UIButtonTypeRoundedRect];
    imgPickBtn.tag = 1001;
    imgPickBtn.frame = CGRectMake(40, 40, 240, 60);
    [imgPickBtn  setTitle:@"选取图片" forState:UIControlStateNormal];
    [imgPickBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [imgPickBtn setTitleColor:[UIColor  blueColor ] forState:UIControlStateHighlighted];
    [imgPickBtn  addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:imgPickBtn];
    
    
    UIButton  *videoPickBtn = [UIButton   buttonWithType:UIButtonTypeRoundedRect];
    videoPickBtn.tag = 1002;
    videoPickBtn.frame = CGRectMake(40, 115, 240, 60);
    [videoPickBtn  setTitle:@"选取视频" forState:UIControlStateNormal];
    [videoPickBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [videoPickBtn setTitleColor:[UIColor  blueColor ] forState:UIControlStateHighlighted];
    [videoPickBtn  addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:videoPickBtn];
    
    
    UIButton  *soundPickBtn = [UIButton   buttonWithType:UIButtonTypeRoundedRect];
    soundPickBtn.tag = 1003;
    soundPickBtn.frame = CGRectMake(40, 190, 240, 60);
    [soundPickBtn  setTitle:@"选取音频" forState:UIControlStateNormal];
    [soundPickBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [soundPickBtn setTitleColor:[UIColor  blueColor ] forState:UIControlStateHighlighted];
    [soundPickBtn  addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:soundPickBtn];
    
    UIButton  *webPickBtn = [UIButton   buttonWithType:UIButtonTypeRoundedRect];
    webPickBtn.tag = 1004;
    webPickBtn.frame = CGRectMake(40, 265, 240, 60);
    [webPickBtn  setTitle:@"打开网页" forState:UIControlStateNormal];
    [webPickBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [webPickBtn setTitleColor:[UIColor  blueColor ] forState:UIControlStateHighlighted];
    [webPickBtn  addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:webPickBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)buttonPressed:(UIButton *)sender {

    switch (sender.tag) {
        case 1001:
        {
             
            ImageViewController  *imgPickVC1 = [[ImageViewController  alloc]init];
            [self  presentViewController:imgPickVC1 animated:YES completion:NULL];
            [imgPickVC1 release];
        
        }
            
            break;
        case 1002:
        {
            
            
            
            MoviePlayerViewController  *videoVC = [[MoviePlayerViewController  alloc]init];
            [self  presentViewController:videoVC animated:YES completion:NULL];
            [videoVC release];

            
        }
            
            break;
        case 1003:
        {
           
            SoundPlayerViewController  *soundVC = [[SoundPlayerViewController  alloc]init];
            [self  presentViewController:soundVC animated:YES completion:NULL];
            [soundVC release];
            
                       
        }
            
            break;
        case 1004:
        {
            
            WebViewController  *webVC = [[WebViewController  alloc]init];
            [self  presentViewController:webVC animated:YES completion:NULL];
            [webVC release];
                        
        }
            
            break;
        default:
            break;
    }
    



}




@end
