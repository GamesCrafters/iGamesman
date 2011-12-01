//
//  GCConnectFourViewController.m
//  iGamesman
//
//  Created by Jordan Salter on 26/10/2011.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCConnectFourViewController.h"

@implementation GCConnectFourViewController

@synthesize touchesEnabled;

/**
 The designated initializer.
 
 @param _width the number of columns
 @param _height the number of rows
 @param _pieces the number in a row needed to win
 */
- (id) initWithGame: (GCConnectFour *) _game frame: (CGRect) rect {
	if (self = [super init]) {
        game = _game;
        viewRect = rect;

        width = game.currentPosition.width;
        height = game.currentPosition.height;
        pieces = game.currentPosition.pieces;
		
		touchesEnabled = NO;		
		self.view.multipleTouchEnabled = NO;        
	}
	return self;
}

#pragma mark Custom class methods
- (void) tapped: (UIButton *) sender {
	int col = sender.tag % width;
	if (col == 0) col = width;
    NSNumber *move = [NSNumber numberWithInt:col];
	if ([[game generateMoves] containsObject: move])
		[game doMove: move];
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
	//[self performSelectorOnMainThread: @selector(disableButtons) withObject: nil waitUntilDone: NO];
    NSString *boardString = [game boardString];
	NSString *boardURL = [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	NSString *boardVal = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/connect4/getMoveValue;width=%d;height=%d;pieces=%d;board=%@", width, height, pieces, boardURL] retain];
	NSString *moveVals = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/connect4/getNextMoveValues;width=%d;height=%d;pieces=%d;board=%@", width, height, pieces, boardURL] retain];
	[service retrieveDataForBoard: boardString URL: boardVal andNextMovesURL: moveVals];
	[self performSelectorOnMainThread: @selector(fetchFinished:) withObject: [NSNumber numberWithBool: buttonsOn] waitUntilDone: NO];
	[pool release];
}


- (void) fetchFinished: (BOOL) buttonsOn {
	if (waiter != nil) {
        //		if (buttonsOn);
        //			[self enableButtons];
		[spinner stopAnimating];
		[timer invalidate];
	}
	if (![service connected] || ![service status]) {
		[game postProblem];
	} else {
		// Create the new data entry
		NSArray *keys = [[NSArray alloc] initWithObjects: @"board", @"value", @"remoteness", @"children", nil];
		NSMutableDictionary *children = [[NSMutableDictionary alloc] init];
		for (NSString *move in [game generateMoves]) {
			move = [NSString stringWithFormat: @"%d", [move integerValue] - 1];
			NSDictionary *moveDict = [[NSDictionary alloc] initWithObjectsAndKeys: [[service getValueAfterMove: move] lowercaseString], @"value",
									  [NSNumber numberWithInteger: [service getRemotenessAfterMove: move]], @"remoteness", nil];
			[children setObject: moveDict forKey: move];
		}
		NSString *val = [service getValue];
		if (!val) val = @"UNAVAILABLE";
		NSArray *values = [[NSArray alloc] initWithObjects: [game.currentPosition.board copy], val, [NSNumber numberWithInteger: [service getRemoteness]], children, nil];
		[children release];
		NSDictionary *entry = [[NSDictionary alloc] initWithObjects: values forKeys: keys];
		[values release];
		[keys release];
		
		// Push the new entry onto the history stack
		NSDictionary *last = [game.serverHistoryStack lastObject];
		if ([[last objectForKey: @"board"] isEqual: [entry objectForKey: @"board"]])
			[game.serverHistoryStack removeLastObject];
		[game.serverHistoryStack addObject: entry];
		
		[game postReady];
	}
//	[self updateLabels];
}


- (void) timedOut: (NSTimer *) theTimer {
	message.numberOfLines = 4;
	message.lineBreakMode = UILineBreakModeWordWrap;
	[message setText: @"Server request timed out. Check the strength of your Internet connection."];
	
	[waiter cancel];
	[waiter release];
	waiter = nil;
	[spinner stopAnimating];
}


- (void) updateLabels {
	NSString *player = ([game currentPlayer] == PLAYER_LEFT) ? game.leftPlayer.name : game.rightPlayer.name;
	NSString *color = ([game currentPlayer] == PLAYER_LEFT) ? @"Red" : @"Blue";
	PlayerType typePlay = ([game currentPlayer] == PLAYER_LEFT) ? game.leftPlayer.type : game.rightPlayer.type;
	PlayerType typeOpp  = ([game currentPlayer] == PLAYER_LEFT) ? game.rightPlayer.type : game.leftPlayer.type;
	message.numberOfLines = 4;
	message.lineBreakMode = UILineBreakModeWordWrap;
	if ([game predictions]) {
		NSString *value = [[game getValue] lowercaseString];
		int remoteness  = [game getRemoteness];
		if (value != nil && remoteness != -1) {
			NSString *modifier;
			if (typePlay == COMPUTER && value == @"win") modifier = @"will";
			else if (typeOpp == COMPUTER && value == @"lose") modifier = @"will";
			else if (typePlay == COMPUTER && typeOpp == COMPUTER) modifier = @"will";
			else modifier = @"should";
			[message setText: [NSString stringWithFormat: @"%@ (%@)\n%@ %@ in %d", player, color, modifier, value, remoteness]];
		} else if (value != nil) {
			NSString *modifier;
			if (typePlay == COMPUTER && value == @"win") modifier = @"will";
			else if (typeOpp == COMPUTER && value == @"lose") modifier = @"will";
			else if (typePlay == COMPUTER && typeOpp == COMPUTER) modifier = @"will";
			else modifier = @"should";
			[message setText: [NSString stringWithFormat: @"%@ (%@)\n%@ %@", player, color, modifier, value]];
		}
	} else {
		[message setText: [NSString stringWithFormat: @"%@ (%@)'s turn", player, color]];
	}
	
	if ([game moveValues]) {
		UIImage *gridTop = [UIImage imageNamed: @"C4GridTopClear.png"];
		int lastTag = width * height;
		for (int i = 0; i < width; i += 1) {
			NSString *currentValue = [[game getValueOfMove: [NSString stringWithFormat: @"%d", i + 1]] lowercaseString];
			UIImageView *B = (UIImageView *) [self.view viewWithTag: i + lastTag - width + 1];
			UIView *colorRect = [self.view viewWithTag: 100 + i];
			if ([currentValue isEqualToString: @"win"]) {
				[B setImage: [UIImage imageNamed: @"C4GridTopGreen.png"]];
				[colorRect setBackgroundColor: [UIColor greenColor]];
			} else if ([currentValue isEqualToString: @"lose"]) {
				[B setImage: [UIImage imageNamed: @"C4GridTopRed.png"]];
				[colorRect setBackgroundColor: [UIColor colorWithRed: 139.0/255.0 green: 0.0 blue: 0.0 alpha: 1.0]];
			} else if ([currentValue isEqualToString: @"tie"]) {
				[B setImage: [UIImage imageNamed: @"C4GridTopYellow.png"]];
				[colorRect setBackgroundColor: [UIColor yellowColor]];
			} else {
				[B setImage: gridTop];
				[colorRect setBackgroundColor: [UIColor clearColor]];
			}
		}
	} else {
		UIImage *gridTop = [UIImage imageNamed: @"C4GridTopClear.png"];
		int lastTag = width * height;
		for (int i = lastTag - width + 1; i <= width * height; i += 1) {
			UIImageView *B = (UIImageView *) [self.view viewWithTag: i];
			[B setImage: gridTop];
		}
		for (int i = 0; i < width; i += 1) {
			UIView *colorRect = [self.view viewWithTag: 100 + i];
			[colorRect setBackgroundColor: [UIColor clearColor]];
		}
	}
	
	if (game.gameMode == ONLINE_SOLVED) {
		if (service) {
			if (![service status])
				[message setText: @"Server error. Please try again later"];
			if (![service connected])
				[message setText: @"Server connection failed. Please check your Web connection"];
		}
	}
	
	if ([game primitive])
		[self displayPrimitive];
}


- (void) displayPrimitive {
	GameValue value = [game primitive:game.currentPosition];
	NSString *winner;
	NSString *color;
	if (value == TIE)
		message.text = @"It's a tie!";
	else {
		if (value == WIN) {
            winner = ([game currentPlayer] == PLAYER_LEFT) ? game.leftPlayer.name : game.rightPlayer.name;
            color = ([game currentPlayer] == PLAYER_LEFT) ? @"Red" : @"Blue";
		} else {
            winner = ([game currentPlayer] == PLAYER_LEFT) ? game.rightPlayer.name : game.leftPlayer.name;
			color  = ([game currentPlayer] == PLAYER_LEFT) ? @"Blue" : @"Red";
		}
		message.text = [NSString stringWithFormat: @"%@ (%@) wins!", winner, color];
	}
}


- (void) doMove: (NSNumber *) move {
	int col = [move integerValue];
	if (col == 0) col = width;
	if ([[game generateMoves] containsObject: move]) {		
		// Update the view. Perform the animation
		int tag = col;
		while (tag < width * height + 1) {
			if ([[[[game currentPosition] board] objectAtIndex: tag - 1] isEqual: @"+"])
				break;
			tag += width;
		}
		
		// Now TAG is the tag of the slot we want to add a piece to.
		UIButton *B = (UIButton *) [self.view viewWithTag: tag];
		
		NSString *piece = (([game currentPlayer] == PLAYER_LEFT) ? @"X" : @"O");
		UIImage *img = [UIImage imageNamed: [NSString stringWithFormat: @"C4%@.png", piece]];
		
		// Set up the piece image view
		double x = [B frame].origin.x;
		double y = [B frame].origin.y;
		double w = [B frame].size.width;
		double h = [B frame].size.height;
		UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(x, 10 - h/2.0, w, h)];
		[imgView setImage: img];
		imgView.tag = 1000 + tag;
		[self.view insertSubview: imgView atIndex: 0];
		
		for (int i = 0; i < width; i += 1)
			[self.view sendSubviewToBack: [self.view viewWithTag: 100 + i]];
		
		// Animate the piece
		[UIView beginAnimations: @"Drop" context: NULL];
		[imgView setFrame: CGRectMake(x, y, w, h)];
		[UIView commitAnimations];
	}
}


