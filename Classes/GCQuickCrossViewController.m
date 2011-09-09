//
//  GCQuickCrossViewController.m
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCQuickCrossViewController.h"
#import "GCQuickCrossView.h"

#define BLANK @"+"
#define HORIZ @"-"
#define VERT @"|"
#define PLACE @"place"
#define SPIN @"spin"


@implementation GCQuickCrossViewController

@synthesize touchesEnabled;


- (id) initWithGame: (GCQuickCross *) _game {
	if (self = [super init]) {
		game = _game;
	}
	return self;
}

- (void) updateDisplay {
	NSString *player = game.p1Turn ? [game player1Name] : [game player2Name];
	NSString *oppPlayer = game.p1Turn ? [game player2Name] : [game player1Name];
	NSString *primitive = [game primitive];
	if (primitive) {
		messageLabel.text = [NSString stringWithFormat: @"%@ wins!", ([primitive isEqualToString: @"HorizWIN"] || [primitive isEqualToString: @"VertWin"]) ? player : oppPlayer];
	} else {
		if ([game playMode] == OFFLINE_UNSOLVED || !game.predictions)
			messageLabel.text = [NSString stringWithFormat: @"%@'s turn", player];	
		else {
			messageLabel.text = [NSString stringWithFormat: @"%@ should %@ in %d", player, [game getValue], [game getRemoteness]];
		}
	}
	
	if ([game playMode] == OFFLINE_UNSOLVED || !game.moveValues) {
		// Remove any move values from screen since move values must have turned off
		for (int i = 0; i < game.rows * game.cols; i += 1)
			[[self.view viewWithTag: 5000 + i] removeFromSuperview];
	}
	if ([game playMode] == ONLINE_SOLVED && game.moveValues) {
		// Remove the old values; new values
		for (int i = 0; i < game.rows * game.cols; i += 1)
			[[self.view viewWithTag: 5000 + i] removeFromSuperview];
		for (NSArray *move in [game legalMoves]) {
			UIImage *piece = [UIImage imageNamed: @"QCHoriz.png"];
			
			if ([[move objectAtIndex: 1] isEqual: HORIZ])
			{
				piece = [UIImage imageNamed: [[NSDictionary dictionaryWithObjectsAndKeys: @"QCWinH.png", @"WIN", @"QCLoseH.png", @"LOSE", nil] objectForKey: [game getValueOfMove: move]]];
			}
			else {
				piece = [UIImage imageNamed: [[NSDictionary dictionaryWithObjectsAndKeys: @"QCWinV.png", @"WIN", @"QCLoseV.png", @"LOSE", nil] objectForKey: [game getValueOfMove: move]]];
			}
			
			UIImageView *valueMove = [[UIImageView alloc] initWithImage: piece];
			
			int col = [[move objectAtIndex: 0] intValue] % game.cols;
			int row = [[move objectAtIndex: 0] intValue] / game.cols;
			CGFloat w = self.view.bounds.size.width;
			CGFloat h = self.view.bounds.size.height;
			CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
			
			[valueMove setFrame: CGRectMake(10 + col * size, 10 + row * size, size, size)];
			valueMove.tag = 5000 + [[move objectAtIndex: 0] intValue];
			NSInteger index = 1;
			[self.view insertSubview: valueMove atIndex: index];
			[valueMove release];
		}
	}
}

- (void) doMove: (NSArray *) move {
	if ([[move objectAtIndex: 2] isEqual: SPIN])
	{
		UIImageView *image = (UIImageView *)[self.view viewWithTag:1000 + [[move objectAtIndex: 0] intValue]]; //piece is already there
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:image cache:YES];
		if ([[move objectAtIndex: 1] isEqual: HORIZ])
		{
			[image setImage:[UIImage imageNamed: @"QCHoriz.png"]];
		}
		else 
		{
			[image setImage:[UIImage imageNamed: @"QCVert.png"]];
		}
		[UIView commitAnimations];
	}
	else
	{
		UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"QCHoriz.png"]]; //piece is not there; need to initialize
		
		if ([[move objectAtIndex: 1] isEqual: HORIZ]) 
		{
			piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"QCHoriz.png"]];
		}
		else {
			piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"QCVert.png"]];
		}
		int col = [[move objectAtIndex: 0] intValue] % game.cols;
		int row = [[move objectAtIndex: 0] intValue] / game.cols;
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
		CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
		
		[piece setFrame: CGRectMake(10 + col * size, 10 + row * size, size, size)];
		piece.tag = 1000 + [[move objectAtIndex: 0] intValue];
		[self.view addSubview: piece];
	}
	
}

- (void) undoMove: (NSArray *) move {
	UIImageView *piece = (UIImageView *) [self.view viewWithTag: 1000 + [[move objectAtIndex: 0] intValue]];
	if ([[move objectAtIndex: 2] isEqual: SPIN])
	{
		if ([[move objectAtIndex: 1] isEqual: HORIZ])
		{
			[piece setImage:[UIImage imageNamed: @"QCVert.png"]];
		}
		else
		{
			[piece setImage:[UIImage imageNamed: @"QCHoriz.png"]];
		}
	}
	else
	{
		[piece removeFromSuperview];
		[piece release];
	}
}
	

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(touchesEnabled) {
		UITouch *theTouch = [touches anyObject];
		start = [theTouch locationInView: self.view];
	}
}
		
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGFloat w = self.view.bounds.size.width;
	CGFloat h = self.view.bounds.size.height;
	
	CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
	
	CGPoint loc = start;
	if (CGRectContainsPoint(CGRectMake(10, 10, size * game.cols, size * game.rows), loc)) {
		int col = (loc.x - 10) / size;
		int row = (loc.y - 10) / size;
		int slot = col + game.cols * row;
	
		if ([[[game getBoard] objectAtIndex: slot] isEqual: VERT])
			[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], HORIZ, SPIN, nil]];
		else if ([[[game getBoard] objectAtIndex: slot] isEqual: HORIZ])
			[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], VERT, SPIN, nil]];
		else if ([[[game getBoard] objectAtIndex: slot] isEqual: BLANK])
		{
			UITouch *theTouch = [touches anyObject];
			CGPoint end = [theTouch locationInView: self.view];
			
			double slope = ABS((end.y - start.y)/(end.x - start.x));
			if (slope > 1)
			{
				[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], VERT, PLACE, nil]];
			}
			else {
				[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], HORIZ, PLACE, nil]];
			}

		}
		
	}
}

- (void)loadView {
	self.view = [[GCQuickCrossView alloc] initWithFrame: CGRectMake(0, 0, 480, 256) andRows: game.rows andCols: game.cols];
	
	messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(320, 50, 140, 156)];
	messageLabel.text = [NSString stringWithFormat: @"%@'s turn", [game player1Name]];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.textAlignment = UITextAlignmentCenter;
	messageLabel.numberOfLines = 4;
	messageLabel.lineBreakMode = UILineBreakModeWordWrap;
	[self.view addSubview: messageLabel];
	start = CGPointZero;
	[self updateDisplay];
	
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
