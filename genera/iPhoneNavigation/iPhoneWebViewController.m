//
//  iPhoneWebViewController.m
//  genera
//
//  Created by Ranipeta, Ajay on 4/10/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "iPhoneWebViewController.h"

@interface iPhoneWebViewController ()

@end

@implementation iPhoneWebViewController

NSString *displayPage = @"Information";

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
	self.title = NSLocalizedString(displayPage,nil);

	NSLog(@"iPhoneWebViewLoad");
    
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
	NSString *infoPath = [[NSBundle mainBundle] pathForResource:[displayPage lowercaseString] ofType:@"html"];
	NSMutableString *infoHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:infoPath usedEncoding:nil error:NULL];
    [_webViewInformation loadHTMLString:infoHTMLCode	baseURL:baseURL];
    [_webViewGallery loadHTMLString:infoHTMLCode	baseURL:baseURL];
    [_webViewMaps loadHTMLString:infoHTMLCode	baseURL:baseURL];
    
    _webViewInformation.hidden = NO;
    _webViewInformation.opaque = NO;
    
    _webViewGallery.hidden = NO;
    _webViewGallery.opaque = NO;
    
    _webViewMaps.hidden = NO;
    _webViewMaps.opaque = NO;
    
    NSLog(@"Page: \n%@", infoHTMLCode);
    
	[infoHTMLCode release];
    
    
    
//	NSString *path = [[NSBundle mainBundle] bundlePath];
//	NSURL *baseURL = [NSURL fileURLWithPath:path];
//    
//	NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"information" ofType:@"html"];
//	NSMutableString *infoHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:infoPath usedEncoding:nil error:NULL];
//	[_webViewInformation loadHTMLString:infoHTMLCode	baseURL:baseURL];
//    
//	NSString *galleryPath = [[NSBundle mainBundle] pathForResource:@"gallery" ofType:@"html"];
//	NSMutableString *galleryHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:galleryPath usedEncoding:nil error:NULL];
//	[_webViewGallery loadHTMLString:galleryHTMLCode	baseURL:baseURL];
//    
//	NSString *mapsPath = [[NSBundle mainBundle] pathForResource:@"maps" ofType:@"html"];
//	NSMutableString *mapsHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:mapsPath usedEncoding:nil error:NULL];
//	[_webViewMaps loadHTMLString:mapsHTMLCode	baseURL:baseURL];
//    
//	[infoHTMLCode release];
//	[galleryHTMLCode release];
//	[mapsHTMLCode release];
}

-(void) setWebPage:(NSString *)page
{
    
	NSLog(@"Showing page: %@", [page lowercaseString]);
    displayPage = page;
    
    
    
//    if ([page isEqualToString:@"Gallery"]) {
//    } else if ([page isEqualToString:@"Gallery"]) {
//    } else {
//    }
    
    
//    
//    if ([page isEqualToString:@"Gallery"]) {
//        _webViewInformation.hidden = YES;
//        _webViewGallery.hidden = NO;
//        _webViewMaps.hidden = YES;
//    } else if ([page isEqualToString:@"Maps"]) {
//        _webViewInformation.hidden = YES;
//        _webViewGallery.hidden = YES;
//        _webViewMaps.hidden = NO;
//    } else { // just load up the information page by default
//        _webViewInformation.hidden = NO;
//        _webViewGallery.hidden = YES;
//        _webViewMaps.hidden = YES;
//    }
//    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webViewInformation release];
    [_webViewGallery release];
    [_webViewMaps release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebViewInformation:nil];
    [self setWebViewGallery:nil];
    [self setWebViewMaps:nil];
    [super viewDidUnload];
}
@end
