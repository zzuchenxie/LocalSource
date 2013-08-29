//
//  PlayViewController.h
//  AudioTest
//
//  Created by chenxie on 13-2-19.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

enum btnTag {
    preAction = 1001,
    nextAction,
    playAction,
    pauseAction,
    exitAction,
};

@interface PlayViewController : BaseViewController < AVAudioPlayerDelegate , UIActionSheetDelegate> {


}

@property(nonatomic,retain) MPMediaItem *m_item;
@property(nonatomic,retain) NSMutableArray  *m_audioList;
@property(nonatomic,assign) int  m_index;


@end
