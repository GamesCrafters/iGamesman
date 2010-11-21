    //
//  GCTicTacToeViewController.m
//  GamesmanMobile
//
//  Created by Class Account on 10/8/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCTicTacToeViewController.h"
#import "GCTicTacToeView.h"

#define BLANK @"+"


@implementation GCTicTacToeViewController

@synthesize touchesEnabled;

- (id) initWithGame: (GCTicTacToe *) _game {
	if (self = [super init]) {
		game = _game;
	}
	return self;
}

- (void) updateDisplay {
	NSString *player = game.p1Turn ? [game player1Name] : [game player2Name];
	NSString *oppPlayer = game.p1Turn ? [game player2Name] : [game player1Name];
	NSString *color = game.p1Turn ? @"X" : @"O";
	NSString *primitive = [game primitive];
	
	if (primitive) {
		if ([primitive isEqualToString: @"TIE"])
			messageLabel.text = @"It's a tie!";
		else {
			messageLabel.text = [NSString stringWithFormat: @"%@ wins!", [primitive isEqualToString: @"WIN"] ? player : oppPlayer];
		}
	} else
		messageLabel.text = [NSString stringWithFormat: @"%@ (%@)'s turn", player, color];	
}

- (void) doMove: (NSNumber *) move {	
	UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"TTTX.png" : @"TTTO.png"]];
	int col = [move intValue] % game.cols;
	int row = [move intValue] / game.cols;
	CGFloat w = self.view.bounds.size.width;
	CGFloat h = self.view.bounds.size.height;
	CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
	
	[piece setFrame: CGRectMake(10 + (col + 0.5) * size, 10 + (row + 0.5) * size, 0, 0)];
	piece.tag = 1000 + [move intValue];
	
	[self.view addSubview: piece];
	
	[UIView beginAnimations: @"AddPiece" context: NULL];
	[piece setFrame: CGRectMake(10 + col * size, 10 + row * size, size, size)];
	[UIView commitAnimations];
	
	[piece release];
}

- (void) undoMove: (NSNumber *) move {
	UIImageView *piece = (UIImageView *) [self.view viewWithTag: 1000 + [move intValue]];
	
	CGPoint center = piece.center;
	[UIView beginAnimations: @"RemovePiece" context: NULL];
	[piece setFrame: CGRectMake(center.x, center.y, 0, 0)];
	piece.tag = 0;
	[UIView commitAnimations];
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
			
			if ([[[game getBoard] objectAtIndex: slot] isEqual: BLANK])
				[game postHumanMove: [NSNumber numberWithInt: slot]];
		}
	}
}

- (void)loadView {
	self.view = [[GCTicTacToeView alloc] initWithFrame: CGRectMake(0, 0, 480, 256) andRows: game.rows andCols: game.cols];
	
	messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(320, 50, 140, 156)];
	messageLabel.text = @"Player 1 (X)'s turn";
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.textAlignment = UITextAlignmentCenter;
	messageLabel.numberOfLines = 4;
	messageLabel.lineBreakMode = UILineBreakModeWordWrap;
	[self.view addSubview: messageLabel];
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
	[messageLabel release];
}


- (void)dealloc {
    [super dealloc];
}


@end
