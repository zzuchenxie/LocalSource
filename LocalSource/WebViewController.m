//
//  WebViewController.m
//  LocalSource
//
//  Created by chenxie on 13-1-30.
//  Copyright (c) 2013年 chenxie. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () {

    UIWebView   *_webView;

}

-(IBAction)next:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)refresh:(id)sender;
-(IBAction)exit:(id)sender;

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

-(void)dealloc {

    [_webView release];
    [super dealloc];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSURL  *url = [[NSURL  alloc]initWithString:@"http://www.letv.com"];
    NSURLRequest *request = [[NSURLRequest  alloc]initWithURL:url];
    _webView = [[UIWebView  alloc]initWithFrame:CGRectMake(0, 0, 320, 416+(iPhone5?88:0))];
    [_webView loadRequest:request];
    _webView.scalesPageToFit = YES;
    [self.view  addSubview:_webView];
    [url release];
    [request release];
    
    
    
    UIBarButtonItem  *item1 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    UIBarButtonItem  *item2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(back:)];
    UIBarButtonItem  *item3 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(next:)];
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


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    
}



-(IBAction)next:(id)sender {
    
    [_webView  goForward];
}

-(IBAction)back:(id)sender {
    
    [_webView  goBack];
}

-(IBAction)refresh:(id)sender {
    
    [_webView  reload];
    
}

-(IBAction)exit:(id)sender {
    
    [_webView  stopLoading];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}




@end
