//
//  GCOthelloViewController.m
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCOthelloViewController.h"
#import "GCOthelloView.h"

#define PADDING 1
#define BLANK @"+"

@implementation GCOthelloViewController

@synthesize touchesEnabled;

- (id) initWithGame: (GCOthello *) _game {
	if (self = [super init]) {
		game = _game;
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		spinner.frame = CGRectMake(self.view.bounds.size.width/2.0 - 18.5, self.view.bounds.size.height/2.0 + 33.0, 37.0, 37.0);
		[self.view addSubview: spinner];
	}
	return self;
}

- (void) updateServerDataWithService: (GCJSONService *) _service {
	service = _service;
	[spinner startAnimating];
	[self.view bringSubviewToFront: spinner];
	waiter = [[NSThread alloc] initWithTarget: self selector: @selector(fetchNewData:) object: [NSNumber numberWithBool:touchesEnabled]];
	[waiter start];
	timer = [[NSTimer scheduledTimerWithTimeInterval: 5 target: self selector: @selector(timedOut:) userInfo: nil repeats: NO] retain];
}

- (void) fetchNewData: (BOOL) buttonsOn {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//[self performSelectorOnMainThread: @selector(disableButtons) withObject: nil waitUntilDone: NO];
	NSString *boardString = [GCOthello stringForBoard: game.board];
    
	NSString *boardURL = [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    int player = !game.leftPlayerTurn + 1;
	NSString *boardVal = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/othello/getMoveValue;board=%@;player=%d;option=136", boardURL, player] retain];
	NSString *moveVals = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/othello/getNextMoveValues;board=%@;player=%d;option=136", boardURL, player] retain];
    NSLog(@"BoardString %@ Board URL %@ Move URLs %@", boardString, boardVal, moveVals);
	[service retrieveDataForBoard: boardString URL: boardVal andNextMovesURL: moveVals];
	
	[self performSelectorOnMainThread: @selector(fetchFinished:) withObject: [NSNumber numberWithBool: buttonsOn] waitUntilDone: NO];
	
	[pool release];
}


- (void) fetchFinished: (BOOL) buttonsOn {
	if (waiter != nil) {
		if (buttonsOn);
		[spinner stopAnimating];
		[timer invalidate];
	}
	if (![service connected] || ![service status])
		NSLog(@"Problem");
		//[game postProblem];
	else {
		
		[game postReady];
		[self updateLabels];
		[self updateLegalMoves];
	}
}


- (void) timedOut: (NSTimer *) theTimer {
    UILabel *textLabel = (UILabel *) [self.view viewWithTag:2000];
	textLabel.lineBreakMode = UILineBreakModeWordWrap;
	[textLabel setText: @"Server request timed out. Check the strength of your Internet connection."];
	
	[waiter cancel];
	[waiter release];
	waiter = nil;
	[spinner stopAnimating];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	if (touchesEnabled) {		
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
		
		CGFloat size = MIN((w - 2*PADDING)/game.cols, (h - 80+PADDING)/game.rows);
		
		UITouch *theTouch = [touches anyObject];
		CGPoint loc = [theTouch locationInView: self.view];
		
		if (CGRectContainsPoint(CGRectMake(PADDING, PADDING, size * game.cols, size * game.rows), loc)) {
			int col = (loc.x - PADDING) / size;
			int row = (loc.y - PADDING) / size;
			int pos = col + row*game.cols;
			NSArray *myFlips = [game getFlips:pos];
			NSLog(@"%d", [myFlips count]);

			if ([myFlips count] > 0 ){
				touchesEnabled = NO;
				[game userChoseMove:[NSNumber numberWithInt: col + row*game.cols]];
			}
		}
	}
}

- (void) gameWon: (int) leftPlayerWon {
    UILabel *textLabel = (UILabel *) [self.view viewWithTag:2000];
    if (leftPlayerWon == 1) {
        textLabel.text = @"Black Wins";
    } else if(leftPlayerWon == 0) {
        textLabel.text = @"White Wins";
    } else if(leftPlayerWon == 2) {
		textLabel.text = @"Tie Game";
	} else {
		NSLog(@"ERROR: Bad else in gameWon");
	}

}

- (void) updateLegalMoves {
    if ([game playMode] == ONLINE_SOLVED && game.moveValues) {
        for (int i=0; i<game.cols; i+=1) {
            for	(int j=0; j<game.rows; j+=1) {
                UIImageView *newView = (UIImageView *)[self.view viewWithTag:5000 + i + j*game.cols];
                [newView setHidden:YES];
            }
        }
        NSArray *generateMoves = [game generateMoves];
        if([generateMoves objectAtIndex: 0] != @"PASS") {
            for (NSNumber* move in generateMoves) {
                UIImageView *newView = (UIImageView *)[self.view viewWithTag:5000 + [move intValue]];
                UIImage *moveImage = [UIImage imageNamed: (game.leftPlayerTurn ? [[NSDictionary dictionaryWithObjectsAndKeys: @"othwin.png", @"win",
																		   @"othlose.png", @"lose", @"othtie.png", @"tie", nil] objectForKey: [game getValueOfMove: move]]
														   : [[NSDictionary dictionaryWithObjectsAndKeys: @"othwin.png", @"win",
															   @"othlose.png", @"lose", @"othtie.png", @"tie", nil] objectForKey: [game getValueOfMove: move]])];
                [newView setImage:moveImage];
                [newView setHidden:NO];
            }
        }
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay: 1.0];
        for (int i=0; i<game.cols; i+=1) {
            for	(int j=0; j<game.rows; j+=1) {
                UIImageView *newView = (UIImageView *)[self.view viewWithTag:5000 + i + j*game.cols];
                [newView setHidden:YES];
            }
        }
        NSArray *generateMoves = [game generateMoves];
        if([generateMoves objectAtIndex: 0] != @"PASS") {
            for (NSNumber* move in generateMoves) {
                UIImageView *newView = (UIImageView *)[self.view viewWithTag:5000 + [move intValue]];
                [newView setHidden:NO];
            }
        }
        [UIView commitAnimations];
    }
	
}

