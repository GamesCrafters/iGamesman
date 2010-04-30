//
//  GCYBoardView.m
//  GamesmanMobile
//
//  Created by Class Account on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYBoardView.h"


@implementation GCYBoardView
@synthesize layers, innerTriangleLength;
@synthesize bottomEdgePieces, centers;
@synthesize edgesForPosition, neighborsForPosition;
@synthesize connectionsView;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	//draw the board
	//draw the other stuff
}


- (void)dealloc {
    [super dealloc];
}


@end
