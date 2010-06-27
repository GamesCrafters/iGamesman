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

@synthesize game;


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
	
	CGRect rect, vvhRect;
	if (orientation == UIInterfaceOrientationPortrait) {
		rect = CGRectMake(0, 0, 320, 416);
		vvhRect = CGRectMake(0, 0, 320, MAX(416, 25 * [data count]));
	} else {
		rect = CGRectMake(0, 0, 480, 268);
		vvhRect = CGRectMake(0, 0, 480, MAX(268, 25 * [data count]));
	}
	
	UIScrollView *scroll = [[UIScrollView alloc] initWithFrame: rect];
	
	GCVVHView *vvhView = [[GCVVHView alloc] initWithFrame: vvhRect];
	vvhView.data = data;
	vvhView.p1Name = [game player1Name];
	vvhView.p2Name = [game player2Name];
	[scroll addSubview: vvhView];
	[scroll setContentSize: CGSizeMake(vvhRect.size.width, vvhRect.size.height)];
	[vvhView release];
	
	[self.view addSubview: scroll];
	//[scroll release];
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
