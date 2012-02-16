//
//  GCTicTacToeView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCTicTacToeView.h"

#import "GCTicTacToePosition.h"


@implementation GCTicTacToeView

@synthesize delegate;
@synthesize backgroundCenter;


- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.opaque = NO;
        
        acceptingTouches = NO;
    }
    
    return self;
}


#pragma mark - Touch handling

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!acceptingTouches)
        return;
    
    
    GCTicTacToePosition *position = [delegate position];
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    CGFloat height = self.bounds.size.height;
    
    CGFloat halfWidth  = backgroundCenter.x - self.bounds.origin.x;
    CGFloat halfHeight = self.bounds.origin.y + height - backgroundCenter.y;
    
    CGFloat maxCellWidth  = (2 * halfWidth) / position.columns;
    CGFloat maxCellHeight = (2 * halfHeight) / position.rows;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    
    minX += (backgroundCenter.x - cellSize * position.columns / 2.0f);
    minY += (backgroundCenter.y - cellSize * position.rows / 2.0f);
    
    for (int row = 0; row < position.rows; row += 1)
    {
        for (int column = 0; column < position.columns; column += 1)
        {
            CGRect cellRect = CGRectMake(minX + column * cellSize, minY + row * cellSize, cellSize, cellSize);
            
            if (CGRectContainsPoint(cellRect, location))
            {
                NSNumber *slotNumber = [NSNumber numberWithInt: row * position.columns + column];
                if ([[position.board objectAtIndex: slotNumber.unsignedIntegerValue] isEqualToString: GCTTTBlankPiece])
                    [delegate userChoseMove: slotNumber];
            }
        }
    }
}


#pragma mark -

- (void) startReceivingTouches
{
    acceptingTouches = YES;
}


- (void) stopReceivingTouches
{
    acceptingTouches = NO;
}


#pragma mark - Drawing

- (void) drawXInRect: (CGRect) rect intoContext: (CGContextRef) ctx
{
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
    CGContextSetLineWidth(ctx, rect.size.width * 0.1f);
    
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
    CGContextSetLineWidth(ctx, rect.size.width * 0.1f);
    
    CGFloat insetX = rect.size.width * 0.15f;
    CGFloat insetY = rect.size.height * 0.15f;
    
    CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, insetX, insetY));
}


- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
#ifdef DEMO
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(backgroundCenter.x - 5, backgroundCenter.y - 5, 10, 10));
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
    CGContextFillRect(ctx, self.bounds);
#endif
    
    GCTicTacToePosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat halfWidth  = backgroundCenter.x - self.bounds.origin.x;
    CGFloat halfHeight = self.bounds.origin.y + height - backgroundCenter.y;
    
    CGFloat maxCellWidth  = (2 * halfWidth) / position.columns;
    CGFloat maxCellHeight = (2 * halfHeight) / position.rows;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    
    minX += (backgroundCenter.x - cellSize * position.columns / 2.0f);
    minY += (backgroundCenter.y - cellSize * position.rows / 2.0f);
    
    /* Vertical separators */
    for (int i = 1; i < position.columns; i += 1)
    {
        CGContextMoveToPoint(ctx, minX + i * cellSize, minY);
        CGContextAddLineToPoint(ctx, minX + i * cellSize, minY + position.rows * cellSize);
    }
    
    /* Horizontal separators */
    for (int j = 1; j < position.rows; j += 1)
    {
        CGContextMoveToPoint(ctx, minX, minY + j * cellSize);
        CGContextAddLineToPoint(ctx, minX + position.columns * cellSize, minY + j * cellSize);
    }
    
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, width * 0.01f);
    CGContextStrokePath(ctx);
    
    
    NSArray *moveValues = [delegate moveValues];
    NSArray *remotenessValues = [delegate remotenessValues];
    
    
    for (NSUInteger i = 0; i < [position.board count]; i += 1)
    {
        GCTTTPiece piece = [position.board objectAtIndex: i];
        GCGameValue *value = [moveValues objectAtIndex: i];
        NSInteger remoteness = [[remotenessValues objectAtIndex: i] integerValue];
        
        NSUInteger row = i / position.columns;
        NSUInteger column = i % position.columns;
        
        CGRect cellRect = CGRectMake(minX + column * cellSize, minY + row * cellSize, cellSize, cellSize);
        
        
        if (value && ![value isEqualToString: GCGameValueUnknown] && [delegate isShowingMoveValues])
        {
            CGFloat alpha;
            if ([delegate isShowingDeltaRemoteness] && (remoteness != 0))
                alpha = 1.0f / log(remoteness + 1);
            else
                alpha = 1;
            
            if ([value isEqualToString: GCGameValueWin])
                CGContextSetRGBFillColor(ctx, 0, 1, 0, alpha);
            else if ([value isEqualToString: GCGameValueLose])
                CGContextSetRGBFillColor(ctx, 139.0f / 255, 0, 0, alpha);
            else if ([value isEqualToString: GCGameValueTie])
                CGContextSetRGBFillColor(ctx, 1, 1, 0, alpha);
            
            CGContextFillEllipseInRect(ctx, CGRectInset(cellRect, cellSize / 3.0f, cellSize / 3.0f));
        }
        
        
        if (piece == GCTTTXPiece)
            [self drawXInRect: cellRect intoContext: ctx];
        else if (piece == GCTTTOPiece)
            [self drawOInRect: cellRect intoContext: ctx];
    }
}

@end
