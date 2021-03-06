//
//  GCDrawerView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCDrawerView.h"

#define OUTER_RADIUS (10)


#pragma mark -

@implementation GCDrawerView

#pragma mark -
#pragma mark Memory lifecycle

- (id) initWithFrame: (CGRect) frame startOffscreen: (BOOL) offscreen;
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat width = self.frame.size.width;
        if (offscreen)
        {
            self.frame = CGRectOffset(self.frame, -width, 0);
        }
        
        self.opaque = NO;
        
        UIImage *closeImage = [UIImage imageNamed: @"CloseButton"];
        closeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [closeButton setImage: closeImage forState: UIControlStateNormal];
        [closeButton addTarget: self action: @selector(closeTapped) forControlEvents: UIControlEventTouchUpInside];
        [closeButton setFrame: CGRectMake(width - 44, 0, 44, 44)];
        [closeButton setAlpha: 0];
        
        [self addSubview: closeButton];
        
        [closeButton retain];
    }
    return self;
}


- (void) dealloc
{
    [closeButton release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Sliding animations

- (void) slideIn
{
    void (^slideBlock) (void) = ^(void)
    {
        self.frame = CGRectOffset(self.frame, +self.frame.size.width, 0);
        closeButton.alpha = 1;
    };
    
    [UIView animateWithDuration: 0.25f
                     animations: slideBlock];
}


- (void) slideOut
{
    void (^slideBlock) (void) = ^(void)
    {
        self.frame = CGRectOffset(self.frame, -self.frame.size.width, 0);
        closeButton.alpha = 0;
    };
    
    [UIView animateWithDuration: 0.25f
                     animations: slideBlock];
}


#pragma mark -

- (void) closeTapped
{
    [self slideOut];
}


#pragma mark -
#pragma mark Drawing

- (void) drawRect: (CGRect) rect
{
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /* Draw the background rectangle */
    CGContextMoveToPoint(ctx, minX, minY);
    CGContextAddLineToPoint(ctx, minX, maxY);
    CGContextAddArcToPoint(ctx, maxX, maxY, maxX, maxY - OUTER_RADIUS, OUTER_RADIUS);
    CGContextAddArcToPoint(ctx, maxX, minY, maxX - OUTER_RADIUS, minY, OUTER_RADIUS);
    CGContextAddLineToPoint(ctx, minX, minY);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.9f);
    
    CGContextFillPath(ctx);
}


@end
