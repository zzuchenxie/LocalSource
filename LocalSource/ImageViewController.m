//
//  ImageViewController.m
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "ImageViewController.h"
#import "PreViewController.h"


@interface ImageViewController () {

    ALAssetsLibrary *library;
    NSMutableArray *imgUrlArray;
    UIScrollView  *_scrolView;
    NSMutableArray  *_dataArray;
    
}

@property(nonatomic,retain) NSMutableArray *_dataArray;


-(void)allPhotosCollected;
-(void)pick:(id)sender;
-(void)exit:(id)sender;

@end

@implementation ImageViewController

@synthesize _dataArray;

static int count=0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _dataArray = [[NSMutableArray  alloc]initWithCapacity:0];
        imgUrlArray=[[NSMutableArray alloc] init];
                  
    }
    return self;
}

-(void)dealloc {

    [imgUrlArray release], imgUrlArray = nil;
    [_dataArray release], _dataArray = nil;
    [_scrolView  release];
    [super  dealloc];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view  setBackgroundColor:[UIColor lightGrayColor]];
    
    [self  getImgs];
    
    
    UIBarButtonItem  *item1 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(pick:)];
    UIBarButtonItem  *item2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:NULL];
    UIBarButtonItem  *item3 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:NULL];
    UIBarButtonItem  *item4 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(exit:)];
    UIBarButtonItem  *spaceItem = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    NSArray   *array = [[NSArray alloc]initWithObjects:spaceItem,item1,spaceItem,item2,spaceItem,item3,spaceItem,item4,spaceItem,nil];
    
    UIToolbar  *toolBar = [[UIToolbar  alloc]initWithFrame:CGRectMake(0, 416+(iPhone5?88:0), 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.items = array;
    [self.view addSubview:toolBar];
    
    [array  release];
    [item1 release];
    [item2 release];
    [item3 release];
    [item4 release];
    [spaceItem release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)getImgs{
    
           
        NSMutableArray* assetURLDictionaries = [[NSMutableArray alloc] init];
        
        library = [[ALAssetsLibrary alloc] init];
    
     dispatch_async(dispatch_get_main_queue(), ^{
    
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         
        void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result != nil) {
                if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                    
                    NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                    
                    [imgUrlArray addObject:url];
                    
                    [library assetForURL:url
                             resultBlock:^(ALAsset *asset) {
                                 
                                 [_dataArray addObject:[UIImage imageWithCGImage:asset.thumbnail]];
                                 
                                 if ([_dataArray count]==count)
                                 {                                    
                                     [self allPhotosCollected];
                                 }
                             }
                            failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                    
                }
            }
        };
        
        NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
        
        void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
            if(group != nil) {
                [group enumerateAssetsUsingBlock:assetEnumerator];
                [assetGroups addObject:group];
                count=[group numberOfAssets];
            }
        };
        
        assetGroups = [[NSMutableArray alloc] init];
        
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator
                             failureBlock:^(NSError *error) {
                                 
                                 
                                 UIAlertView  *alert = [[UIAlertView  alloc]initWithTitle:@"温馨提示" message:@"访问相册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                 [alert show];
                                 [alert release];
                                 
                                 NSLog(@"There is an error");
                                 NSLog(@"相册访问失败 =%@", [error localizedDescription]);
                                 if ([error.localizedDescription rangeOfString:@"Global denied access"].location!= NSNotFound)
                                 {
                                     NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                                 }
                                 else
                                 {
                                     NSLog(@"相册访问失败.");
                                     
                                 }
                                                           
                             }];
    
         
         [pool release];
 
     });
}



-(void)allPhotosCollected
{
         
    if (!_scrolView)
    {        
        _scrolView = [[UIScrollView  alloc]initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0))];
    }

    int row = [_dataArray  count]/4;
    int colum = 4;
         
    
    int padding = 6;
    
    if ((72+padding)*(row+1) <= _scrolView.frame.size.height)
    {
        
    }
    else
    {
    
        _scrolView.contentSize = CGSizeMake(320, (72+padding)*(row+1));
        
    }
      
    
    int counter = 0;
    
    for (int m = 0; m < row+1; m++)
    {
        for (int n = 0; n < colum; n++)
        {
                   
                      
            if (counter < [_dataArray count])
            {
                            
                TouchImgView *imgView = [[TouchImgView  alloc]initWithFrame:CGRectMake(padding*(n+1)+72*n, padding*(m+1)+72*m, 72, 72)];
                imgView.userInteractionEnabled = YES;
                imgView.imgDelegate = self;
                imgView.tag = counter;
                imgView.image = [_dataArray  objectAtIndex:counter];
                [_scrolView addSubview:imgView];
                [imgView release];

            }
            else
            {
               
            }
          
            
                       counter ++;
        }
        
            
    }
    
    [self.view  addSubview:_scrolView];
    
    
}


-(void)pick:(id)sender {

    
}

-(void)exit:(id)sender {

    [self dismissViewControllerAnimated:YES completion:NULL];

}

#pragma mark - TouchImgCallBack 

-(void)touchImgCallBack:(UIImageView *)imgV {

    PreViewController *preVC = [[PreViewController alloc]init];
    preVC.m_urlArr = imgUrlArray;
    preVC.imgTag = imgV.tag;
    [self  presentViewController:preVC animated:YES completion:NULL];
    [preVC release];

}


@end
