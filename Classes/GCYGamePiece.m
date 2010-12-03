//
//  GCYGamePiece.m
//  GamesmanMobile
//
//  Created by Class Account on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYGamePiece.h"


@implementation GCYGamePiece
@synthesize playerPiece;
@synthesize moveValue;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		playerPiece = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.height*2/3., frame.size.height*2/3.)];
		moveValue = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.height/3, frame.size.height/3)];
		[self addSubview: playerPiece];
		[self addSubview: moveValue];
		self.imageView.exclusiveTouch = YES;
		self.adjustsImageWhenDisabled = NO;

    }
    return self;
}


/** Sets the playerPiece image to be the piece of player1 or player2 depending 
 ** on whose turn it currently is. 
 **
 ** @p1 - a boolean representing what player's turn it is
 **/
- (void) makeMove: (BOOL) p1{
	[playerPiece setImage: [UIImage imageNamed: (p1 ? @"C4X.png" : @"C4O.png")]];
	[moveValue setBackgroundColor: [UIColor	clearColor]];
	
//	[UIView beginAnimations: @"AddPiece" context: NULL];
//	[playerPiece setFrame: CGRectMake(10 + col * size, 10 + row * size, size, size)];
//	[UIView commitAnimations];
	//[self setImage: [UIImage imageNamed: (p1 ? @"C4X.png" : @"C4O.png")] forState: UIControlStateNormal];
	//[self setBackgroundImage: [UIImage imageNamed: (p1 ? @"C4X.png" : @"C4O.png")] forState:UIControlStateNormal];
}

//#######################################################
- (void) undoMove {
	[playerPiece setImage: nil];
}
		

/**
 When the center of this is changed, use this to change the centers of the two inner images as well
 **/
- (void) moveCenter: (CGPoint) centerPoint{
	self.center = centerPoint;
	CGFloat centerValue = self.frame.size.height/2.;
	playerPiece.center = CGPointMake(centerValue, centerValue);
	moveValue.center = CGPointMake(centerValue, centerValue);
}

- (void)dealloc {
	[moveValue release];
	[playerPiece release];
    [super dealloc];
}


@end
