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
		playerPiece = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.height*7/2., frame.size.height*7/2.)];
		moveValue = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.height/3, frame.size.height/3)];
		[self.imageView addSubview: playerPiece];
		[self.imageView addSubview: moveValue];
		self.imageView.exclusiveTouch = YES;
    }
    return self;
}



- (void) makeMove: (BOOL) p1{
	[playerPiece setImage: [UIImage imageNamed: (p1 ? @"C4X.png" : @"C4O.png")]];
}
		

- (void) moveCenter: (CGPoint) centerPoint{
	self.center = centerPoint;
	playerPiece.center = centerPoint;
	moveValue.center = centerPoint;
}

- (void)dealloc {
	[moveValue release];
	[playerPiece release];
    [super dealloc];
}


@end
