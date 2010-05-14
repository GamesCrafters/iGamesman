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



- (void) makeMove: (BOOL) p1{
	[playerPiece setImage: [UIImage imageNamed: (p1 ? @"C4X.png" : @"C4O.png")]];
	//[self setImage: [UIImage imageNamed: (p1 ? @"C4X.png" : @"C4O.png")] forState: UIControlStateNormal];
	//[self setBackgroundImage: [UIImage imageNamed: (p1 ? @"C4X.png" : @"C4O.png")] forState:UIControlStateNormal];
}
		

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
