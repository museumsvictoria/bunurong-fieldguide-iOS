//
//  iPadInitialLoadViewController.m
//  genera
//
//  Created by Ranipeta, Ajay on 27/09/12.
//  Copyright (c) 2012 Museum Victoria. All rights reserved.
//

#import "iPadInitialLoadViewController.h"

@interface iPadInitialLoadViewController ()

@end

@implementation iPadInitialLoadViewController

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
    // Do any additional setup after loading the view from its nib.
}

-(void) updateProgressBar:(float)loadprogress{
	_progressView.progress = loadprogress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_progressView release];
    [_activityIndicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProgressView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
