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

@synthesize delegate = _delegate;

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self setOpaque: NO];
        
        _acceptingTouches = NO;
        
        _receivingMove  = NO;
        _touchDownPoint = CGPointZero;
        _moveIndex      = -1;
    }
    
    return self;
}


#pragma mark - Touch handling

- (void) startReceivingTouches
{
    _acceptingTouches = YES;
}


- (void) stopReceivingTouches
{
    _acceptingTouches = NO;
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!_acceptingTouches)
        return;
    
    GCQuickCrossPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = (width / [position columns]);
    CGFloat maxCellHeight = (height / [position rows]);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - [position columns] * cellSize) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - [position rows] * cellSize) / 2.0f;
    
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    for (NSUInteger row = 0; row < [position rows]; row += 1)
    {
        for (NSUInteger col = 0; col < [position columns]; col += 1)
        {
            CGRect cellRect = CGRectMake(minX + col * cellSize, minY + row * cellSize, cellSize, cellSize);
            
            if (CGRectContainsPoint(cellRect, location))
            {
                _receivingMove = YES;
                _touchDownPoint = location;
                _moveIndex = col + row * [position columns];
                return;
            }
        }
    }
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!_acceptingTouches || !_receivingMove)
        return;
    
    GCQuickCrossPosition *position = [_delegate position];
    
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    CGFloat deltaX = fabs(location.x - _touchDownPoint.x);
    CGFloat deltaY = fabs(location.y - _touchDownPoint.y);
    
    NSNumber *slot = [NSNumber numberWithUnsignedInt: _moveIndex];
    GCQuickCrossPiece piece = [[position board] objectAtIndex: _moveIndex];
    
    if (!deltaX && !deltaY)
    {
        if (![piece isEqual: GCQuickCrossBlankPiece])
            [_delegate userChoseMove: [NSArray arrayWithObjects: slot, GCQuickCrossSpinMove, nil]];
        
        _receivingMove = NO;
        _touchDownPoint = CGPointZero;
        _moveIndex = -1;
        return;
    }
    
    if ([piece isEqual: GCQuickCrossBlankPiece])
    {
        GCQuickCrossMove moveType = (deltaX > deltaY) ? GCQuickCrossPlaceHorizontalMove : GCQuickCrossPlaceVerticalMove;
        [_delegate userChoseMove: [NSArray arrayWithObjects: slot, moveType, nil]];
    }
    else
    {
        [_delegate userChoseMove: [NSArray arrayWithObjects: slot, GCQuickCrossSpinMove, nil]];
    }
    
    _receivingMove = NO;
    _touchDownPoint = CGPointZero;
    _moveIndex = -1;
    return;
}


- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event
{
    _receivingMove = NO;
    _touchDownPoint = CGPointZero;
    _moveIndex = -1;
}


#pragma mark - Drawing

- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
#ifdef DEMO
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(backgroundCenter.x - 5, backgroundCenter.y - 5, 10, 10));
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
    CGContextFillRect(ctx, [self bounds]);
#endif
    
    
    GCQuickCrossPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = (width / [position columns]);
    CGFloat maxCellHeight = (height / [position rows]);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - [position columns] * cellSize) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - [position rows] * cellSize) / 2.0f;
    
    /* Vertical separators */
    for (int i = 1; i < [position columns]; i += 1)
    {
        CGContextMoveToPoint(ctx, minX + i * cellSize, minY);
        CGContextAddLineToPoint(ctx, minX + i * cellSize, minY + [position rows] * cellSize);
    }
    
    /* Horizontal separators */
    for (int j = 1; j < [position rows]; j += 1)
    {
        CGContextMoveToPoint(ctx, minX, minY + j * cellSize);
        CGContextAddLineToPoint(ctx, minX + [position columns] * cellSize, minY + j * cellSize);
    }
    
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, width * 0.01f);
    CGContextStrokePath(ctx);
    
    
    for (NSUInteger row = 0; row < [position rows]; row += 1)
    {
        for (NSUInteger col = 0; col < [position columns]; col += 1)
        {
            GCQuickCrossPiece piece = [[position board] objectAtIndex: col + row * [position columns]];
            
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
