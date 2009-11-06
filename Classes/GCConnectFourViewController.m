//
//  GCConnectFourViewController.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/3/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCConnectFourViewController.h"
#import "UIImageResizing.h"


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
- (id) initWithWidth: (NSInteger) _width height: (NSInteger) _height pieces: (NSInteger) _pieces {
	if (self = [super init]) {
		width  = _width;
		height = _height;
		pieces = _pieces;
		board = [[NSMutableArray alloc] initWithCapacity: width * height];
		for (int i = 0; i < width * height; i += 1)
			[board addObject: @" "];
		turn = YES;
		service = [[GCConnectFourService alloc] init];
		showPredictions = YES;
		showMoveValues  = YES;
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
		CGSize squareSize = B.bounds.size;
		squareSize.width += 1;
		squareSize.height += 1;
		if (tag < width * height + 1) {
			NSString *piece;
			if (turn) {
				piece = @"X";
				[B setImage: [[UIImage imageNamed: @"gridX.png"] scaleToSize: squareSize] forState: UIControlStateNormal];
			} else {
				piece = @"O";
				[B setImage: [[UIImage imageNamed: @"gridO.png"] scaleToSize: squareSize] forState: UIControlStateNormal];
			}
			[B setTitle: piece forState: UIControlStateNormal];
			turn = !turn;
			[board replaceObjectAtIndex: tag - 1 withObject: piece];
		}
		
		[service retrieveDataForBoard: board width: width height: height pieces: pieces];
		[self updateLabels];
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
		
		descLabel.numberOfLines = 2;
		if (showPredictions)
			descLabel.text = [NSString stringWithFormat: @"%@'s turn\n%@ in %d", (turn ? @"Red" : @"Black"), value, remoteness];
		else
			descLabel.text = [NSString stringWithFormat: @"%@'s turn\n", (turn ? @"Red" : @"Black")];
		
		for (int i = 0; i < width; i += 1) {
			UIButton *column = (UIButton *) [colHeads objectAtIndex: i];
			NSString *currentValue = [service getValueAfterMove: [NSString stringWithFormat: @"%d", i]];
			CGSize squareSize = column.bounds.size;
			squareSize.width += 1;
			squareSize.height += 1;
			if (!showMoveValues) {
				if ([column.titleLabel.text isEqualToString: @"+"])
					[column setImage: [[UIImage imageNamed: @"gridTopClear.png"] scaleToSize: squareSize] 
							forState: UIControlStateNormal];
			} else if (currentValue == nil) {
				if ([column.titleLabel.text isEqualToString: @"+"])
					[column setImage: [[UIImage imageNamed: @"gridTopClear.png"] scaleToSize: squareSize] 
							forState: UIControlStateNormal];
			} else {
				if ([currentValue isEqualToString: @"win"])
					[column setImage: [[UIImage imageNamed: @"gridTopGreen.png"] scaleToSize: squareSize] 
							forState: UIControlStateNormal];
				else if ([currentValue isEqualToString: @"lose"])
					[column setImage: [[UIImage imageNamed: @"gridTopRed.png"] scaleToSize: squareSize] 
							forState: UIControlStateNormal];
				else
					[column setImage: [[UIImage imageNamed: @"gridTopYellow.png"] scaleToSize: squareSize] 
							forState: UIControlStateNormal];
			}
		}
		if (remoteness == 0) {
			[self disableButtons];
			descLabel.numberOfLines = 1;
			NSString *winner;
			if ([value isEqualToString: @"tie"])
				descLabel.text = @"It's a tie!";
			else {
				if ([value isEqualToString: @"win"])
					winner = turn ? @"Red" : @"Black";
				else
					winner = turn ? @"Black" : @"Red";
				descLabel.text = [NSString stringWithFormat: @"%@ wins!", winner];
			}
		}
	} else {
		descLabel.numberOfLines = 2;
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
	for (int i = 0; i < width; i += 1) {
		UIButton *column = (UIButton *) [colHeads objectAtIndex: i];
		if (column.titleLabel.text == @"+") {
			CGSize squareSize = column.bounds.size;
			squareSize.width += 1;
			squareSize.height += 1;
			[column setImage: [[UIImage imageNamed: @"gridTopClear.png"] scaleToSize: squareSize] forState: UIControlStateNormal];
		}
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
	self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 416)];
	self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
	
	float squareSize = MIN(280.0 / width, 376.0 / height);
	
	int tagNum = 1;
	for (int j = height - 1; j >= 0; j -= 1) {
		for (int i = 0; i < width; i += 1) {
			UIButton *B = [[UIButton buttonWithType: UIButtonTypeCustom] 
						   initWithFrame: CGRectMake(20 + i * squareSize, 20 + j * squareSize, squareSize, squareSize)];
			UIImage *gridImg = [UIImage imageNamed: @"grid.png"];
			UIImage *resized = [gridImg scaleToSize: CGSizeMake(squareSize + 1, squareSize + 1)];
			[B setTitle: @"+" forState: UIControlStateNormal];
			[B setImage: resized forState: UIControlStateNormal];
			[B addTarget: self action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
			B.adjustsImageWhenDisabled = NO;
			B.tag = tagNum;
			tagNum += 1;
			[self.view addSubview: B];
		}
	}
	
	descLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 40 + height * squareSize, 
																	280, 416 - (60 + height * squareSize))];
	descLabel.backgroundColor = [UIColor clearColor];
	descLabel.textColor = [UIColor whiteColor];
	descLabel.textAlignment = UITextAlignmentCenter;
	descLabel.text = @"Label";
	[self.view addSubview: descLabel];
	
	int lastTag = width * height;
	NSMutableArray *tops = [[NSMutableArray alloc] init];
	for (int i = lastTag - width + 1; i <= lastTag; i += 1) {
		[tops addObject: [self.view viewWithTag: i]];
	}
	colHeads = [[NSArray alloc] initWithArray: tops];
	[tops release];
	
	[service retrieveDataForBoard: board width: width height: height pieces: pieces];
	[self updateLabels];
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
	[colHeads release];
}


- (void)dealloc {
	[board release];
	[service release];
    [super dealloc];
}


@end
