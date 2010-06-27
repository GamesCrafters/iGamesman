    //
//  GCVVHViewController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 6/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCVVHViewController.h"
#import "GCVVHView.h"


@implementation GCVVHViewController


- (id) initWithVVHData: (NSArray *) _data andOrientation: (UIInterfaceOrientation) orient {
	if (self = [super init]) {
		orientation = orient;
		data = _data;
	}
	return self;
}

/*
- (void)loadView {
	
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Visual Value History";
	
	CGRect rect;
	if (orientation == UIInterfaceOrientationPortrait) {
		rect = CGRectMake(0, 0, 320, 416);
	} else {
		rect = CGRectMake(0, 0, 480, 268);
	}
	GCVVHView *vvhView = [[GCVVHView alloc] initWithFrame: rect];
	vvhView.data = data;
	[self.view addSubview: vvhView];
	[vvhView release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
	return orientation == interfaceOrientation;
}


- (void)dealloc {
    [super dealloc];
}


@end
