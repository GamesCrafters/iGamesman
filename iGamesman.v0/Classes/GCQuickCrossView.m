//
//  GCQuickCrossView.m
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCQuickCrossView.h"


@implementation GCQuickCrossView


- (id)initWithFrame:(CGRect)frame andRows: (int) r andCols: (int) c {
    if ((self = [super initWithFrame:frame])) {
		rows = r;
		cols = c;
		
		self.opaque = NO;
		
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat w = self.bounds.size.width;
	CGFloat h = self.bounds.size.height;
	
	CGFloat size = MIN((w - 180)/cols, (h - 20)/rows);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	UIImage *bgh = [UIImage imageNamed: @"QCNeutralH.png"];
	UIImage *bgv = [UIImage imageNamed: @"QCNeutralV.png"];
	
	CGContextSetLineWidth(ctx, 4);
	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
	
	for (int i = 1; i < cols; i += 1) {
		CGContextMoveToPoint(ctx, 10 + size * i, 10);
		CGContextAddLineToPoint(ctx, 10 + size * i, 10 + size * rows);
	}
	
	for (int j = 1; j < rows; j += 1) {
		CGContextMoveToPoint(ctx, 10, 10 + size * j);
		CGContextAddLineToPoint(ctx, 10 + size * cols, 10 + size * j);
	}
	
	CGContextStrokePath(ctx);
	
	for (int i = 0; i < cols; i += 1)
	{
		for (int j = 0; j < rows; j += 1)
		{
			[bgh drawInRect:CGRectMake (10 + i*size ,10 + j*size , size, size)];
			[bgv drawInRect:CGRectMake (10 + i*size, 10 + j*size , size, size)];

		}
	}
}

- (void)dealloc {
    [super dealloc];
}


@end