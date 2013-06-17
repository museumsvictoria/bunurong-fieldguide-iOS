//
//  iPhoneWebViewController.h
//  genera
//
//  Created by Ranipeta, Ajay on 4/10/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneWebViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *webViewInformation;
@property (retain, nonatomic) IBOutlet UIWebView *webViewGallery;
@property (retain, nonatomic) IBOutlet UIWebView *webViewMaps;

-(void) setWebPage:(NSString *)page;

@end
