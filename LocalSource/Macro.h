//
//  Macro.h
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#ifndef LocalSource_Macro_h
#define LocalSource_Macro_h



#endif


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define myApp  (AppDelegate *)[[UIApplication  sharedApplication]delegate]