//
//  GCConnectionsView.m
//  iGamesman
//
//  Created by Ian Ackerman on 11/21/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCConnectionsView.h"


@implementation GCConnectionsView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		_sizeGame = 8; //Get from model
		float squareSize = frame.size.height * (0.9375) / _sizeGame;
		
		CGRect boardFrame = CGRectMake(frame.size.width - frame.size.height,
									   0, frame.size.height, frame.size.height);
		_board = [[UIView alloc] initWithFrame:boardFrame];
		[self addSubview:_board];
		
		//NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConO" 
		//													 ofType:@"png"];

		//////Setting up the Squares as buttons
		int tag = 1;

		for (int j = 0; j < _sizeGame; j += 1) {
			for (int i = 0; i < _sizeGame; i += 1) {
				float x = i * squareSize;
				float y = j * squareSize;
				
				if (i % 2 == j % 2) {
					if ( (i != 0 || j != 0) && (i != 0 || j != _sizeGame-1) && (i != _sizeGame-1 || j != 0)
						&& (i != _sizeGame-1 || j != _sizeGame-1) ) {
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

- (void) drawRect: (CGRect) rect
{
}

- (void)dealloc {
    [super dealloc];
}


@end
