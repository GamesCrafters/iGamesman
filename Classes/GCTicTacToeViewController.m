    //
//  GCTicTacToeViewController.m
//  GamesmanMobile
//
//  Created by Class Account on 10/8/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCTicTacToeViewController.h"
#import "GCTicTacToeView.h"


@implementation GCTicTacToeViewController

- (id) initWithGame: (GCTicTacToe *) _game {
	if (self = [super init]) {
		game = _game;
	}
	return self;
}

- (void) doMove: (NSNumber *) move {	
	//CGRect rect = CGRectMake(10 + col * size, 10 + row * size, size, size);	
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGFloat w = self.view.bounds.size.width;
	CGFloat h = self.view.bounds.size.height;
	
	CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
	
	UITouch *theTouch = [touches anyObject];
	CGPoint loc = [theTouch locationInView: self.view];
	
	if (CGRectContainsPoint(CGRectMake(10, 10, size * game.cols, size * game.rows), loc)) {
		int col = (loc.x - 10) / size;
		int row = (loc.y - 10) / size;
		
		CGRect rect = CGRectMake(10 + col * size, 10 + row * size, size, size);
		UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"C4X.png" : @"C4O.png"]];
		[piece setFrame: rect];
		piece.tag = 55555;
		[self.view addSubview: piece];
	}
}

- (void)loadView {
	self.view = [[GCTicTacToeView alloc] initWithFrame: CGRectMake(0, 0, 480, 256) andRows: game.rows andCols: game.cols];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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


- (void)dealloc {
    [super dealloc];
}


@end
