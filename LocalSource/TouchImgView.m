//
//  TouchImgView.m
//  LocalSource
//
//  Created by chenxie on 13-2-17.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "TouchImgView.h"

@implementation TouchImgView

@synthesize imgDelegate;

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (imgDelegate && [imgDelegate  respondsToSelector:@selector(touchImgCallBack:)])
    {
        
        [imgDelegate  touchImgCallBack:self];
    }
    

}

@end
