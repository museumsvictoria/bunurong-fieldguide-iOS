//
//  iPhoneHomeViewController.h
//  genera
//
//  Created by Ranipeta, Ajay on 4/10/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneHomeViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIView *webViews;
@property (retain, nonatomic) IBOutlet UIView *homeView;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (retain, nonatomic) IBOutlet UIView *buttonsContainer;

@property (retain, nonatomic) IBOutlet UIWebView *webViewInformation;
@property (retain, nonatomic) IBOutlet UIWebView *webViewGallery;
@property (retain, nonatomic) IBOutlet UIWebView *webViewMaps;

@property (retain, nonatomic) IBOutlet UIButton *btnInformation;

- (IBAction)showWebView:(UIButton *)sender;
@end
