//
//  GCTicTacToeView.m
//  GamesmanMobile
//
//  Created by Class Account on 10/8/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCTicTacToeView.h"


@implementation GCTicTacToeView


- (id)initWithFrame:(CGRect)frame andRows: (int) r andCols: (int) c {
    if ((self = [super initWithFrame:frame])) {
		rows = r;
		cols = c;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat w = self.bounds.size.width;
	CGFloat h;
}

- (void)dealloc {
    [super dealloc];
}


@end
