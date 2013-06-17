//
//  iPhoneDetailViewController.m
//  genera
//
//  Created by Simon Sherrin on 16/01/12.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//


#import "iPhoneDetailViewController.h"
#import "AudioListViewController.h"
#import "MVPagingScollView.h"
#import "Speci.h"
#import "UserPreferences.h"

@implementation iPhoneDetailViewController

@synthesize detailSpeci = _detailSpeci;
@synthesize detailTab1 = _detailTab1;
@synthesize detailTab2 = _detailTab2;
@synthesize detailTab3 = _detailTab3;
@synthesize detailWebView1 = _detailWebView1;
@synthesize detailWebView2 = _detailWebView2;
@synthesize detailWebView3 = _detailWebView3;
@synthesize audioTab = _audioTab;
@synthesize imageTab = _imageTab;
@synthesize tabBar = _tabBar;
@synthesize imageView = _imageView;
@synthesize infoView = _infoView;
@synthesize audioView = _audioView;


- (BOOL)hidesBottomBarWhenPushed{
	return TRUE;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.hidesBottomBarWhenPushed = YES;
	self.navigationController.navigationBar.translucent = NO;
	//Setup ImageView
    
	pagingScrollView = [[MVPagingScollView alloc] initWithNibName:@"MVPagingScollView" bundle:nil];
	CGRect imageViewFrame = _imageView.frame;
    
    
    
	[_imageView insertSubview:pagingScrollView.view atIndex:0]; 
    
	pagingScrollView.view.frame = imageViewFrame;
	pagingScrollView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;	
    NSLog(@"about to set images");
   // NSSortDescriptor *imageOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
   // NSArray *sortedImages = [_detailSpeci.images sortedArrayUsingDescriptors:[NSArray arrayWithObjects:imageOrder, nil]];
   //  NSLog(@"Image Arrayt Count:%d", [sortedImages count]);
//	[pagingScrollView newImageSet:[_detailSpeci.images sortedArrayUsingDescriptors:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
     
    [pagingScrollView newImageSet:[_detailSpeci orderedImages]];
                             
    
    NSLog(@"Image Set Count:%d", [pagingScrollView.images count]);
	pagingScrollView.delegate = self;
	
	
	//Display Web Content
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	//	NSLog([self constructHTML]);
    
	_detailWebView1.opaque = NO;
	_detailWebView1.backgroundColor = [UIColor clearColor];
	_detailWebView2.opaque = NO;
	_detailWebView2.backgroundColor = [UIColor clearColor];
	_detailWebView3.opaque = NO;
	_detailWebView3.backgroundColor = [UIColor clearColor];
	NSString *htmlPath1;
	NSString *htmlPath2;
	NSString *htmlPath3;
	htmlPath1 = [[NSBundle mainBundle] pathForResource:@"template-iphone-details" ofType:@"html"];
	htmlPath2 = [[NSBundle mainBundle] pathForResource:@"template-iphone-distribution" ofType:@"html"];
	htmlPath3 =[[NSBundle mainBundle] pathForResource:@"template-iphone-scarcity" ofType:@"html"];
    
	//NSStringEncoding *placeHolder;
	details1HTMLCode= [[NSMutableString alloc] initWithContentsOfFile:htmlPath1 usedEncoding:nil error:NULL];
	details2HTMLCode = [[NSMutableString alloc] initWithContentsOfFile:htmlPath2 usedEncoding:nil error:NULL];
	details3HTMLCode = [[NSMutableString alloc] initWithContentsOfFile:htmlPath3 usedEncoding:nil error:NULL];
   
    /*
    details1HTMLCode= [[NSMutableString alloc] initWithContentsOfFile:htmlPath1];
	details2HTMLCode = [[NSMutableString alloc] initWithContentsOfFile:htmlPath2];
	details3HTMLCode = [[NSMutableString alloc] initWithContentsOfFile:htmlPath3]; */
    
    [self htmlTemplate:details1HTMLCode keyString:@"label" replaceWith:_detailSpeci.label];
    [self htmlTemplate:details2HTMLCode keyString:@"label" replaceWith:_detailSpeci.label];
    [self htmlTemplate:details3HTMLCode keyString:@"label" replaceWith:_detailSpeci.label];
	[self htmlTemplate:details1HTMLCode keyString:@"sublabel" replaceWith:_detailSpeci.sublabel];
 	[self htmlTemplate:details2HTMLCode keyString:@"sublabel" replaceWith:_detailSpeci.sublabel];
    [self htmlTemplate:details3HTMLCode keyString:@"sublabel" replaceWith:_detailSpeci.sublabel];
    
    for (NSString *tmpKey in (NSDictionary *) _detailSpeci.details) {
        [self htmlTemplate:details1HTMLCode keyString:tmpKey replaceWith:[(NSDictionary*)_detailSpeci.details objectForKey:tmpKey]];
        [self htmlTemplate:details2HTMLCode keyString:tmpKey replaceWith:[(NSDictionary*)_detailSpeci.details objectForKey:tmpKey]];
        [self htmlTemplate:details3HTMLCode keyString:tmpKey replaceWith:[(NSDictionary*)_detailSpeci.details objectForKey:tmpKey]];
    }
	
	
	//NSString *baseHTMLCode = [[NSString alloc] initWithString:[self constructHTML]];
    
	[_detailWebView1 loadHTMLString:details1HTMLCode  baseURL:baseURL];
	[_detailWebView2  loadHTMLString:details2HTMLCode baseURL:baseURL];
	[_detailWebView3  loadHTMLString:details3HTMLCode baseURL:baseURL];
    
    NSLog(@"details3HTMLCode: \n%@", details3HTMLCode); 
    
	
    //Hide audio Button if no audio
	if ([_detailSpeci.audios count] > 0) {
		//audioView.enabled = YES;
		_audioTab.enabled = YES;
		audioList = [[AudioListViewController alloc] initWithNibName:@"AudioListViewController" bundle:nil];
		audioList.audioFilesArray = [_detailSpeci orderedAudios];
	}else {
		//audioView.enabled = NO;
		_audioTab.enabled = NO;
	}

	//Set up initial state.
    _detailWebView1.hidden = YES;
	_detailWebView2.hidden = YES;
	_detailWebView3.hidden = YES;
	_tabBar.selectedItem = _imageTab;
    [details1HTMLCode release];
    [details2HTMLCode release];
    [details3HTMLCode release];
    
    
    
    // remove the audio button for Bunurong
    NSMutableArray *items = [[_tabBar.items mutableCopy] autorelease];
    [items removeObject: _audioTab];
    _tabBar.items = items;
    
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"iPhone detail: viewDidUnload");
    pagingScrollView.delegate = nil;
    
    self.detailSpeci = nil;
    self.detailTab1 = nil;
    self.detailTab2 = nil;
    self.detailTab3 = nil;
    self.detailWebView1 = nil;
    self.detailWebView2 = nil;
    self.detailWebView3 = nil;
    self.audioTab = nil;
    self.imageTab = nil;
    self.tabBar = nil;
    self.imageView = nil;
    self.infoView = nil;
    self.audioView = nil;


    
}