- (void) updateLabels {
    //display turn
    NSString *player = game.leftPlayerTurn ? [[game leftPlayer] name] : [[game rightPlayer] name];
    GameValue prim = [game primitive];
    UILabel *textLabel = (UILabel *) [self.view viewWithTag:2000];
    if (prim != nil) {
        if (prim == TIE) {
            textLabel.text = @"Tie Game";
			NSLog(@"HAPPENS1");
        } else if (prim == WIN) {
            if (game.leftPlayerTurn) {
                textLabel.text = [NSString stringWithFormat: @"Black, %@ wins!!", player];
            } else {
				textLabel.text = [NSString stringWithFormat: @"White, %@ wins!!", player];
            }
			NSLog(@"HAPPENS2");
            
        } else if (prim == LOSE) {
            if (game.leftPlayerTurn) {
                textLabel.text = [NSString stringWithFormat: @"White, %@ wins!!", player];
            } else {
                textLabel.text = [NSString stringWithFormat: @"Black, %@ wins!!", player];
            }
			NSLog(@"HAPPENS3");
        }
    } else {
        if ([game playMode] == ONLINE_SOLVED && game.predictions) {
            textLabel.text = [NSString stringWithFormat: @"%@ should %@",player,  [game getValue], [game getRemoteness]];
        } else {
            textLabel.text = [NSString stringWithFormat: @"%@", player];
        }
		NSLog(@"HAPPENS4");
    }
	
	UIImageView *image = (UIImageView *)[self.view viewWithTag:999];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:image cache:YES];
	[image setImage:[UIImage imageNamed: game.leftPlayerTurn ? @"othsimpleblack.png" : @"othsimplewhite.png"]];
	[UIView commitAnimations];
}

