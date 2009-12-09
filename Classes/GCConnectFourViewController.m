//
//  GCConnectFourViewController.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/3/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCConnectFourViewController.h"


@implementation GCConnectFourViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
- (id) initWithWidth: (NSInteger) _width height: (NSInteger) _height pieces: (NSInteger) _pieces 
		 player1Name: (NSString *) player1Name player2Name: (NSString *) player2Name {
	if (self = [super init]) {
		width  = _width;
		height = _height;
		pieces = _pieces;
		board = [[NSMutableArray alloc] initWithCapacity: width * height];
		for (int i = 0; i < width * height; i += 1)
			[board addObject: @" "];
		turn = YES;
		service = [[GCConnectFourService alloc] init];
		showPredictions = NO;
		showMoveValues  = NO;
		p1Name = player1Name;
		p2Name = player2Name;
		p1Human = YES;
		p2Human = YES;
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	}
	return self;
}


/** 
 Called when the option panel is dismissed and the play options are changed.
 Updates the view to reflect the new option values.
 
 @param options a dictionary with option names as keys and option values as values 
 */
- (void) updateDisplayOptions: (NSDictionary *) options {
	showPredictions = [[options objectForKey: @"predictions"] boolValue];
	showMoveValues  = [[options objectForKey: @"movevalues"] boolValue];
	[self updateLabels];
}


/** 
 Receiver of button taps. Determines the column the user tapped, adds a piece
 there (unless the column is full), fetches new data from the server, and
 updates the view. 
 
 @param sender the button that was tapped
 */
- (void) tapped: (UIButton *) sender {
	int tag = sender.tag % width;
	if (tag == 0) tag = width;
	while (tag < width * height + 1) {
		UIButton *B = (UIButton *) [self.view viewWithTag: tag];
		if ([B.titleLabel.text isEqualToString: @"+"])
			break;
		tag += width;
	}
	
	if (tag <= width * height) {
		UIButton *B = (UIButton *) [self.view viewWithTag: tag];
		if (tag < width * height + 1) {
			NSString *piece;
			if (turn)
				piece = @"X";
			else
				piece = @"O";
			
			UIImage *img = [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", piece]];
			double x = [B frame].origin.x;
			double y = [B frame].origin.y;
			double w = [B frame].size.width;
			double h = [B frame].size.height;
			UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(x, -30, w, h)];
			[imgView setImage: img];
			imgView.tag = 1234;
			[self.view insertSubview: imgView atIndex: 0];
			
			[UIView beginAnimations: @"Drop" context: NULL];
			[imgView setFrame: CGRectMake(x, y, w, h)];
			[UIView commitAnimations];
			
			[B setTitle: piece forState: UIControlStateNormal];
			turn = !turn;
			[board replaceObjectAtIndex: tag - 1 withObject: piece];
		}
		
		[self disableButtons];
		[spinner startAnimating];
		fetch = [[NSThread alloc] initWithTarget: self selector: @selector(fetchNewData) object: nil];
		[fetch start];
		timer = [NSTimer scheduledTimerWithTimeInterval: 30 target: self selector: @selector(timedOut:) userInfo: nil repeats: NO];
	}
}


- (void) fetchNewData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[service retrieveDataForBoard: board width: width height: height pieces: pieces];
	[self performSelectorOnMainThread: @selector(fetchFinished) withObject: nil waitUntilDone: NO];
	[pool release];
}


- (void) fetchFinished {
	if (fetch != nil) {
		[self enableButtons];
		[spinner stopAnimating];
		[timer invalidate];
		[self updateLabels];
	}
}


- (void) timedOut: (NSTimer *) theTimer {
	NSLog(@"Timed out");
	[fetch cancel];
	[fetch release];
	fetch = nil;
	[spinner stopAnimating];
	
	descLabel.numberOfLines = 4;
	descLabel.lineBreakMode = UILineBreakModeWordWrap;
	descLabel.text = @"Server request timed out. Check the strength of your Internet connection.";
}