- (void)dealloc {
    
    NSLog(@"Detail View Dealloc");
    
    [pagingScrollView release];
  
    
    [audioList release]; 
    
    [ _detailTab1 release];
    [_detailTab2 release];
    [_detailTab3 release];
    [ _detailWebView1 release];
    [_detailWebView2 release];
    [_detailWebView3 release];
    [_audioTab release];
    [_imageTab release];
    
    [_imageView release];
    [_infoView release];
    [ _audioView release];
    
    [_tabBar release];
    
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
 //   return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
	[pagingScrollView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration  {
    
	[pagingScrollView willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    
}

-(void) handleSingleTap:(UIGestureRecognizer *)sender{
	//if hidden, show,
    
	if (self.navigationController.navigationBarHidden == YES) {
		[self.navigationController setNavigationBarHidden:NO animated:NO];
		_tabBar.hidden = NO;
		CGRect imageViewFrame = pagingScrollView.view.frame;
		imageViewFrame.origin.x = 0;
		imageViewFrame.origin.y = 0;
		imageViewFrame.size.height = imageViewFrame.size.height - 49;
		pagingScrollView.view.frame = imageViewFrame;
        //	NSLog(@"Navigation Bar Section");
	}else {
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		_tabBar.hidden = YES;
		CGRect imageViewFrame = pagingScrollView.view.frame;
		imageViewFrame.origin.x = 0;
		imageViewFrame.origin.y = 0;
		imageViewFrame.size.height = imageViewFrame.size.height + 49;
		pagingScrollView.view.frame = imageViewFrame;	
	}
	
	
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request mainDocumentURL]];
		return NO;
	}
	
	return YES;
}
-(IBAction)toggleInfo:(id)sender{}
-(void) htmlTemplate:(NSMutableString *)templateString keyString:(NSString *)stringToReplace replaceWith:(NSString *)replacementString{
    
    if (replacementString != nil && [replacementString length] > 0) {
		[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@%%>",stringToReplace] withString:replacementString options:0 range:NSMakeRange(0, [templateString length])];
		[templateString	replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@Class%%>",stringToReplace] withString:@" " options:0 range:NSMakeRange(0, [templateString length])];
	}else {
		NSLog(@"keystring %@ is nil", stringToReplace);
		[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@%%>",stringToReplace] withString:@"" options:0 range:NSMakeRange(0, [templateString length])];
		[templateString	replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@Class%%>",stringToReplace] withString:@"invisible" options:0 range:NSMakeRange(0, [templateString length])];
		
	}
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
	//NSString *path = [[NSBundle mainBundle] bundlePath];
	//NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	if (item == _detailTab1) {
        self.navigationController.navigationBar.translucent = NO;
		//27/02 commented out remove from superview
		//	if (pagingScrollView.view.superview ==self.view ) {
        //		[pagingScrollView.view removeFromSuperview];
        //	}
		if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}
		pagingScrollView.view.hidden = YES;
		_detailWebView2.hidden = YES;
		_detailWebView3.hidden = YES;
		_detailWebView1.hidden = NO;
		
	}else if (item == _imageTab) {
        if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}
		self.navigationController.navigationBar.translucent = NO;
        
		pagingScrollView.view.hidden = NO;
		_detailWebView2.hidden = YES;
		_detailWebView3.hidden = YES;
		_detailWebView1.hidden = YES;
		
	} else if (item == _audioTab) {
        //	if (pagingScrollView.view.superview ==self.view ) {
        //		[pagingScrollView.view removeFromSuperview];
        //	}
		self.navigationController.navigationBar.translucent = NO;		 
        
		[self.view insertSubview:audioList.view atIndex:1];
		pagingScrollView.view.hidden = YES;
		_detailWebView2.hidden = YES;
		_detailWebView3.hidden = YES;
		_detailWebView1.hidden = YES;
		
	} else if (item == _detailTab2){
        self.navigationController.navigationBar.translucent = NO;
        
		if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}
        
		pagingScrollView.view.hidden = YES;
		_detailWebView2.hidden = NO;
		_detailWebView3.hidden = YES;
		_detailWebView1.hidden = YES;
		
	}else if (item == _detailTab3){
        self.navigationController.navigationBar.translucent = NO;
        
		if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}
        
		pagingScrollView.view.hidden = YES;
		_detailWebView2.hidden = YES;
		_detailWebView3.hidden = NO;
		_detailWebView1.hidden = YES;
		
	}
    
	
}

@end
