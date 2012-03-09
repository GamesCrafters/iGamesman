//
//  GCConnectFourPieceView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConnectFourPieceView.h"


typedef enum { GC_ConnectFour_RED, GC_ConnectFour_BLUE } GCConnectFourPieceColor;

@interface GCConnectFourPieceView ()
{
    GCConnectFourPieceColor color;
}
@end


@implementation GCConnectFourPieceView

- (id) initRedWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        color = GC_ConnectFour_RED;
        
        [self setOpaque: NO];
    }
    
    return self;
}


- (id) initBlueWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        color = GC_ConnectFour_BLUE;
        
        [self setOpaque: NO];
    }
    
    return self;
}


#pragma mark - Drawing

- (void) drawRect: (CGRect) dirtyRect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    if (color == GC_ConnectFour_RED)
        CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    else if (color == GC_ConnectFour_BLUE)
        CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    
    CGRect rect = CGRectInset([self bounds], width * 0.125f, height * 0.125f);
    CGContextFillEllipseInRect(ctx, rect);
}

@end
