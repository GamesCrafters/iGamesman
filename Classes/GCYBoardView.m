//
//  GCYBoardView.m
//  GamesmanMobile
//
//  Created by Class Account on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYBoardView.h"
#import "GCYGame.h"

@implementation GCYBoardView
@synthesize game;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void) doMove: (NSNumber *) move;

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	
    
}


- (void)dealloc {
    [super dealloc];
}


@end
