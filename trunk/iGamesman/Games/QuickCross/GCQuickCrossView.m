//
//  GCQuickCrossView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCQuickCrossView.h"

#import "GCQuickCrossPosition.h"

@implementation GCQuickCrossView

@synthesize delegate;
@synthesize backgroundCenter;

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.opaque = NO;
        
        acceptingTouches = NO;
        
        receivingMove  = NO;
        touchDownPoint = CGPointZero;
        moveIndex      = -1;
    }
    
    return self;
}


#pragma mark - Touch handling

- (void) startReceivingTouches
{
    acceptingTouches = YES;
}


- (void) stopReceivingTouches
{
    acceptingTouches = NO;
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!acceptingTouches)
        return;
    
    GCQuickCrossPosition *position = [delegate position];
    
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
    
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    for (NSUInteger row = 0; row < position.rows; row += 1)
    {
        for (NSUInteger col = 0; col < position.columns; col += 1)
        {
            CGRect cellRect = CGRectMake(minX + col * cellSize, minY + row * cellSize, cellSize, cellSize);
            
            if (CGRectContainsPoint(cellRect, location))
            {
                receivingMove = YES;
                touchDownPoint = location;
                moveIndex = col + row * position.columns;
                return;
            }
        }
    }
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!acceptingTouches || !receivingMove)
        return;
    
    GCQuickCrossPosition *position = [delegate position];
    
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    CGFloat deltaX = fabs(location.x - touchDownPoint.x);
    CGFloat deltaY = fabs(location.y - touchDownPoint.y);
    
    NSNumber *slot = [NSNumber numberWithUnsignedInt: moveIndex];
    GCQuickCrossPiece piece = [position.board objectAtIndex: moveIndex];
    
    if (!deltaX && !deltaY)
    {
        if (![piece isEqual: GCQuickCrossBlankPiece])
            [delegate userChoseMove: [NSArray arrayWithObjects: slot, GCQuickCrossSpinMove, nil]];
        
        receivingMove = NO;
        touchDownPoint = CGPointZero;
        moveIndex = -1;
        return;
    }
    
    if ([piece isEqual: GCQuickCrossBlankPiece])
    {
        GCQuickCrossMove moveType = (deltaX > deltaY) ? GCQuickCrossPlaceHorizontalMove : GCQuickCrossPlaceVerticalMove;
        [delegate userChoseMove: [NSArray arrayWithObjects: slot, moveType, nil]];
    }
    else
    {
        [delegate userChoseMove: [NSArray arrayWithObjects: slot, GCQuickCrossSpinMove, nil]];
    }
    
    receivingMove = NO;
    touchDownPoint = CGPointZero;
    moveIndex = -1;
    return;
}


- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event
{
    receivingMove = NO;
    touchDownPoint = CGPointZero;
    moveIndex = -1;
}


#pragma mark - Drawing

- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
#ifdef DEMO
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(backgroundCenter.x - 5, backgroundCenter.y - 5, 10, 10));
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
    CGContextFillRect(ctx, self.bounds);
#endif
    
    
    GCQuickCrossPosition *position = [delegate position];
    
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
    
    
    for (NSUInteger row = 0; row < position.rows; row += 1)
    {
        for (NSUInteger col = 0; col < position.columns; col += 1)
        {
            GCQuickCrossPiece piece = [position.board objectAtIndex: col + row * position.columns];
            
            CGFloat radius    = 0.15f * cellSize;
            CGFloat pieceMinX = minX + (col + 0.1f) * cellSize;
            CGFloat pieceMidX = minX + (col + 0.5f) * cellSize;
            CGFloat pieceMaxX = minX + (col + 0.9f) * cellSize;
            CGFloat pieceMinY = minY + (row + 0.1f) * cellSize;
            CGFloat pieceMidY = minY + (row + 0.5f) * cellSize;
            CGFloat pieceMaxY = minY + (row + 0.9f) * cellSize;
            
            if ([piece isEqual: GCQuickCrossBlankPiece])
            {
                CGContextMoveToPoint(ctx, minX + (col + 0.5f) * cellSize, minY + (row + 0.2f) * cellSize);
                CGContextAddLineToPoint(ctx, minX + (col + 0.5f) * cellSize, minY + (row + 0.8f) * cellSize);
                CGContextMoveToPoint(ctx, minX + (col + 0.2f) * cellSize, minY + (row + 0.5f) * cellSize);
                CGContextAddLineToPoint(ctx, minX + (col + 0.8f) * cellSize, minY + (row + 0.5f) * cellSize);
                
                CGContextSetRGBStrokeColor(ctx, 0, 1, 1, 1);
                CGContextSetLineWidth(ctx, width * 0.0075f);
                CGContextStrokePath(ctx);
            }
            else if ([piece isEqual: GCQuickCrossHorizontalPiece])
            {
                CGContextMoveToPoint(ctx, pieceMinX, pieceMidY);
                CGContextAddArcToPoint(ctx, pieceMinX, pieceMidY - radius, pieceMinX + radius, pieceMidY - radius, radius);
                CGContextAddLineToPoint(ctx, pieceMaxX - radius, pieceMidY - radius);
                CGContextAddArcToPoint(ctx, pieceMaxX, pieceMidY - radius, pieceMaxX, pieceMidY, radius);
                CGContextAddArcToPoint(ctx, pieceMaxX, pieceMidY + radius, pieceMaxX - radius, pieceMidY + radius, radius);
                CGContextAddLineToPoint(ctx, pieceMinX + radius, pieceMidY + radius);
                CGContextAddArcToPoint(ctx, pieceMinX, pieceMidY + radius, pieceMinX, pieceMidY, radius);
                
                CGContextSetRGBFillColor(ctx, 222.0f / 256, 184.0f / 256, 135.0f / 256, 1);
                CGContextFillPath(ctx);
            }
            else if ([piece isEqual: GCQuickCrossVerticalPiece])
            {
                CGContextMoveToPoint(ctx, pieceMidX, pieceMinY);
                CGContextAddArcToPoint(ctx, pieceMidX + radius, pieceMinY, pieceMidX + radius, pieceMinY + radius, radius);
                CGContextAddLineToPoint(ctx, pieceMidX + radius, pieceMaxY - radius);
                CGContextAddArcToPoint(ctx, pieceMidX + radius, pieceMaxY, pieceMidX, pieceMaxY, radius);
                CGContextAddArcToPoint(ctx, pieceMidX - radius, pieceMaxY, pieceMidX - radius, pieceMaxY - radius, radius);
                CGContextAddLineToPoint(ctx, pieceMidX - radius, pieceMinY + radius);
                CGContextAddArcToPoint(ctx, pieceMidX - radius, pieceMinY, pieceMidX, pieceMinY, radius);
                
                CGContextSetRGBFillColor(ctx, 222.0f / 256, 184.0f / 256, 135.0f / 256, 1);
                CGContextFillPath(ctx);
            }
        }
    }
}

@end
