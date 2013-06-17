//
//  iPadInitialLoadViewController.h
//  genera
//
//  Created by Ranipeta, Ajay on 27/09/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadInitialLoadViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) updateProgressBar:(float)loadprogress;

@end
