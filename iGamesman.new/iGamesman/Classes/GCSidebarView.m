//
//  GCSidebarView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCSidebarView.h"

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
    
    CGContextMoveToPoint(ctx, maxX, minY);
    CGContextAddLineToPoint(ctx, maxX, maxY);
    CGContextAddArcToPoint(ctx, minX, maxY, minX, maxY - 10, 10);
    CGContextAddArcToPoint(ctx, minX, minY, minX + 10, minY, 10);
    CGContextAddLineToPoint(ctx, maxX, minY);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    
    CGContextFillPath(ctx);
    
    CGContextMoveToPoint(ctx, maxX, minY + 3);
    CGContextAddLineToPoint(ctx, maxX, maxY - 3);
    CGContextAddArcToPoint(ctx, minX + 3, maxY - 3, minX + 3, maxY - 13, 10);
    CGContextAddArcToPoint(ctx, minX + 3, minY + 3, minX + 13, minY + 3, 10);
    CGContextAddLineToPoint(ctx, maxX, minY + 3);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
    
    CGContextFillPath(ctx);
}

@end
