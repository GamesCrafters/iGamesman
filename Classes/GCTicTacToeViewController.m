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

@synthesize touchesEnabled;

- (id) initWithGame: (GCTicTacToe *) _game {
	if (self = [super init]) {
		game = _game;
	}
	return self;
}

- (void) doMove: (NSNumber *) move {	
	if ((game.p1Turn) ? ([game player1Type] != HUMAN) : ([game player2Type] != HUMAN)) {
		UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"C4X.png" : @"C4O.png"]];
		int col = [move intValue] % game.cols;
		int row = [move intValue] / game.cols;
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
		CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
		
		[piece setFrame: CGRectMake(10 + col * size, 10 + row * size, size, size)];
		piece.tag = 1000 + [move intValue];
		[self.view addSubview: piece];
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
		
		CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
		
		UITouch *theTouch = [touches anyObject];
		CGPoint loc = [theTouch locationInView: self.view];
		
		if (CGRectContainsPoint(CGRectMake(10, 10, size * game.cols, size * game.rows), loc)) {
			int col = (loc.x - 10) / size;
			int row = (loc.y - 10) / size;
			int slot = col + game.cols * row;
			
			CGRect rect = CGRectMake(10 + col * size, 10 + row * size, size, size);
			UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"C4X.png" : @"C4O.png"]];
			[piece setFrame: rect];
			piece.tag = 1000 + slot;
			[self.view addSubview: piece];
			
			[game postHumanMove: [NSNumber numberWithInt: slot]];
		}
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
