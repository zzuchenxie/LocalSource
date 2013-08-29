//
//  PreViewController.h
//  LocalSource
//
//  Created by chenxie on 13-2-17.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "BaseViewController.h"
#import "TouchImgView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define TEST 0


@interface PreViewController : BaseViewController <TouchImgViewDelegate> {

    NSMutableArray  *m_urlArr;
       
}

@property (nonatomic,retain) NSMutableArray *m_urlArr;
@property (nonatomic,assign) int  imgTag;

@end
