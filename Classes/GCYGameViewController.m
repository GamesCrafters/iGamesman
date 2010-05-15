//
//  GCYGameViewController.m
//  GamesmanMobile
//
//  Created by Linsey Hansen on 3/7/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCYGameViewController.h"
#import "GCYGamePiece.h"


@implementation GCYGameViewController

- (id) initWithGame: (GCYGame *) _game{
	if (self = [super init]){
		game = _game;
		boardView = [[GCYBoardView alloc] initWithFrame: CGRectMake(0, 0, 320, 416) withLayers: game.layers andInnerLength: game.innerTriangleLength];
		self.view = boardView;
		
		message = [[UILabel alloc] initWithFrame: CGRectMake(20, 15 + 320, 
															 280, 416 - (35 + 320))];
		message.backgroundColor = [UIColor clearColor];
		message.textColor = [UIColor whiteColor];
		message.textAlignment = UITextAlignmentCenter;
		message.text = @" ";
		[boardView addSubview: message];
		
		
		UILabel *version = [[UILabel alloc] initWithFrame: CGRectMake(200, 0, 120, 20)];
		version.backgroundColor = [UIColor blackColor];
		version.adjustsFontSizeToFitWidth = YES;
		version.textColor = [UIColor whiteColor];//[UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
		version.textAlignment = UITextAlignmentCenter;
		version.text = game.misere ? @"Play Mode: Misere" : @"Play Mode: Standard";
		[boardView addSubview: version];
		[self updateLabels];
		boardView.multipleTouchEnabled = NO;
		
		CGPoint currentCenter;
		
		CGFloat frameSize = [boardView circleRadius] * 5;
		//Create buttons! yay!
		for (int i = 1; i <= [boardView boardSize]; i++){
			currentCenter = [[[boardView centers] objectAtIndex: i-1] CGPointValue];
			GCYGamePiece *button = [[GCYGamePiece alloc] initWithFrame:CGRectMake(0, 0, frameSize, frameSize)];
			button.tag = i;
			[button moveCenter: currentCenter];
//			[button setTitle: [NSString stringWithFormat: @"%d", i] forState: UIControlStateNormal];
//			[button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
			[button setBackgroundColor: [UIColor clearColor]];
			[button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
			[boardView addSubview: button];
			
			[button release];
		}
	}
	return self;
}


- (int) boardSize{
	return [boardView boardSize];
}

//added this method to label whose turn it is! 
- (void) updateLabels{
	NSString *player = ([game currentPlayer] == PLAYER1) ? [game player1Name] : [game player2Name];
	NSString *color = ([game currentPlayer] == PLAYER1) ? @"Red" : @"Blue";
	//remove this later
	[message setText: [NSString stringWithFormat: @"%@ (%@)'s turn", player, color]];
	
	
	if(game.gameMode == ONLINE_SOLVED && game.predictions){
		message.numberOfLines = 2;
		NSString *value = [game.service getValue];
		PlayerType typePlay = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
		PlayerType typeOpp  = ([game currentPlayer] == PLAYER1) ? [game player2Type] : [game player1Type];
		NSString *modifier;
		if ([game playMode] == COMPUTER_PERFECT && value == @"win") modifier = @"will";
		else if (typeOpp == COMPUTER_PERFECT && value == @"lose") modifier = @"will";
		else if (typePlay == COMPUTER_PERFECT && typeOpp == COMPUTER_PERFECT) modifier = @"will";
		else modifier = @"should";
		[message setText: [NSString stringWithFormat: @"%@ (%@)'s turn\n%@ %@ in %d", player, color, modifier, [game.service getValue], [game.service getRemoteness]]];
	}
	else{
		[message setText: [NSString stringWithFormat: @"%@ (%@)'s turn", player, color]];
	}
	
	if (game.gameMode == ONLINE_SOLVED && game.moveValues) {
		NSDictionary *movesAndValues = [self getServerValues: [self translateToServer: [game legalMoves]]];
		for (NSNumber *move in [movesAndValues allKeys]) {
			GCYGamePiece *B = (GCYGamePiece *) [self.view viewWithTag: [move intValue] + 1];
			NSString *color, *direction;
			
			//eventually change these to circular backgrounds
			if ([[movesAndValues objectForKey: move] isEqual: @"CLEAR"])
				[B.moveValue setBackgroundColor: [UIColor clearColor]];
			else if ([[movesAndValues objectForKey: move] isEqual: @"win"])
				[B.moveValue setBackgroundColor: [UIColor greenColor]];
			else
				[B.moveValue setBackgroundColor: [UIColor brownColor]];
			

		}
	}
	
	if([game primitive: [game getBoard]]){
		[self displayPrimitive];
	}
}


- (NSArray *) translateToServer: (NSArray *) moveArray{
	int serverValue;
	NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity: [moveArray count]];
	for(int i = 0; i < [moveArray count]; i++){
		serverValue = [[moveArray objectAtIndex: i] intValue] - 1;
		[result addObject: [NSNumber numberWithInt: serverValue]];
	}
	return result;
}
- (NSDictionary *) getServerValues: (NSArray *) moves{
	int realValue = 0;
	NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity: [moves count]];

	//no idea what I'm doing here
	
	return result;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	
	[self disableButtons];
	[self updateLabels];

}

