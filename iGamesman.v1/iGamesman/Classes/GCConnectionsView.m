//
//  GCConnectionsView.m
//  iGamesman
//
//  Created by Ian Ackerman on 11/21/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCConnectionsView.h"

#import "GCPlayer.h"
#import "GCConnectionsPosition.h"

#define X @"X"
#define O @"O"
#define XCON @"x"
#define OCON @"o"
#define BLANK @"+"

@implementation GCConnectionsView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		acceptingTouches = NO;
		
		CGRect boardFrame = CGRectMake(frame.size.width - frame.size.height,
									   0, frame.size.height, frame.size.height);
		_board = [[UIView alloc] initWithFrame:boardFrame];
		[self addSubview:_board];
		///////// old stuff
		/*
		size = 7; //Get from model
		float squareSize = frame.size.height * (0.9375) / size;
		
		//NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConO" 
		//													 ofType:@"png"];

		//////Setting up the Squares as buttons
		int tag = 1;

		for (int j = 0; j < size; j += 1) {
			for (int i = 0; i < size; i += 1) {
				float x = i * squareSize;
				float y = j * squareSize;
				
				if (i % 2 == j % 2) {
					if ( (i != 0 || j != 0) && (i != 0 || j != size-1) && (i != size-1 || j != 0)
						&& (i != size-1 || j != size-1) ) {
						UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
						[button setFrame:	CGRectMake(10 + x, 10 + y, squareSize,  squareSize)];
						button.tag = tag;													
						[button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
						button.adjustsImageWhenDisabled = NO;
						[_board addSubview: button];
					}
				} else if (i % 2 == 0) {
					UIImageView *_O = [[UIImageView alloc] initWithFrame: CGRectMake(5 + x, 5 + y, 
																					 squareSize, 
																					 squareSize)];
					[_O setImage: [UIImage imageNamed: @"ConO.png"]];
					[_board addSubview: _O];
				} else {
					UIImageView *_X = [[UIImageView alloc] initWithFrame: CGRectMake(5 + x, 5 + y, 
																					 squareSize, 
																					 squareSize)];
					[_X setImage: [UIImage imageNamed: @"ConX.png"]];
					[_board addSubview: _X];
				}
				tag += 1;
			}
		}
		 */
		message = [[UILabel alloc] initWithFrame: CGRectMake(0, frame.size.height* 2 / 5, 
															 120, 50)]; //Scale for ipad
		message.backgroundColor = [UIColor clearColor];
		message.textColor = [UIColor whiteColor];
		message.textAlignment = UITextAlignmentCenter;
		message.lineBreakMode = UILineBreakModeWordWrap;
		message.numberOfLines = 0;
		message.text = @"Testing Long Message";
		[self addSubview: message];	
		
		_board.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    }
    return self;
}

- (void) startReceivingTouches
{
    acceptingTouches = YES;
}

- (void) stopReceivingTouches
{
    acceptingTouches = NO;
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
	if (!acceptingTouches)
        return;
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    GCConnectionsPosition *position = [delegate currentPosition];
	int size = position.size;
    float squareSize = self.frame.size.height * (0.9375) / size;
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			float x = i * squareSize;
			float y = j * squareSize;
			if (i % 2 == j % 2) {
				if ( (i != 0 || j != 0) && (i != 0 || j != size-1) && (i != size-1 || j != 0)
					&& (i != size-1 || j != size-1) ) {
					//Player specific checking of sides
					if (position.leftTurn && i == 0 || position.leftTurn && i == size - 1)
						continue;
					if (!position.leftTurn && j == 0 || !position.leftTurn && j == size - 1)
						continue;

					//Fix scaling
					CGRect cellRect = CGRectMake(_board.frame.origin.x + 10 + x, _board.frame. origin.y + 10 + y,
												 squareSize,  squareSize);
					if (CGRectContainsPoint(cellRect, location))
					{
						NSNumber *slotNumber = [NSNumber numberWithInt: i + j * size + 1];
						if ([[position.board objectAtIndex: i + j * size] isEqual: BLANK]) {
							[delegate userChoseMove: slotNumber];
						}
					}
				}
			}
		}
	}
}

- (void) drawRect: (CGRect) rect
{
	//Optimize to not remove old grid (and to not draw each time)
	NSArray* oldViews = _board.subviews;
	for (UIView* section in oldViews)
		[section removeFromSuperview];
	GCConnectionsPosition *position = [delegate currentPosition];
	NSString *player, *otherPlayer;
	NSString *color, *otherColor;
	if (position.leftTurn) {
		player = [[delegate leftPlayer] name];
		color = @"Red";
		otherPlayer = [[delegate rightPlayer] name];
		otherColor = @"Blue";
	} else {
		player = [[delegate rightPlayer] name];
		color = @"Blue";
		otherPlayer = [[delegate leftPlayer] name];
		otherColor = @"Red";
	}
	
	GCGameValue *gameCond = [delegate primitive];
	if ([gameCond isEqualToString: GCGameValueLose]) {
		message.text = [NSString stringWithFormat: @"%@ (%@) wins!", otherPlayer, otherColor];
	} else {
		message.text = [NSString stringWithFormat: @"%@ (%@)'s turn!", player, color];
	}
	NSMutableArray* board = position.board;
	int size = position.size;
	float squareSize = self.frame.size.height * (0.9375) / size;
	
	//////Setting up the Squares as buttons
	int tag = 1;
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			float x = i * squareSize;
			float y = j * squareSize;
			
			if (i % 2 == j % 2) {
				if ( (i != 0 || j != 0) && (i != 0 || j != size-1) && (i != size-1 || j != 0)
					&& (i != size-1 || j != size-1) ) {
					
					//Fix scaling
					CGRect vertical = CGRectMake(x + 14, y, squareSize * .5, squareSize + 10);
					CGRect horizontal = CGRectMake(x, y + 14, squareSize + 10, squareSize * .5);
					if ([[board objectAtIndex:i + j * size] isEqual:X]) {
						UIImageView *_x = [[UIImageView alloc] initWithFrame: (i % 2 == 1) ? vertical : horizontal];
						[_x setImage: [UIImage imageNamed: @"ConXBar.png"]];
						[_board addSubview: _x];
					} else if ([[board objectAtIndex:i + j * size] isEqual:O]) {
						UIImageView *_o = [[UIImageView alloc] initWithFrame: (i % 2 == 1) ? horizontal : vertical];
						[_o setImage: [UIImage imageNamed: @"ConOBar.png"]];
						[_board addSubview: _o];
					}
				}
			} else if (i % 2 == 0) {
				UIImageView *_O = [[UIImageView alloc] initWithFrame: CGRectMake(5 + x, 5 + y, 
																				 squareSize, 
																				 squareSize)];
				[_O setImage: [UIImage imageNamed: @"ConO.png"]];
				[_board addSubview: _O];
				[_O release];
			} else {
				UIImageView *_X = [[UIImageView alloc] initWithFrame: CGRectMake(5 + x, 5 + y, 
																				 squareSize, 
																				 squareSize)];
				[_X setImage: [UIImage imageNamed: @"ConX.png"]];
				[_board addSubview: _X];
				[_X release];
			}
			tag += 1;
		}
	}
	
}

- (void)dealloc {
    [super dealloc];
}


@end
