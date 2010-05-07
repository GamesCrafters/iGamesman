//
//  GCYGameViewController.m
//  GamesmanMobile
//
//  Created by Linsey Hansen on 3/7/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCYGameViewController.h"


@implementation GCYGameViewController

- (id) initWithGame: (GCYGame *) _game{
	if (self = [super init]){
		game = _game;
		//boardView = [[GCYBoardView alloc] init];
		//boardView.game = _game;
		switch  (game.layers){
			case 0:
				self = [super initWithNibName:@"GCYBoardView0" bundle: nil];
				break;
			case 1:
				self = [super initWithNibName:@"GCYBoardView1" bundle: nil];
				break;
			case 2:
				self = [super initWithNibName:@"GCYBoardView2" bundle: nil];
				break;
			default:
				self = nil;
				break;
		}
	}
	return self;
}



//added this method to label whose turn it is! 
- (void) updateLabels{
	NSString *player = ([game currentPlayer] == PLAYER1) ? [game player1Name] : [game player2Name];
	NSString *color = ([game currentPlayer] == PLAYER1) ? @"Red" : @"Blue";
	[message setText: [NSString stringWithFormat: @"%@ (%@)'s turn", player, color]];
	
	if([game primitive: [game getBoard]]){
		[self displayPrimitive];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	message = [[UILabel alloc] initWithFrame: CGRectMake(20, 25 + 320, 
														 280, 416 - (35 + 320))];
	message.backgroundColor = [UIColor clearColor];
	message.textColor = [UIColor whiteColor];
	message.textAlignment = UITextAlignmentCenter;
	message.text = @"";
	[self.view addSubview: message];
	
	[self disableButtons];
	[self updateLabels];
}


- (void) doMove: (NSNumber *) move {
	NSInteger tag;
	UIView *connectionView;
	NSInteger neighborInt;
	NSInteger moveInt = [move integerValue];
	
	//NSLog(@"do move: %d", [move integerValue]);
	UIButton *B = (UIButton *) [self.view viewWithTag: moveInt];
	//[B retain];
	//[B removeFromSuperview];
	//[self.view insertSubview: B atIndex: 0];
	//[B release];
	//float B_width = B.frame.size.width;
	//B.frame = CGRectMake(B.center.x - B_width / 4, B.center.y - B_width / 4, B_width / 2, B_width / 2);
	NSLog([move description]);
	[B setBackgroundImage: [UIImage imageNamed: (game.p1Turn ? @"C4X.png" : @"C4O.png")] forState: UIControlStateNormal];
	
	// do the board animations here (ie piece and connection animations)
	for (NSNumber *neighborPosition in [[game positionConnections] objectForKey: move]){
		neighborInt = [neighborPosition integerValue];
		
		if (game.p1Turn){
			if ([game boardContainsPlayerPiece: @"X" forPosition: neighborPosition]){
				if (moveInt > neighborInt)
					tag = (neighborInt*100) + moveInt;
				else tag = (moveInt*100) + neighborInt;
				NSLog(@" %d, %d, %d", moveInt, neighborInt, tag);
				
				connectionView = [self.view viewWithTag: tag];
				connectionView.hidden = NO;
				[connectionView setBackgroundColor: [UIColor redColor]];
			}
		}
		else{
			if ([game boardContainsPlayerPiece: @"O" forPosition: neighborPosition]){
				if (moveInt > neighborInt)
					tag = (neighborInt*100) + moveInt;
				else tag = (moveInt*100) + neighborInt;
				NSLog(@" %d, %d, %d", moveInt, neighborInt, tag);
				
				connectionView = [self.view viewWithTag: tag];
				connectionView.hidden = NO;
				[connectionView setBackgroundColor: [UIColor blueColor]];
			}
		}
	}
	
//	UIImageView *image = [[UIImageView alloc] initWithImage: (game.p1Turn? @"ConX.png" : @"ConO.png")];
//	[UIView beginAnimations: @"Stretch" context: NULL];
//	for (NSNumber *neighbor in [[game positionConnections] objectForKey: move]){
//		int neighborAsInt = [neighbor integerValue];
//		if (([[game getBoard] objectAtIndex: neighborAsInt] == X && game.p1Turn) || [[game getBoard] objectAtIndex: neighborAsInt] == O && !game.p1Turn){
//			UIButton *neighborButton = (UIButton *) [self.view viewWithTag: neighborAsInt];
//			image.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//		}
//	}
//	[UIView commitAnimations];
	//[boardView doMove: move];
}


- (IBAction) tapped: (UIButton *) button{
	NSLog(@"tapped");
	NSNumber * num = [NSNumber numberWithInt: button.tag];
	if([[game legalMoves] containsObject: num]){
		NSLog(@"posting human move");
		[game postHumanMove: num];
	}
}


// don't think this works
- (void) displayPrimitive{
	NSString *value = [game primitive: [game getBoard]];
	NSString *winner;
	if ([value isEqualToString: @"WIN"])
		//winner = game.p1Turn ? game.player2Name : game.player1Name;
		winner = game.p1Turn ? game.player1Name : game.player2Name;
	else
		//winner = game.p1Turn ? game.player1Name : game.player2Name;
		winner = game.p1Turn ? game.player2Name : game.player1Name;
	message.text = [NSString stringWithFormat: @"%@ wins!", winner];
}

/** Convenience method for disabling all of the board's buttons. */
- (void) disableButtons {
	switch (game.layers){
		case 0:
			for (int i = 1; i < 16; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: NO];
			} 
			break;
		case 1:
			for (int i = 1; i < 31; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: NO];
			} 
			break;
		case 2:
			for (int i = 1; i < 49; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: NO];
			} 
			break;
		default:
			break;
	}
}


- (void) enableButtons {
	switch (game.layers){
		case 0:
			for (int i = 1; i < 16; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: YES];
			} 
			break;
		case 1:
			for (int i = 1; i < 31; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: YES];
			} 
			break;
		case 2:
			for (int i = 1; i < 49; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: YES];
			} 
			break;
		default:
			break;
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	///[GCYBoardView release];
    [super dealloc];
}


@end