- (NSSet *) positionConnections: (NSNumber *) position{
	if ([boardView neighborsForPosition])
		return [[boardView neighborsForPosition] objectForKey: position];
	else return nil;
}

- (NSArray *) leftEdges{
	return [boardView positionsAtEdge: 1];
}


- (NSSet *) positionEdges: (NSNumber *) position{
	return [boardView edgesForPosition: position];
}

- (void) doMove: (NSNumber *) move {
	NSInteger neighborInt;
	NSInteger moveInt = [move integerValue];
	
	GCYGamePiece *B = (GCYGamePiece *) [self.view viewWithTag: moveInt];
	//[B retain];
	//[B removeFromSuperview];
	//[self.view insertSubview: B atIndex: 0];
	//[B release];
	//float B_width = B.frame.size.width;
	//B.frame = CGRectMake(B.center.x - B_width / 4, B.center.y - B_width / 4, B_width / 2, B_width / 2);
	//NSLog([move description]);
	[B makeMove: [game p1Turn]];
	//[B setBackgroundColor: ([game p1Turn] ? [UIColor redColor] : [UIColor blueColor])];
	
	// do the board animations here (ie piece and connection animations)
	for (NSNumber *neighborPosition in [[boardView neighborsForPosition] objectForKey: move]){
		neighborInt = [neighborPosition integerValue];
		
		if (game.p1Turn){
			if ([game boardContainsPlayerPiece: @"X" forPosition: neighborPosition]){
				NSLog(@" %d, %d", moveInt, neighborInt);
				[boardView addConnectionFrom: moveInt - 1 to: neighborInt - 1 forPlayer: YES];

			}
		}
		else{
			if ([game boardContainsPlayerPiece: @"O" forPosition: neighborPosition]){
				NSLog(@" %d, %d", moveInt, neighborInt);
				[boardView addConnectionFrom: moveInt - 1 to: neighborInt - 1 forPlayer: NO];
				

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
	for (int i = 1; i <= [boardView boardSize]; i++){
		UIView *button = (UIButton *) [self.view viewWithTag: i];
		if ([button isKindOfClass: [UIButton class]])
			[(UIButton *) button setEnabled: NO];
	}
}


- (void) enableButtons {
	for (int i = 1; i <= [boardView boardSize]; i++){
		UIView *button = (UIButton *) [self.view viewWithTag: i];
		if ([button isKindOfClass: [UIButton class]])
			[(UIButton *) button setEnabled: YES];
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
	[boardView release];
    [super dealloc];
}


@end