- (void) undoMove: (NSNumber *) move {
	int tag = [move integerValue];
	if (tag == 0) tag = width;
	tag += width * (height - 1);
	while (tag > 0) {
		if (![[[[game currentPosition] board] objectAtIndex: tag - 1] isEqual: @"+"])
			break;
		tag -= width;
	}
	UIImageView *imgView = (UIImageView *) [self.view viewWithTag: 1000 + tag];
	
	// Animate the piece out
	[UIView beginAnimations: @"Rise" context: NULL];
	[imgView setFrame: CGRectMake(imgView.frame.origin.x, -150, imgView.frame.size.width, imgView.frame.size.height)];
	[UIView commitAnimations];
	
	[imgView release];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		UITouch *aTouch = [touches anyObject];
		float tapX = [aTouch locationInView: self.view].x;
		UIImageView *V = (UIImageView *) [self.view viewWithTag: 1];
		double w = V.frame.size.width, h = V.frame.size.height;
		int col = (int) (tapX - (10 + width/2.0) ) / w;
		if (col >= width) col = width - 1;
		if (col < 0) col = 0;
		if (![[game generateMoves] containsObject: [NSString stringWithFormat: @"%d", col + 1]]) {
			int minOffset = width + 1;
			for (NSString *move in [game generateMoves]) {
				minOffset = abs(minOffset) < abs([move intValue] - 1 - col) ? minOffset : [move intValue] - 1 - col;
			}
			col += minOffset;
		}
		float newX = 10 + width/2.0 + col * (w - 1);
		if (newX >= 10 + width/2.0 - w/2.0 && newX <= 10 + width/2.0 + w/2.0 + (w - 1) * (width - 1) ) {
			UIImageView *pieceView = [[UIImageView alloc] initWithFrame: CGRectMake(newX, 10, w, h)];
			[pieceView setImage: [UIImage imageNamed: [NSString stringWithFormat: @"C4%@.png", (([game currentPlayer] == PLAYER_LEFT) ? @"X" : @"O")]]];
			pieceView.tag = 55555;
			[self.view insertSubview: pieceView atIndex: width];
		}
	}
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		UITouch *aTouch = [touches anyObject];
		float x = [aTouch locationInView: self.view].x;
		UIImageView *pieceView = (UIImageView *) [self.view viewWithTag: 55555];
		if (pieceView) {
			double w = pieceView.frame.size.width, h = pieceView.frame.size.height;
			int col = (int) (x - (10 + width/2.0) ) / w;
			if (col >= width) col = width - 1;
			if (col < 0) col = 0;
			float newX = 10 + width/2.0 + col * (w - 1);
			if ([[game generateMoves] containsObject: [NSString stringWithFormat: @"%d", col + 1]]) {
				[UIView beginAnimations: @"Slide" context: NULL];
				[pieceView setFrame: CGRectMake(newX, pieceView.frame.origin.y, w, h)];
				[UIView commitAnimations];
			}
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		UIImageView *V = (UIImageView *) [self.view viewWithTag: 1];
		NSString *move = nil;
		UIView *pieceView = [self.view viewWithTag: 55555];
		if (pieceView) {
			float x = pieceView.frame.origin.x + pieceView.frame.size.width/2.0;
			int col = (int) ((x - 10)/V.frame.size.width);
			if (0 <= col && col < width) {
				move = [NSString stringWithFormat: @"%d", col + 1];
			} else if (col >= width)
				move = [NSString stringWithFormat: @"%d", width];
			else
				move = @"1";
		}
		[[self.view viewWithTag: 55555] removeFromSuperview];
		if (move && [[game generateMoves] containsObject: move])
			[game postHumanMove: move];
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		if ([self.view viewWithTag: 55555])
			[[self.view viewWithTag: 55555] removeFromSuperview];
	}
}


