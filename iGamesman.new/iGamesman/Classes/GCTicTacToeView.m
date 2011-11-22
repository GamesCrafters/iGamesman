//
//  GCTicTacToeView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCTicTacToeView.h"

#import "GCTicTacToePosition.h"

@implementation GCTicTacToeView

@synthesize delegate;

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.opaque = NO;
    }
    return self;
}


- (void) drawXInRect: (CGRect) rect intoContext: (CGContextRef) ctx
{
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
    CGContextSetLineWidth(ctx, 10);
    
    CGFloat insetX = rect.size.width * 0.15f;
    CGFloat insetY = rect.size.height * 0.15f;
    
    CGRect insetRect = CGRectInset(rect, insetX, insetY);
    
    CGFloat minX = CGRectGetMinX(insetRect);
    CGFloat minY = CGRectGetMinY(insetRect);
    CGFloat maxX = CGRectGetMaxX(insetRect);
    CGFloat maxY = CGRectGetMaxY(insetRect);
    
    CGContextMoveToPoint(ctx, minX, minY);
    CGContextAddLineToPoint(ctx, maxX, maxY);
    
    CGContextMoveToPoint(ctx, minX, maxY);
    CGContextAddLineToPoint(ctx, maxX, minY);
    
    CGContextStrokePath(ctx);
}


- (void) drawOInRect: (CGRect) rect intoContext: (CGContextRef) ctx
{
    CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
    CGContextSetLineWidth(ctx, 10);
    
    CGFloat insetX = rect.size.width * 0.15f;
    CGFloat insetY = rect.size.height * 0.15f;
    
    CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, insetX, insetY));
}


- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    GCTicTacToePosition *position = [delegate currentPosition];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth = width / position.columns;
    CGFloat maxCellHeight = height / position.rows;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    
    for (int i = 1; i < position.columns; i += 1)
    {
        CGContextMoveToPoint(ctx, minX + i * cellSize, minY);
        CGContextAddLineToPoint(ctx, minX + i * cellSize, minY + position.rows * cellSize);
    }
    
    for (int j = 1; j < position.rows; j += 1)
    {
        CGContextMoveToPoint(ctx, minX, minY + j * cellSize);
        CGContextAddLineToPoint(ctx, minX + position.columns * cellSize, minY + j * cellSize);
    }
    
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 4);
    CGContextStrokePath(ctx);
    
    
    for (int i = 0; i < [position.board count]; i += 1)
    {
        GCTTTPiece piece = [position.board objectAtIndex: i];
        
        NSUInteger row = i / position.columns;
        NSUInteger column = i % position.columns;
        
        CGRect cellRect = CGRectMake(minX + column * cellSize, minY + row * cellSize, cellSize, cellSize);
        
        if (piece == GCTTTXPiece)
            [self drawXInRect: cellRect intoContext: ctx];
        else if (piece == GCTTTOPiece)
            [self drawOInRect: cellRect intoContext: ctx];
    }
}

@end