- (void) redrawBoard {
	for (UIView *V in [self.view subviews]) {
		if (V.tag == 1234)
			[V removeFromSuperview];
	}
	
	for (int i = 1; i <= width * height; i += 1) {
		UIButton *B = (UIButton *) [self.view viewWithTag: i];
		NSString *piece = (NSString *) [board objectAtIndex: i - 1];
		if ([piece isEqualToString: @" "])
			piece = @"+";
		[B setTitle: piece forState: UIControlStateNormal];
		
		UIImage *img = [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", piece]];
		double x = [B frame].origin.x;
		double y = [B frame].origin.y;
		double w = [B frame].size.width;
		double h = [B frame].size.height;
		UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(x, y, w, h)];
		[imgView setImage: img];
		imgView.tag = 1234;
		[self.view insertSubview: imgView atIndex: 0];
		
	}
}


/**
 Updates the message label and re-colors the top row based on the current board status.
 If the game is over or the server is not producing a correct response (because of a 
 broken Internet connection or a bad response), disables all of the buttons. 
 */
- (void) updateLabels {
	if ([service connected] && [service status]) {
		NSString *value = [service getValue];
		int remoteness = [service getRemoteness];
		
		descLabel.numberOfLines = 4;
		descLabel.lineBreakMode = UILineBreakModeWordWrap;
		if (showPredictions) {
			if (value == nil || remoteness == -1) {
				descLabel.text = [NSString stringWithFormat: @"%@'s turn (%@)\nPrediction unavailable", (turn ? p1Name : p2Name), (turn ? @"Red" : @"Black")];
			} else {
				BOOL human = (turn ? p1Human : p2Human);
				descLabel.text = [NSString stringWithFormat: @"%@ (%@)\n%@ %@ in %d", 
								  (turn ? p1Name : p2Name), (turn ? @"Red" : @"Black"),
								  (human ? @"should" : @"will"), value, remoteness];
			}
		} else
			descLabel.text = [NSString stringWithFormat: @"%@'s turn (%@)\n", (turn ? p1Name : p2Name), (turn ? @"Red" : @"Black")];
		
		for (int i = 0; i < width; i += 1) {
			UIButton *column = (UIButton *) [colHeads objectAtIndex: i];
			NSString *currentValue = [service getValueAfterMove: [NSString stringWithFormat: @"%d", i]];
			if (!showMoveValues) {
				if ([column.titleLabel.text isEqualToString: @"+"])
					[column setBackgroundImage: [UIImage imageNamed: @"gridTopClear.png"] 
									  forState: UIControlStateNormal];
			} else if (currentValue == nil) {
				[column setBackgroundImage: [UIImage imageNamed: @"gridTopClear.png"]
								  forState: UIControlStateNormal];
			} else if ([currentValue isEqualToString: @"win"]) {
				[column setBackgroundImage: [UIImage imageNamed: @"gridTopGreen.png"]
								  forState: UIControlStateNormal];
			} else if ([currentValue isEqualToString: @"lose"]) {
				[column setBackgroundImage: [UIImage imageNamed: @"gridTopRed.png"]
								  forState: UIControlStateNormal];
			} else if ([currentValue isEqualToString: @"tie"] || [currentValue isEqualToString: @"draw"]) {
				[column setBackgroundImage: [UIImage imageNamed: @"gridTopYellow.png"]
								  forState: UIControlStateNormal];
			} else {
				[column setBackgroundImage: [UIImage imageNamed: @"gridTopClear.png"]
								  forState: UIControlStateNormal];
			}
		}
		if (remoteness == 0) {
			[self disableButtons];
			descLabel.numberOfLines = 1;
			NSString *winner;
			if ([value isEqualToString: @"tie"] || [value isEqualToString: @"draw"])
				descLabel.text = @"It's a tie!";
			else {
				if ([value isEqualToString: @"win"])
					winner = turn ? p1Name : p2Name;
				else
					winner = turn ? p2Name : p1Name;
				descLabel.text = [NSString stringWithFormat: @"%@ wins!", winner];
			}
		}
	} else {
		descLabel.numberOfLines = 4;
		descLabel.lineBreakMode = UILineBreakModeWordWrap;
		if (![service status])
			descLabel.text = @"Server error.\nPlease try again later";
		if (![service connected])
			descLabel.text = @"Server connection failed.\nPlease check your Web connection";
		[self disableButtons];
	}
}


