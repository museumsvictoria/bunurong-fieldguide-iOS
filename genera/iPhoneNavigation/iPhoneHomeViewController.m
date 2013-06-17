//
//  iPhoneHomeViewController.m
//  genera
//
//  Created by Ranipeta, Ajay on 4/10/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "iPhoneHomeViewController.h"
#import "iPhoneWebViewController.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

@interface iPhoneHomeViewController ()

@end

@implementation iPhoneHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Bunurong",nil);
    
    if( IS_IPHONE_5 ) {
        _backgroundImage.image = [UIImage imageNamed:@"Home-Portrait-568h"];
        
        CGRect buttonsContainerFrame = _buttonsContainer.frame;
        buttonsContainerFrame.origin.y = buttonsContainerFrame.origin.x + 75;
        _buttonsContainer.frame = buttonsContainerFrame;
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         _buttonsContainer.alpha = 1.0;
                     }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_homeView release];
    [_webViewInformation release];
    [_btnInformation release];
    [_webViewGallery release];
    [_webViewMaps release];
    [_webViews release];
    [_backgroundImage release];
    [_buttonsContainer release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHomeView:nil];
    [self setWebViewInformation:nil];
    [self setBtnInformation:nil];
    [self setWebViewGallery:nil];
    [self setWebViewMaps:nil];
    [self setWebViews:nil];
    [self setBackgroundImage:nil];
    [self setButtonsContainer:nil];
    [super viewDidUnload];
}
- (IBAction)showWebView:(UIButton *)sender {
    NSLog(@"Showing %@ page", sender.currentTitle);
    
    
//    if ([sender.currentTitle isEqualToString:@"Gallery"]) {
//        _webViewInformation.hidden = YES;
//        _webViewGallery.hidden = NO;
//        _webViewMaps.hidden = YES;
//    } else if ([sender.currentTitle isEqualToString:@"Maps"]) {
//        _webViewInformation.hidden = YES;
//        _webViewGallery.hidden = YES;
//        _webViewMaps.hidden = NO;
//    } else { // just load up the information page by default
//        _webViewInformation.hidden = NO;
//        _webViewGallery.hidden = YES;
//        _webViewMaps.hidden = YES;
//    }
//
//    UIViewController *webViewController = [[[UIViewController alloc] initWithNibName:@"iphoneAboutViewController" bundle:nil] autorelease];
//    [webViewController.view addSubview:_webViews];
//    [self.navigationController pushViewController:webViewController animated:YES];

    iPhoneWebViewController *webViewController = [[iPhoneWebViewController alloc] initWithNibName:@"iPhoneWebViewController" bundle:nil];
    webViewController.title = sender.currentTitle;
    [webViewController setWebPage:sender.currentTitle]; 
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
    
}
@end