- (void) stop {
	if (waiter)
		[waiter cancel];
	if (timer)
		[timer invalidate];
}


#pragma mark View controller delegate methods
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame: viewRect];
	self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
	
	float squareSize;
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		squareSize = MIN(300.0 / width, 356.0 / (height + 1));
	else
		squareSize = MIN(236.0 / (height + 1), 380.0 / width);
	
	UIImage *gridImg = [UIImage imageNamed: @"C4Grid.png"];
	int tagNum = 1;
	for (int j = height - 1; j >= 0; j -= 1) {
		for (int i = 0; i < width; i += 1) {
			UIImageView *B = [[UIImageView alloc] initWithFrame: CGRectMake((10 + width/2) + i * (squareSize - 1),
                                                                            10 + (j + 1) * (squareSize - 1), squareSize, squareSize)];
			[B setImage: gridImg];
			B.tag = tagNum;
			tagNum += 1;
			[self.view addSubview: B];
		}
	}
	
	UIImage *gridTop = [UIImage imageNamed: @"C4GridTopClear.png"];
	int lastTag = width * height;
	for (int i = lastTag - width + 1; i <= width * height; i += 1) {
		UIImageView *B = (UIImageView *) [self.view viewWithTag: i];
		[B setImage: gridTop];
	}
	
	for (int i = 0; i < width; i += 1) {
		UIView *B = [[UIView alloc] initWithFrame: CGRectMake((10 + width/2) + i * (squareSize - 1),
                                                              10 + squareSize / 2.0, squareSize, squareSize / 2.0)];
		B.tag = 100 + i;
		[B setBackgroundColor: [UIColor clearColor]];
		[self.view insertSubview: B atIndex: 0];
	}
	
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		message = [[UILabel alloc] initWithFrame: CGRectMake(20, 25 + (height + 0.5) * squareSize, 
                                                             280, 416 - (45 + height * squareSize))];
	else
		message = [[UILabel alloc] initWithFrame: CGRectMake(10 + width * squareSize, 3, 
                                                             480 - (10 + width * squareSize), 250)];
	message.backgroundColor = [UIColor clearColor];
	message.textColor = [UIColor whiteColor];
	message.textAlignment = UITextAlignmentCenter;
	message.text = @"";
	[self.view addSubview: message];
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = CGRectMake(width/2.0 * squareSize - 5 - width/2.0,
                               height/2.0  * squareSize + squareSize/2.0 - 10,  37.0, 37.0);
	[self.view addSubview: spinner];
	//[self disableButtons];
	
	[self updateLabels];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload {
    [super viewDidUnload];
	[message release];
	[spinner release];
	spinner = nil;
}


- (void) dealloc {
	if (spinner)
		[spinner release];
    [super dealloc];
}

@end
