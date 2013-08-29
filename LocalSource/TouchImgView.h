//
//  TouchImgView.h
//  LocalSource
//
//  Created by chenxie on 13-2-17.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchImgViewDelegate <NSObject>

@optional
-(void)touchImgCallBack:(UIImageView *)imgV;

@end


@interface TouchImgView : UIImageView {


}

@property (nonatomic, assign) id<TouchImgViewDelegate> imgDelegate;

@end
