//
//  GCConnectFourViewController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectFourViewController.h"


@implementation GCConnectFourViewController

@synthesize touchesEnabled;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/**
 The designated initializer.
 
 @param _width the number of columns
 @param _height the number of rows
 @param _pieces the number in a row needed to win
 */
- (id) initWithGame: (GCConnectFour *) _game {
	if (self = [super init]) {
		width  = _game.width;
		height = _game.height;
		pieces = _game.pieces;
		game = _game;
		
		touchesEnabled = NO;
		
		self.view.multipleTouchEnabled = NO;
		
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	}
	return self;
}

#pragma mark Custom class methods
- (void) tapped: (UIButton *) sender {
	int col = sender.tag % width;
	if (col == 0) col = width;
	NSString *move = [NSString stringWithFormat: @"%d", col];
	
	if ([[game legalMoves] containsObject: move])
		[game postHumanMove: move];
}

- (void) updateServerDataWithService: (GCJSONService *) _service {
	service = _service;
	[spinner startAnimating];
	waiter = [[NSThread alloc] initWithTarget: self selector: @selector(fetchNewData:) object: [NSNumber numberWithBool:touchesEnabled]];
	[waiter start];
	timer = [[NSTimer scheduledTimerWithTimeInterval: 60 target: self selector: @selector(timedOut:) userInfo: nil repeats: NO] retain];
}