/** Convenience method for disabling all of the board's buttons. */
- (void) disableButtons {
	for (int i = 1; i < width * height + 1; i += 1) {
		UIButton *B = (UIButton *) [self.view viewWithTag: i];
		[B setEnabled: NO];
	}
}


/** Convenience method for enabling all of the board's buttons. */
- (void) enableButtons {
	for (int i = 1; i < width * height + 1; i += 1) {
		UIButton *B = (UIButton *) [self.view viewWithTag: i];
		[B setEnabled: YES];
	}
}


/**
 Convenience method for getting a UIColor based on a game value (win, lose, tie/draw). 
 
 @param value a game value ("win", "lose", "tie", or "draw")
 @return the corresponding UIColor
 */
- (UIColor *) colorForValue: (NSString *) value {
	if ([value isEqualToString: @"win"])
		return [UIColor greenColor];
	if ([value isEqualToString: @"lose"])
		return [UIColor colorWithRed: 139.0 / 256.0 green: 0 blue: 0 alpha: 1];
	return [UIColor yellowColor];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

}*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 416)];
	else
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 256)];
	self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
	
	float squareSize;
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		squareSize = MIN(280.0 / width, 336.0 / height);
	else
		squareSize = MIN(216.0 / height, 360.0 / width);
	
	int tagNum = 1;
	for (int j = height - 1; j >= 0; j -= 1) {
		for (int i = 0; i < width; i += 1) {
			UIButton *B = [[UIButton buttonWithType: UIButtonTypeCustom] 
						   initWithFrame: CGRectMake((20 + width/2) + i * (squareSize - 1), 20 + j * (squareSize - 1), squareSize, squareSize)];
			UIImage *gridImg = [UIImage imageNamed: @"grid.png"];
			B.titleLabel.alpha = 0;
			[B setTitle: @"+" forState: UIControlStateNormal];
			[B setBackgroundImage: gridImg forState: UIControlStateNormal];
			[B addTarget: self action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
			B.adjustsImageWhenDisabled = NO;
			B.tag = tagNum;
			tagNum += 1;
			[self.view addSubview: B];
		}
	}
	
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		descLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 25 + height * squareSize, 
															   280, 416 - (35 + height * squareSize))];
	else
		descLabel = [[UILabel alloc] initWithFrame: CGRectMake(10 + width * squareSize, 3, 
															   480 - (10 + width * squareSize), 250)];
	descLabel.backgroundColor = [UIColor clearColor];
	descLabel.textColor = [UIColor whiteColor];
	descLabel.textAlignment = UITextAlignmentCenter;
	descLabel.text = @"";
	[self.view addSubview: descLabel];
	
	int lastTag = width * height;
	NSMutableArray *tops = [[NSMutableArray alloc] init];
	for (int i = lastTag - width + 1; i <= lastTag; i += 1) {
		[tops addObject: [self.view viewWithTag: i]];
	}
	colHeads = [[NSArray alloc] initWithArray: tops];
	[tops release];
	
	for (int i = 0; i < width; i += 1) {
		UIButton *column = (UIButton *) [colHeads objectAtIndex: i];
		if ([column.titleLabel.text isEqualToString: @"+"])
			[column setBackgroundImage: [UIImage imageNamed: @"gridTopClear.png"] 
							  forState: UIControlStateNormal];
	}
	
	[spinner setFrame: CGRectMake(width/2.0 * squareSize, height/2.0  * squareSize,  37, 37)];
	[self.view addSubview: spinner];
	
	[self disableButtons];
	[spinner startAnimating];
	fetch = [[NSThread alloc] initWithTarget: self selector: @selector(fetchNewData) object: nil];
	[fetch start];
	timer = [NSTimer scheduledTimerWithTimeInterval: 45 target: self selector: @selector(timedOut:) userInfo: nil repeats: NO];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (width > 5)
		return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[colHeads release];
}


- (void)dealloc {
	for (UIView *view in [self.view subviews]) {
		if (view.tag == 1234) {
			[view removeFromSuperview];
			[view release];
		}
	}
	[board release];
	[service release];
	[spinner release];
    [super dealloc];
}


@end
