//
//  GCOthelloView.m
//  iGamesman
//
//  Created by Class Account on 10/24/10.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCOthelloView.h"
#define PADDING 0

@implementation GCOthelloView

- (id)initWithFrame:(CGRect)frame andRows: (int) r andCols: (int) c {
	if ((self = [super initWithFrame:frame])) {
		rows = r;
		cols = c;
		
		self.opaque = NO;
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 0];
	}
	return self;
}

- (void)drawRect:(CGRect) rect {
	
	CGFloat w = self.bounds.size.width;
	CGFloat h = self.bounds.size.height;
	CGFloat squareSize, xOffset;
	int boardWidth;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		squareSize = MIN((w - PADDING*2)/cols, (h-80)/(1.0*rows));
		boardWidth = squareSize*rows;
		xOffset = (w - boardWidth)/2.0;
	}
    else{
		squareSize = MIN((w - PADDING*2)/cols, h/(1.0*rows));
		boardWidth = squareSize*rows;
		xOffset = (w - boardWidth - 50)/2.0;
	}
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//Making Green Rectangle Background
	UIImage *bg = [UIImage imageNamed: @"othfelt.png"];
	[bg drawInRect:CGRectMake(xOffset + PADDING, PADDING, cols*squareSize, rows*squareSize)];
	
	//Draw lines within Rectangle
	
	CGContextSetLineWidth(ctx, 1.5);
	CGContextSetRGBStrokeColor(ctx, 0, .1, 0, 0.7);
	
	for (int i = 0; i <= cols; i += 1) {
		CGContextMoveToPoint(ctx, xOffset + PADDING + squareSize * i, PADDING);
		CGContextAddLineToPoint(ctx, xOffset + PADDING + squareSize * i, PADDING + squareSize * rows);
	}
	
	for (int j = 0; j <= rows; j += 1) {
		CGContextMoveToPoint(ctx, xOffset + PADDING, PADDING + squareSize * j);
		CGContextAddLineToPoint(ctx, xOffset + PADDING + squareSize * cols, PADDING + squareSize * j);
	}
	
	CGContextStrokePath(ctx);
	
}

- (void)dealloc {
    [super dealloc];
}


@end
