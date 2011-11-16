//
//  GCQuartoView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCQuartoView.h"

@implementation GCQuartoView

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGPoint topLeft = self.bounds.origin;
        CGPoint bottomRight = CGPointMake(topLeft.x + width, topLeft.y + height);
        
        boardFrame = CGRectMake(bottomRight.x - height, 0, height, height);
        
        self.opaque = NO;
    }
    return self;
}

- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGImageRef image = [[UIImage imageNamed: @"quartoBoard.jpg"] CGImage];
    
    CGContextDrawImage(ctx, boardFrame, image);
    
    CGContextAddEllipseInRect(ctx, CGRectInset(boardFrame, 10, 10));
    
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.6f);
    CGContextSetLineWidth(ctx, 4);
    
    CGContextStrokePath(ctx);
}

@end