- (void) doMove:(NSNumber *)move {
	if([move intValue] != -1) {
		int col = [move intValue] % game.cols;
		int row = [move intValue] / game.cols;
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
		CGFloat size = MIN((w - 2*PADDING)/game.cols, (h - 80+PADDING)/game.rows);
		
		CGRect rect = CGRectMake( PADDING + col * size,  PADDING + row * size, size, size);
		NSArray *myFlips = [game getFlips:(col + row*game.cols)];
		UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.leftPlayerTurn ? @"othsimpleblack.png" : @"othsimplewhite.png"]];
		[piece setFrame: rect];
		piece.tag = 1000 + col + row*game.cols;
		[self.view addSubview: piece];
		for (NSNumber *flip in myFlips) {
			UIImageView *image = (UIImageView *) [self.view viewWithTag:1000 + [flip intValue]];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:1.0];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:image cache:YES];
			[image setImage:[UIImage imageNamed: game.leftPlayerTurn ? @"othsimpleblack.png" : @"othsimplewhite.png"]];
			[UIView commitAnimations];
		}
		
		//display # of pieces for each player
		UILabel *leftPlayerscore = (UILabel *)[self.view viewWithTag:899];
		UILabel *rightPlayerscore = (UILabel *)[self.view viewWithTag:799];
		[UIView beginAnimations:nil context:NULL];
		int leftPlayerPieces = game.leftPlayerPieces;
		int rightPlayerPieces = game.rightPlayerPieces; 
		int changedPieces = [myFlips count];
		if (game.leftPlayerTurn) {
			leftPlayerPieces += changedPieces + 1;
			rightPlayerPieces -= changedPieces;
		} else {
			rightPlayerPieces += changedPieces + 1;
			leftPlayerPieces -= changedPieces;
		}
		leftPlayerscore.text = [NSString stringWithFormat:@"%d", leftPlayerPieces ];
		rightPlayerscore.text = [NSString stringWithFormat:@"%d", rightPlayerPieces ];
		
		//update sliding bar
		UIImageView *blackbar = (UIImageView *)[self.view viewWithTag:10000];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[blackbar setFrame:CGRectMake(PADDING, PADDING + game.rows*size , (w - 2*PADDING)*leftPlayerPieces/(leftPlayerPieces + rightPlayerPieces), 10)];
		
		[UIView commitAnimations];
	} 
}

