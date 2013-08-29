//
//  BaseViewController.m
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
            
}

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    
    return  UIInterfaceOrientationMaskPortrait;
    
}


#else

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation  {
    
    return  (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

#endif


@end
