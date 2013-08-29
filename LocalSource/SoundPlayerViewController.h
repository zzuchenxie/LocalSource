//
//  SoundPlayerViewController.h
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#define ShowAudioControl 1

@interface SoundPlayerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate>


@end