- (void) undoMove:(NSNumber *)move {
	NSArray *myOldMoves = game.myOldMoves;
	NSArray *myLastBoard = [[myOldMoves lastObject] objectAtIndex:0];
	for (int i = 0; i< game.rows*game.cols; i++) {
		if ([myLastBoard objectAtIndex: i] != [game.board objectAtIndex:i]) {
			if ([[myLastBoard objectAtIndex:i] isEqualToString:BLANK]) {
				UIImageView *image = (UIImageView *) [self.view viewWithTag:1000 + i];
				[image removeFromSuperview];
			} else {
				
				UIImageView *image = (UIImageView *) [self.view viewWithTag:1000 + i];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				[UIView setAnimationDuration:1.0];
				[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:image cache:YES];
				if ([move intValue] == -1) {
					[image setImage:[UIImage imageNamed: game.leftPlayerTurn ? @"othsimplewhite.png" : @"othsimpleblack.png"]];
				} else {
					[image setImage:[UIImage imageNamed: game.leftPlayerTurn ? @"othsimpleblack.png" : @"othsimplewhite.png"]];
				}
				[UIView commitAnimations];
			}
		}
	}
	
	
	//display # of pieces for each player
	UILabel *leftPlayerscore = (UILabel *) [self.view viewWithTag:899];
	UILabel *rightPlayerscore = (UILabel *)[self.view viewWithTag:799];
	[UIView beginAnimations:nil context:NULL];
	
	int leftPlayerPieces = [(NSNumber *) [[myOldMoves lastObject] objectAtIndex: 1] intValue];
	int rightPlayerPieces = [(NSNumber *) [[myOldMoves lastObject] objectAtIndex: 2] intValue];
	
	leftPlayerscore.text = [NSString stringWithFormat:@"%d", leftPlayerPieces] ;
	rightPlayerscore.text = [NSString stringWithFormat:@"%d", rightPlayerPieces];
	
	CGFloat w = self.view.bounds.size.width;
	CGFloat h = self.view.bounds.size.height;
	CGFloat size = MIN((w - 2*PADDING)/game.cols, (h - 80+PADDING)/game.rows);
	
	UIImageView *blackbar = (UIImageView *)[self.view viewWithTag:10000];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[blackbar setFrame:CGRectMake(PADDING, PADDING + game.rows*size , (w - 2*PADDING)*leftPlayerPieces/(leftPlayerPieces + rightPlayerPieces), 10)];
	
	[UIView commitAnimations];
	[UIView commitAnimations];
	
	
	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[GCOthelloView alloc] initWithFrame: CGRectMake(0, 0, 320, 416) andRows: game.rows andCols: game.cols];
	
	CGFloat w = self.view.bounds.size.width;
	CGFloat h = self.view.bounds.size.height;
	
	CGFloat size = MIN((w - PADDING*2)/game.cols, (h - (80+ PADDING))/game.rows);
	int col = game.cols/2 -1;
	int row = game.rows/2 -1;
	
	
	UIImageView *piece1 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"othsimpleblack.png"]];
	UIImageView *piece2 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"othsimplewhite.png"]];
	
	UIImageView *piece3 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"othsimplewhite.png"]];
	UIImageView *piece4 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"othsimpleblack.png"]];
	[piece1 setFrame: CGRectMake(PADDING + col * size, PADDING + row * size, size, size)];
	piece1.tag = 1000 + row*game.cols + col;
	[self.view addSubview: piece1];
	[piece2 setFrame: CGRectMake(PADDING	+ (col+1) * size, PADDING + row * size, size, size)];
	piece2.tag = 1000 + row*game.cols + col +1;
	[self.view addSubview: piece2];
	[piece3 setFrame: CGRectMake(PADDING	+ col * size, PADDING + (row +1) * size, size, size)];
	piece3.tag = 1000 + (row+1)*game.cols + col;
	[self.view addSubview: piece3];
	[piece4 setFrame: CGRectMake(PADDING	+ (col +1) * size, PADDING + (row+1) * size, size, size)];
	piece4.tag = 1000 + (row+1)*game.cols + col+1;
	[self.view addSubview: piece4];
    
	
	//Turn
	UIImageView *piecet = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"othsimpleblack.png"]];
	[piecet setFrame: CGRectMake((w- 50)/ 2.0, h - 20.0 - (60.0 / 2.0) - (50 / 2.0), 50, 50)];
	piecet.tag = 999;
	[self.view addSubview: piecet];
	
	UILabel *turnLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, h - 20.0 - (60.0 / 2.0) - (50 / 2.0) + 50/2 + 10 , w, 50)];
    turnLabel.textAlignment = UITextAlignmentCenter;
	turnLabel.text = @"Turn";
    turnLabel.tag = 2000;
	turnLabel.textColor = [UIColor whiteColor];
	turnLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:turnLabel];
	//Player Scores
	UIImageView *pieceblack = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"othsimpleblack.png"]];
	[pieceblack setFrame: CGRectMake(PADDING, h - 20.0 - (60.0 / 2.0) - (50 / 2.0), 50, 50)];
	[self.view addSubview:pieceblack];
	UILabel *leftPlayerscore = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, h-20.0-(60.0/2.0) - 50/2.0, 50, 50)];
	leftPlayerscore.tag = 899;
    leftPlayerscore.textAlignment = UITextAlignmentCenter;
	leftPlayerscore.backgroundColor = [UIColor clearColor];
	leftPlayerscore.textColor = [UIColor whiteColor];
	leftPlayerscore.text = [NSString stringWithFormat:@"%d", game.leftPlayerPieces];
	[self.view addSubview:leftPlayerscore];
	
	UIImageView *piecewhite = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"othsimplewhite.png"]];
	[piecewhite setFrame: CGRectMake(w - (2*PADDING) - 50, h - 20.0 - (60.0 / 2.0) - (50 / 2.0), 50, 50)];
	[self.view addSubview:piecewhite];
	UILabel *rightPlayerscore = [[UILabel alloc] initWithFrame:CGRectMake(w-PADDING-50, h-20.0-(60.0/2.0) - (50/2.0), 50, 50)];
	rightPlayerscore.tag = 799;
    rightPlayerscore.textAlignment = UITextAlignmentCenter;
	rightPlayerscore.backgroundColor = [UIColor clearColor];
	rightPlayerscore.textColor = [UIColor blackColor];
	rightPlayerscore.text = [NSString stringWithFormat:@"%d", game.rightPlayerPieces];
	[self.view addSubview:rightPlayerscore];
	
	// Legal Moves
	for (int i=0; i<game.cols; i+=1) {
		for	(int j=0; j<game.rows; j+=1) {
			UIImageView *newView = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING + i*size + size/3, PADDING + j*size + size/3, size/3, size/3)];
			newView.tag = 5000 + i + j*game.cols;
			[newView setImage:[UIImage imageNamed:@"othrec.png"]];
			[newView setHidden: YES];
			[self.view addSubview:newView];
		}
	}

	// Sliding Bar
	UIImageView *whitebar = [[UIImageView alloc] initWithFrame: CGRectMake(PADDING, PADDING + game.rows*size , w - 2*PADDING, 10)];
	[whitebar setImage:[UIImage imageNamed:@"othwhitebar.png"]];
	[self.view addSubview:whitebar];
	
	UIImageView *blackbar = [[UIImageView alloc] initWithFrame: CGRectMake(PADDING, PADDING + game.rows*size , (w - 2*PADDING)/2, 10)];
	[blackbar setImage:[UIImage imageNamed:@"othblackbar.png"]];
	blackbar.tag = 10000;
	[self.view addSubview:blackbar];
	
	[self updateLabels];
    [self updateLegalMoves];
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
	[spinner release];
	spinner = nil;
    [super dealloc];
}


@end
