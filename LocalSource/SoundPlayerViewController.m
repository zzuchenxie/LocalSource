//
//  SoundPlayerViewController.m
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "SoundPlayerViewController.h"
#import "PlayViewController.h"


@interface SoundPlayerViewController () {


    
    UITableView  *table;
    NSMutableArray  *sections;
    NSMutableArray  *rows;
    AVAudioPlayer  *_player;
    NSMutableArray  *m_list;
    
}


@property(nonatomic,retain) NSMutableArray  *sections;
@property(nonatomic,retain) NSMutableArray  *rows;

-(void)readItems;
-(void)playSongs:(MPMediaItem *)mediaItem;
-(void)playMusic;
-(UIImage *)readItemImg:(NSURL *)url;


@end

@implementation SoundPlayerViewController

@synthesize sections, rows;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sections = [[NSMutableArray  alloc]initWithCapacity:0];
        rows = [[NSMutableArray  alloc]initWithCapacity:0];
        m_list = [[NSMutableArray  alloc]initWithCapacity:0];
        
        
    }
    return self;
}

-(void) dealloc {
    
    
    [m_list release], m_list = nil;
    [_player release], _player = nil;
    [rows release], rows = nil;
    [sections  release], sections = nil;
    [table release], table = nil;
    [super  dealloc];
}


-(void)readItems {
    
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    
    NSArray *playlists = [myPlaylistsQuery collections];
    self.sections = [NSMutableArray  arrayWithArray:playlists];
    
    
    for (MPMediaPlaylist *playlist in playlists)
    {
        
        NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
        
        NSArray *songs = [playlist items];
        
        [rows  addObject:songs];
        
        for (MPMediaItem *song in songs)
        {
            
            [m_list  addObject:song];
            
            NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
            
            NSLog (@"\t\t%@", songTitle);
            
        }
        
    }
    
}

-(void)disMiss {

    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //添加支持后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //获取歌曲列表
    [self  readItems];
    
    table = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    [table  setDelegate:self];
    [table setDataSource:self];
    [self.view  addSubview:table];
    
    //[self  performSelector:@selector(playMusic) withObject:self afterDelay:5.f];
    
    
    UIBarButtonItem  *item1 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:NULL];
    UIBarButtonItem  *item2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:NULL];
    UIBarButtonItem  *item3 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:NULL];
    UIBarButtonItem  *item4 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(disMiss)];
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


-(void)playMusic {
    
    //设置音量
    MPMusicPlayerController *music = [MPMusicPlayerController  applicationMusicPlayer];
    music.volume = 0.5;
    
}


-(UIImage *)readItemImg:(NSURL *)url {
    
    UIImage *image = nil;
    AVURLAsset *avURLAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    for (NSString *format in [avURLAsset availableMetadataFormats])
    {
        //NSLog(@"-------format:%@",format);
        
        for (AVMetadataItem *metadataItem in [avURLAsset metadataForFormat:format])
        {
            //NSLog(@"commonKey:%@",metadataItem.commonKey);
            
            if ([metadataItem.commonKey isEqualToString:@"artwork"])
            {
                //取出封面artwork，从data转成image显示
                
                //MPMediaItemArtwork *mArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[(NSDictionary*)metadataItem.value objectForKey:@"data"]]];
                
                //[dict setObject:mArt  forKey:MPMediaItemPropertyArtwork];
                
                image = [UIImage imageWithData:[(NSDictionary*)metadataItem.value objectForKey:@"data"]];
                break;
                
            }
        }
    }
    
    
    return image;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 45.f;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    if (ShowAudioControl)
    {
        PlayViewController  *play = [[PlayViewController  alloc]init];
        play.m_item = [(MPMediaItem *)[[rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] retain];
        play.m_audioList = m_list;
        play.m_index = [indexPath row];
        [self  presentViewController:play animated:YES completion:NULL];
        [play release];
        
    }
    else
    {
        if (_player) {
            
            [_player  stop];
        }
        
        //int myswitch = rand()%2;
        int myswitch = 0;
        if (myswitch == 0)
        {
            
            MPMediaItem *song  = (MPMediaItem *)[[rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [self playSongs:song];
        }
        else
        {
            MPMediaPickerController  *mp = [[MPMediaPickerController alloc]init];
            mp.delegate = self;
            [self  presentViewController:mp animated:YES completion:NULL];
            [mp release];
            
        }
        
        
    }
    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    MPMediaPlaylist *playlist  = (MPMediaPlaylist* )[sections  objectAtIndex:section];
    
    NSLog(@"%@",[playlist valueForProperty:MPMediaPlaylistPropertyName]);
    
    return [playlist valueForProperty: MPMediaPlaylistPropertyName];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [sections count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[rows  objectAtIndex:section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString   *reuseidentify = @"cell";
    
    UITableViewCell  *cell = [tableView  dequeueReusableCellWithIdentifier:reuseidentify];
    if (cell == nil) {
        
        cell = [[[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentify]autorelease];
        
    }
    
    for (id view in [cell.contentView subviews]) {
        
        [view removeFromSuperview];
        
    }
    
    
    MPMediaItem *mediaItem  = (MPMediaItem *)[[rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSURL  *url = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
    
    cell.imageView.image = [self readItemImg:url];
    
    
    NSString *songTitle = [mediaItem valueForProperty: MPMediaItemPropertyTitle];
    cell.textLabel.text = songTitle;
    
    
    return cell;
    
}


#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    [self playSongs:[mediaItemCollection representativeItem]];
    
    
}


- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    
    if (_player)
    {
        
        [_player  stop];
    }
    
    [mediaPicker  dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)playSongs:(MPMediaItem *)mediaItem {
    
    
    NSURL  *url = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
    NSError* err;
    if (!_player)
    {
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&err ];//使用本地URL创建
        _player.delegate = self;
        _player.volume=0.8;//0.0~1.0之间
        _player.numberOfLoops = 1;//默认只播放一次
        _player.currentTime = 0.0;//可以指定从任意位置开始播放
        
        //NSUInteger channels = player.numberOfChannels;//只读属性
        //NSTimeInterval duration = player.duration;//获取采样的持续时间
        
        _player.meteringEnabled = YES;//开启仪表计数功能
        [_player updateMeters];//更新仪表读数
        
        //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
        //for(int i = 0; i<player.numberOfChannels;i++){
        //    float power = [player averagePowerForChannel:i];
        //   float peak = [player peakPowerForChannel:i];
        // }
        
        
    }
    else
    {
        [_player stop];
        [_player release], _player = nil;
        
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&err ];//使用本地URL创建
        _player.delegate = self;
        _player.volume=0.8;//0.0~1.0之间
        _player.numberOfLoops = 1;//默认只播放一次
        _player.currentTime = 0.0;//可以指定从任意位置开始播放
        
        //NSUInteger channels = player.numberOfChannels;//只读属性
        //NSTimeInterval duration = player.duration;//获取采样的持续时间
        
        _player.meteringEnabled = YES;//开启仪表计数功能
        [_player updateMeters];//更新仪表读数
        
        //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
        //for(int i = 0; i<player.numberOfChannels;i++){
        //    float power = [player averagePowerForChannel:i];
        //   float peak = [player peakPowerForChannel:i];
        //}
        
        
    }
    
    [_player prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
    [_player play];//播放
    
    
    
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag{
    //播放结束时执行的动作
    [player stop];//停止
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
    [player stop];//停止
}

- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
    [player stop];//停止
}

- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
    [player prepareToPlay];//停止
    [player play];//停止
}


@end
