//
//  GCSidebarView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCSidebarView.h"

#define OUTER_RADIUS  (10)
#define INNER_RADIUS  (8)
#define OUTLINE_WIDTH (3)

@implementation GCSidebarView

- (id)initWithFrame: (CGRect) frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.opaque = NO;
    }
    
    return self;
}

- (void)drawRect: (CGRect) rect
{
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /* Draw the outline */
    CGContextMoveToPoint(ctx, maxX, minY);
    CGContextAddLineToPoint(ctx, maxX, maxY);
    CGContextAddArcToPoint(ctx, minX, maxY, minX, maxY - OUTER_RADIUS, OUTER_RADIUS);
    CGContextAddArcToPoint(ctx, minX, minY, minX + OUTER_RADIUS, minY, OUTER_RADIUS);
    CGContextAddLineToPoint(ctx, maxX, minY);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    
    CGContextFillPath(ctx);
    
    /* Draw the background */
    CGContextMoveToPoint(ctx, maxX, minY + OUTLINE_WIDTH);
    CGContextAddLineToPoint(ctx, maxX, maxY - OUTLINE_WIDTH);
    CGContextAddArcToPoint(ctx, minX + OUTLINE_WIDTH, maxY - OUTLINE_WIDTH, minX + OUTLINE_WIDTH, maxY - OUTLINE_WIDTH - INNER_RADIUS, INNER_RADIUS);
    CGContextAddArcToPoint(ctx, minX + OUTLINE_WIDTH, minY + OUTLINE_WIDTH, minX + OUTLINE_WIDTH + INNER_RADIUS, minY + OUTLINE_WIDTH, INNER_RADIUS);
    CGContextAddLineToPoint(ctx, maxX, minY + OUTLINE_WIDTH);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
    
    CGContextFillPath(ctx);
}

@end