- (void) fetchNewData: (BOOL) buttonsOn {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//[self performSelectorOnMainThread: @selector(disableButtons) withObject: nil waitUntilDone: NO];
	NSString *boardString = [GCConnectFour stringForBoard: game.board];
	NSString *boardURL = [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	NSString *boardVal = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/connect4/getMoveValue;width=%d;height=%d;pieces=%d;board=%@", width, height, pieces, boardURL] retain];
	NSString *moveVals = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/connect4/getNextMoveValues;width=%d;height=%d;pieces=%d;board=%@", width, height, pieces, boardURL] retain];
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
	[self updateLabels];
	if (![service connected] || ![service status])
		[game postProblem];
	else {
		[game postReady];
	}
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
	NSString *player = ([game currentPlayer] == PLAYER1) ? [game player1Name] : [game player2Name];
	NSString *color = ([game currentPlayer] == PLAYER1) ? @"Red" : @"Blue";
	PlayerType typePlay = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
	PlayerType typeOpp  = ([game currentPlayer] == PLAYER1) ? [game player2Type] : [game player1Type];
	message.numberOfLines = 4;
	message.lineBreakMode = UILineBreakModeWordWrap;
	if ([game predictions]) {
		NSString *value = [service getValue];
		int remoteness  = [service getRemoteness];
		if (value != nil && remoteness != -1) {
			NSString *modifier;
			if (typePlay == COMPUTER_PERFECT && value == @"win") modifier = @"will";
			else if (typeOpp == COMPUTER_PERFECT && value == @"lose") modifier = @"will";
			else if (typePlay == COMPUTER_PERFECT && typeOpp == COMPUTER_PERFECT) modifier = @"will";
			else modifier = @"should";
			[message setText: [NSString stringWithFormat: @"%@ (%@)\n%@ %@ in %d", player, color, modifier, 
							   value, remoteness]];
		} else if (value != nil) {
			NSString *modifier;
			if (typePlay == COMPUTER_PERFECT && value == @"win") modifier = @"will";
			else if (typeOpp == COMPUTER_PERFECT && value == @"lose") modifier = @"will";
			else if (typePlay == COMPUTER_PERFECT && typeOpp == COMPUTER_PERFECT) modifier = @"will";
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
			NSString *currentValue = [service getValueAfterMove: [NSString stringWithFormat: @"%d", i]];
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
	}
	
	if (game.gameMode == ONLINE_SOLVED) {
		if (![service status])
			[message setText: @"Server error. Please try again later"];
		if (![service connected])
			[message setText: @"Server connection failed. Please check your Web connection"];
	}
	
	if ([game primitive: [game getBoard]])
		[self displayPrimitive];
}


- (void) displayPrimitive {
	NSString *value = [game primitive: game.board];
	NSString *winner;
	NSString *color;
	if ([value isEqualToString: @"TIE"])
		message.text = @"It's a tie!";
	else {
		if ([value isEqualToString: @"WIN"]) {
			winner = game.p1Turn ? game.player1Name : game.player2Name;
			color  = game.p1Turn ? @"Red" : @"Blue";
		} else {
			winner = game.p1Turn ? game.player2Name : game.player1Name;
			color  = game.p1Turn ? @"Blue" : @"Red";
		}
		message.text = [NSString stringWithFormat: @"%@ (%@) wins!", winner, color];
	}
}


- (void) doMove: (NSString *) move {
	int col = [move integerValue];
	if (col == 0) col = width;
	if ([[game legalMoves] containsObject: move]) {		
		// Update the view. Perform the animation
		int tag = col;
		while (tag < width * height + 1) {
			if ([[[game board] objectAtIndex: tag - 1] isEqual: @"+"])
				break;
			tag += width;
		}
		
		// Now TAG is the tag of the slot we want to add a piece to.
		UIButton *B = (UIButton *) [self.view viewWithTag: tag];
		
		NSString *piece = (game.p1Turn ? @"X" : @"O");
		UIImage *img = [UIImage imageNamed: [NSString stringWithFormat: @"C4%@.png", piece]];
		
		// Set up the piece image view
		double x = [B frame].origin.x;
		double y = [B frame].origin.y;
		double w = [B frame].size.width;
		double h = [B frame].size.height;
		UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(x, 10 - h/2.0, w, h)];
		[imgView setImage: img];
		imgView.tag = 1234;
		[self.view insertSubview: imgView atIndex: 0];
		
		for (int i = 0; i < width; i += 1)
			[self.view sendSubviewToBack: [self.view viewWithTag: 100 + i]];
		
		// Animate the piece
		[UIView beginAnimations: @"Drop" context: NULL];
		[imgView setFrame: CGRectMake(x, y, w, h)];
		[UIView commitAnimations];
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		UITouch *aTouch = [touches anyObject];
		float tapX = [aTouch locationInView: self.view].x;
		UIImageView *V = (UIImageView *) [self.view viewWithTag: 1];
		double w = V.frame.size.width, h = V.frame.size.height;
		UIImageView *pieceView = [[UIImageView alloc] initWithFrame: CGRectMake(tapX - w/2.0, 10 - h/2.0, w, h)];
		[pieceView setImage: [UIImage imageNamed: [NSString stringWithFormat: @"C4%@.png", (game.p1Turn ? @"X" : @"O")]]];
		pieceView.tag = 55555;
		[self.view insertSubview: pieceView atIndex: width];
	}
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		UITouch *aTouch = [touches anyObject];
		float x = [aTouch locationInView: self.view].x;
		UIImageView *pieceView = (UIImageView *) [self.view viewWithTag: 55555];
		double w = pieceView.frame.size.width, h = pieceView.frame.size.height;
		[UIView beginAnimations: @"Slide" context: NULL];
		int newX = x - w/2.0;
		if (newX > 10 + width/2.0 + (w - 1) * (width - 1) )
			newX = 10 + width/2.0 + (w - 1) * (width - 1);
		if (newX < 10 + width/2.0)
			newX = 10 + width/2.0;
		[pieceView setFrame: CGRectMake(newX, pieceView.frame.origin.y, w, h)];
		[UIView commitAnimations];
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
		UITouch *aTouch = [touches anyObject];
		float x = [aTouch locationInView: self.view].x;
		UIImageView *V = (UIImageView *) [self.view viewWithTag: 1];
		int col = (int) ((x - 10)/V.frame.size.width);
		NSString *move = nil;
		if (0 <= col && col < width) {
			move = [NSString stringWithFormat: @"%d", col + 1];
		} else {
			UIView *pieceView = [self.view viewWithTag: 55555];
			if (pieceView != nil) {
				if (col >= width)
					move = [NSString stringWithFormat: @"%d", width];
				else if (col < 0)
					move = @"1";
			}
		}
		[[self.view viewWithTag: 55555] removeFromSuperview];
		if (move && [[game legalMoves] containsObject: move])
			[game postHumanMove: move];
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {
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
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 416)];
	else
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 256)];
	
	self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
	
	float squareSize;
	// Come back to this bit later after I figure out how tall the top
	// Row will be to make the move value bigger
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		squareSize = MIN(300.0 / width, 356.0 / (height + 0.5));
	else
		squareSize = MIN(236.0 / (height + 0.5), 380.0 / width);
	
	UIImage *gridImg = [UIImage imageNamed: @"C4Grid.png"];
	int tagNum = 1;
	for (int j = height - 1; j >= 0; j -= 1) {
		for (int i = 0; i < width; i += 1) {
			UIImageView *B = [[UIImageView alloc] initWithFrame: CGRectMake((10 + width/2) + i * (squareSize - 1), squareSize / 2.0 + 10 + j * (squareSize - 1), squareSize, squareSize)];
			[B setImage: gridImg];
			//[B addTarget: self action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
			//B.adjustsImageWhenDisabled = NO;
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
		UIView *B = [[UIView alloc] initWithFrame: CGRectMake((10 + width/2) + i * (squareSize - 1), 10, squareSize, squareSize / 2.0)];
		B.tag = 100 + i;
		[B setBackgroundColor: [UIColor clearColor]];
		[self.view insertSubview: B atIndex: 0];
	}
	
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		message = [[UILabel alloc] initWithFrame: CGRectMake(20, 25 + height * squareSize, 
															   280, 416 - (35 + height * squareSize))];
	else
		message = [[UILabel alloc] initWithFrame: CGRectMake(10 + width * squareSize, 3, 
															   480 - (10 + width * squareSize), 250)];
	message.backgroundColor = [UIColor clearColor];
	message.textColor = [UIColor whiteColor];
	message.textAlignment = UITextAlignmentCenter;
	message.text = @"";
	[self.view addSubview: message];
	
	[spinner setFrame: CGRectMake(width/2.0 * squareSize, height/2.0  * squareSize,  37, 37)];
	[self.view addSubview: spinner];
	
	//[self disableButtons];
	
	[self updateLabels];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
	if (width > 5)
		return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
				interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
}


- (void) dealloc {
	[spinner release];
    [super dealloc];
}


@end
