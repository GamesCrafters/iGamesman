    //
//  GCConnectionsViewController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/21/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectionsViewController.h"


@implementation GCConnectionsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (id) initWithGame: (GCConnections *) _game {
	if (self = [super init]) {
		game = _game;
		size = _game.size;
	}
	return self;
}

//added this method to label whose turn it is! 
- (void) updateLabels{
	NSString *player = ([game currentPlayer] == PLAYER1) ? [game player1Name] : [game player2Name];
	NSString *color = ([game currentPlayer] == PLAYER1) ? @"Red" : @"Blue";
	if(game.gameMode == ONLINE_SOLVED && game.predictions){
		
	}
	else{
		[message setText: [NSString stringWithFormat: @"%@ (%@)'s turn", player, color]];
	}
	if([game primitive: [game getBoard]]){
		[self displayPrimitive];
	}
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 416)];
	else
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 256)];
	
	self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];

	float squareSize;
	// Come back to this bit later after I figure out how tall the top
	// Row will be to make the move value bigger
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		squareSize = MIN(300.0 / size, 356.0 / size);
	else
		squareSize = MIN(236.0 / size, 380.0 / size);
	
	int tag = 1;
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			float x = i * squareSize;
			float y = j * squareSize;
			
			if (i % 2 == j % 2) {		// It's a slot (except the corners)
				if ( (i != 0 || j != 0) && (i != 0 || j != size-1) && (i != size-1 || j != 0) && (i != size-1 || j != size-1) ) {
					UIButton *button = [[UIButton buttonWithType: UIButtonTypeCustom]
										initWithFrame: CGRectMake(10 + x, 
																  10 + y, 
																  squareSize,  squareSize)];
					button.tag = tag;
					[button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
					button.adjustsImageWhenDisabled = NO;
					[self.view addSubview: button];
				}
			} else if (i % 2 == 0) {	// It's O
				UIImageView *_O = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x, 10 + y, 
																				squareSize, 
																				squareSize)];
				[_O setImage: [UIImage imageNamed: @"ConO.png"]];
				[self.view addSubview: _O];
			} else {					// It's X
				UIImageView *_X = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x, 10 + y, 
																				squareSize, 
																				squareSize)];
				[_X setImage: [UIImage imageNamed: @"ConX.png"]];
				[self.view addSubview: _X];
			}
			tag += 1;
		}
	}
	
	///dislaying who's turn it is
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		message = [[UILabel alloc] initWithFrame: CGRectMake(20, 25 + size * squareSize, 
															 280, 416 - (35 + size * squareSize))];
	message.backgroundColor = [UIColor clearColor];
	message.textColor = [UIColor whiteColor];
	message.textAlignment = UITextAlignmentCenter;
	message.text = @"";
	[self.view addSubview: message];	
	
	[self disableButtons];
	
	[self updateLabels];
}

// don't think this works
- (void) displayPrimitive{
	NSString *value = [game primitive: [game getBoard]];
	NSString *winner;
	NSString *color;
	if ([value isEqualToString: @"WIN"]) {
		//winner = game.p1Turn ? game.player2Name : game.player1Name;
		winner = game.p1Turn ? game.player1Name : game.player2Name;
		color = game.p1Turn ? @"Red" : @"Blue";
	} else {
		//winner = game.p1Turn ? game.player1Name : game.player2Name;
		winner = game.p1Turn ? game.player2Name : game.player1Name;
		color = game.p1Turn ? @"Blue" : @"Red";
	}
	message.text = [NSString stringWithFormat: @"%@ (%@) wins!", winner, color];
}

- (void) doMove: (NSNumber *) move {
	
	UIButton *B = (UIButton *) [self.view viewWithTag: [move integerValue]];
	float B_width = B.frame.size.width;
	

	UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(B.center.x - 5, B.center.y - 5, 10, 10)];
	[self.view insertSubview: img atIndex: 0];
	[img setImage: [UIImage imageNamed: (game.p1Turn ? @"ConXBar.png" : @"ConOBar.png")]];
	
	[UIView beginAnimations: @"Stretch" context: NULL];
	int parity = (([move integerValue] - 1) / size) % 2;
	if (game.p1Turn ^ parity) {
		[img setFrame: CGRectMake(B.center.x - .75 * B_width, B.center.y - B_width/6.0 , 1.5 * B_width ,  B_width/3.0)];
	}
	else{
		[img setFrame: CGRectMake(B.center.x - B_width/6.0, B.center.y - .75 * B_width, B_width/3.0, 1.5 * B_width)];
	}
	
	[UIView commitAnimations];
	
	[img release];
	//[B removeFromSuperview];
	
	/*
	[B retain];
	[B removeFromSuperview];
	[self.view insertSubview: B atIndex: 0];
	[B release];
	float B_width = B.frame.size.width;
	//B.frame = CGRectMake(B.center.x - B_width / 4, B.center.y - B_width / 4, B_width / 2, B_width / 2);
	[B setBackgroundImage: [UIImage imageNamed: (game.p1Turn ? @"ConX.png" : @"ConO.png")] forState: UIControlStateNormal];
	
	[UIView beginAnimations: @"Stretch" context: NULL];
	int parity = (([move integerValue] - 1) / size) % 2;
	if (game.p1Turn ^ parity) {
		B.frame = CGRectMake(B.center.x - B_width * 2, B.center.y - B_width / 4,  B_width * 4, B_width / 2);
	} else {
		B.frame = CGRectMake(B.center.x - B_width / 4, B.center.y - B_width * 2,  B_width / 2, B_width * 4);
	}
	[UIView commitAnimations];*/
}

- (void) tapped: (UIButton *) button{
	NSNumber * num = [NSNumber numberWithInt: button.tag];
	if([[game legalMoves] containsObject: num])
		[game postHumanMove: num];
}

/** Convenience method for disabling all of the board's buttons. */
- (void) disableButtons {
	for (int i = 1; i < size * size + 1; i += 1) {
		UIView *B = [self.view viewWithTag: i];
		if ([B isKindOfClass: [UIButton class]]) {
			[(UIButton *) B setEnabled: NO];
		}
	}
}


/** Convenience method for enabling all of the board's buttons. */
- (void) enableButtons {
	for (int i = 1; i < size * size + 1; i += 1) {
		UIView *B = [self.view viewWithTag: i];
		if ([B isKindOfClass: [UIButton class]]) {
			[(UIButton *) B setEnabled: YES];
		}
	}
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

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
