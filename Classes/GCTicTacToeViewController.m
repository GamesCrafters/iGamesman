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

- (void) updateServerDataWithService: (GCJSONService *) _service {
	service = _service;
	[spinner startAnimating];
	[self.view bringSubviewToFront: spinner];
	waiter = [[NSThread alloc] initWithTarget: self selector: @selector(fetchNewData:) object: [NSNumber numberWithBool:touchesEnabled]];
	[waiter start];
	timer = [[NSTimer scheduledTimerWithTimeInterval: 60 target: self selector: @selector(timedOut:) userInfo: nil repeats: NO] retain];
}

- (void) fetchNewData: (BOOL) buttonsOn {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *boardString = [GCTicTacToe stringForBoard: [game getBoard]];
	NSString *boardURL = [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	NSString *boardVal = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/ttt/getMoveValue;width=%d;height=%d;pieces=%d;board=%@", game.cols, game.rows, game.inarow, boardURL] retain];
	NSString *moveVals = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/ttt/getNextMoveValues;width=%d;height=%d;pieces=%d;board=%@", game.cols, game.rows, game.inarow, boardURL] retain];
	[service retrieveDataForBoard: boardString URL: boardVal andNextMovesURL: moveVals];
	[self performSelectorOnMainThread: @selector(fetchFinished:) withObject: [NSNumber numberWithBool: buttonsOn] waitUntilDone: NO];
	[pool release];
}


- (void) fetchFinished: (BOOL) buttonsOn {
	if (waiter != nil) {
		if (buttonsOn);
		//[self enableButtons];
		[spinner stopAnimating];
		[timer invalidate];
	}
	if (![service connected] || ![service status])
		[game postProblem];
	else {
		// Create the new data entry
		/*NSArray *keys = [[NSArray alloc] initWithObjects: @"board", @"value", @"remoteness", @"children", nil];
		NSMutableDictionary *children = [[NSMutableDictionary alloc] init];
		for (NSString *move in [game legalMoves]) {
			move = [NSString stringWithFormat: @"%d", [move integerValue] - 1];
			NSDictionary *moveDict = [[NSDictionary alloc] initWithObjectsAndKeys: [[service getValueAfterMove: move] lowercaseString], @"value",
									  [NSNumber numberWithInteger: [service getRemotenessAfterMove: move]], @"remoteness", nil];
			[children setObject: moveDict forKey: move];
		}
		NSString *val = [service getValue];
		if (!val) val = @"UNAVAILABLE";
		NSArray *values = [[NSArray alloc] initWithObjects: [[game getBoard] copy], val, [NSNumber numberWithInteger: [service getRemoteness]], children, nil];
		[children release];
		NSDictionary *entry = [[NSDictionary alloc] initWithObjects: values forKeys: keys];
		[values release];
		[keys release];*/
		
		// Push the new entry onto the history stack
		/*NSDictionary *last = [game.serverHistoryStack lastObject];
		if ([[last objectForKey: @"board"] isEqual: [entry objectForKey: @"board"]])
			[game.serverHistoryStack removeLastObject];
		[game.serverHistoryStack addObject: entry];*/
		
		[game postReady];
	}
	[self updateDisplay];
}


- (void) timedOut: (NSTimer *) theTimer {
	messageLabel.numberOfLines = 4;
	messageLabel.lineBreakMode = UILineBreakModeWordWrap;
	[messageLabel setText: @"Server request timed out. Check the strength of your Internet connection."];
	
	[waiter cancel];
	[waiter release];
	waiter = nil;
	[spinner stopAnimating];
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
	} else {
		if ([game playMode] == OFFLINE_UNSOLVED || !game.predictions)
			messageLabel.text = [NSString stringWithFormat: @"%@ (%@)'s turn", player, color];
		else {
			messageLabel.text = [NSString stringWithFormat: @"%@ (%@) should %@ in %d", player, color, [game getValue], [game getRemoteness]];
		}
	}
	
	if ([game playMode] == OFFLINE_UNSOLVED || !game.moveValues) {
		// Remove any old values
		for (int i = 0; i < game.rows * game.cols; i += 1)
			[[self.view viewWithTag: 5000 + i] removeFromSuperview];
	}
	
	if ([game playMode] == ONLINE_SOLVED && game.moveValues) {
		// Remove the old values
		for (int i = 0; i < game.rows * game.cols; i += 1)
			[[self.view viewWithTag: 5000 + i] removeFromSuperview];
		for (NSNumber *move in [game legalMoves]) {
			UIImage *piece = [UIImage imageNamed: [[NSDictionary dictionaryWithObjectsAndKeys: @"TTTWin.png", @"WIN",
																  @"TTTLose.png", @"LOSE", @"TTTTie.png", @"TIE", nil] objectForKey: [[game getValueOfMove: move] uppercaseString]]];
			UIImageView *valueMove = [[UIImageView alloc] initWithImage: piece];
			
			int col = [move intValue] % game.cols;
			int row = [move intValue] / game.cols;
			CGFloat w = self.view.bounds.size.width;
			CGFloat h = self.view.bounds.size.height;
			CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
			
			[valueMove setFrame: CGRectMake(10 + col * size, 10 + row * size, size, size)];
			valueMove.tag = 5000 + [move intValue];
			
			[self.view addSubview: valueMove];
			
			[valueMove release];
		}
	}
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
	
	CGFloat w = self.view.bounds.size.width;
	CGFloat h = self.view.bounds.size.height;
	CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);

	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = CGPointMake(10 + size * game.cols / 2.0, 10 + size * game.rows / 2.0);
	[self.view addSubview: spinner];
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
	[spinner release];
}


- (void)dealloc {
    [super dealloc];
}


@end
