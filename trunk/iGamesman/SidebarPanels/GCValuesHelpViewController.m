//
//  GCValuesHelpViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/14/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCValuesHelpViewController.h"

@implementation GCValuesHelpViewController

#pragma mark -

- (void) done
{
    [self dismissModalViewControllerAnimated: YES];
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
    [[self navigationItem] setRightBarButtonItem: doneButton];
    [doneButton release];
    
    [[self navigationItem] setTitle: @"About Predictions & Move Values"];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
