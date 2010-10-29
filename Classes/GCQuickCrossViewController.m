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
	if ((game.p1Turn) ? ([game player1Type] != HUMAN) : ([game player2Type] != HUMAN)) {
		UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"ConGreenV.png" : @"ConRedV.png"]];
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
			
			
			
			CGRect rect = CGRectMake(10 + col * size, 10 + row * size, size, size);
			
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
			
			UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"ConGreenV.png" : @"ConRedV.png"]];
			[piece setFrame: rect];
			piece.tag = 55556;
			[self.view addSubview: piece];
			
			
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
