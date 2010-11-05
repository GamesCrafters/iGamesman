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
#define XVERT @"X"
#define XHORIZ @"x"
#define YVERT @"Y"
#define YHORIZ @"y"
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


- (void) doMove: (NSArray *) move {
	if ([[move objectAtIndex: 2] isEqual: SPIN])
	{
		UIImageView *image = [self.view viewWithTag:1000 + [[move objectAtIndex: 0] intValue]];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:image cache:YES];
		if (game.p1Turn)
			if ([[move objectAtIndex: 1] isEqual: XHORIZ])
			{
				[image setImage:[UIImage imageNamed: @"ConGreenH.png"]];
			}
			else 
			{
				[image setImage:[UIImage imageNamed: @"ConGreenV.png"]];
			}
		else
		{
			if ([[move objectAtIndex: 1] isEqual: YHORIZ])
			{
				[image setImage:[UIImage imageNamed: @"ConRedH.png"]];
			}
			else 
			{
				[image setImage:[UIImage imageNamed: @"ConRedV.png"]];
			}
		}
		[UIView commitAnimations];
	}
	else
	{
		UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"ConGreenH.png" : @"ConRedH.png"]];
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
		if ([[move objectAtIndex: 1] isEqual: XHORIZ])
		{
			[piece setImage:[UIImage imageNamed: @"ConGreenV.png"]];
		}
		else if ([[move objectAtIndex: 1] isEqual: XVERT])
		{
			[piece setImage:[UIImage imageNamed: @"ConGreenH.png"]];
		}
		else if ([[move objectAtIndex: 1] isEqual: YHORIZ])
		{
			[piece setImage:[UIImage imageNamed: @"ConRedV.png"]];
		}
		else if ([[move objectAtIndex: 1] isEqual: YVERT])
		{
			[piece setImage:[UIImage imageNamed: @"ConRedH.png"]];
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
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
	
		CGFloat size = MIN((w - 180)/game.cols, (h - 20)/game.rows);
	
		UITouch *theTouch = [touches anyObject];
		CGPoint loc = [theTouch locationInView: self.view];
	
		if (CGRectContainsPoint(CGRectMake(10, 10, size * game.cols, size * game.rows), loc)) {
			int col = (loc.x - 10) / size;
			int row = (loc.y - 10) / size;
			int slot = col + game.cols * row;
		
			
			if (game.p1Turn)
			{
				if ([[[game getBoard] objectAtIndex: slot] isEqual: YVERT]){}
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: YHORIZ]){}
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: XVERT])
					[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], XHORIZ, SPIN, nil]];
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: XHORIZ])
					[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], XVERT, SPIN, nil]];
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: BLANK])
				{
					[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], XHORIZ, PLACE, nil]];
				}
			}
			else
			{
				if ([[[game getBoard] objectAtIndex: slot] isEqual: XVERT]){}
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: XHORIZ]){}
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: YVERT])
					[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], YHORIZ, SPIN, nil]];
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: YHORIZ])
					[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], YVERT, SPIN, nil]];
				else if ([[[game getBoard] objectAtIndex: slot] isEqual: BLANK])
				{
					[game postHumanMove: [NSArray arrayWithObjects: [NSNumber numberWithInt: slot], YHORIZ, PLACE, nil]];
				}
			}
			
		}
	}
}

- (void)loadView {
	self.view = [[GCQuickCrossView alloc] initWithFrame: CGRectMake(0, 0, 480, 256) andRows: game.rows andCols: game.cols];
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
