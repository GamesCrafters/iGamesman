//
//  GCAboutGamesCraftersViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/4/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCAboutGamesCraftersViewController.h"


@implementation GCAboutGamesCraftersViewController

- (void) done
{
    [self dismissModalViewControllerAnimated: YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle: @"About GamesCrafters"];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
    [[self navigationItem] setLeftBarButtonItem: doneButton];
    [doneButton release];
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
