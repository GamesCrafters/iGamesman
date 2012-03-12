//
//  GCOthelloView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/21/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCOthelloView.h"

#import "GCOthelloPosition.h"

@implementation GCOthelloView

@synthesize delegate = _delegate;

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self setOpaque: NO];
        
        _acceptingTouches = NO;
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
    
    GCOthelloPosition *position = [_delegate position];
    NSArray *legalMoves = [_delegate generateMoves];
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / [position rows];
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - cellSize * [position rows]) / 2.0f;
    
    for (int row = 0; row < [position rows]; row += 1)
    {
        for (int column = 0; column < [position columns]; column += 1)
        {
            CGRect cellRect = CGRectMake(minX + column * cellSize, minY + row * cellSize, cellSize, cellSize);
            
            if (CGRectContainsPoint(cellRect, location))
            {
                NSNumber *slotNumber = [NSNumber numberWithInt: row * [position columns] + column];
                if ([legalMoves containsObject: slotNumber])
                    [_delegate userChoseMove: slotNumber];
            }
        }
    }
}


#pragma mark - Drawing

- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
#ifdef DEMO
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
    CGContextFillRect(ctx, [self bounds]);
#endif
    
    GCOthelloPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / [position rows];
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - cellSize * [position rows]) / 2.0f;
    
    UIImage *feltImage = [UIImage imageNamed: @"othelloFelt"];
    [feltImage drawInRect: CGRectMake(minX, minY, cellSize * [position columns], cellSize * [position rows])];
    
    CGContextSetLineWidth(ctx, 1.5);
	CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    
    for (int col = 0; col <= [position columns]; col += 1)
    {
        CGContextMoveToPoint(ctx, minX + cellSize * col, minY);
        CGContextAddLineToPoint(ctx, minX + cellSize * col, minY + cellSize * [position rows]);
    }
    
    for (int row = 0; row <= [position rows]; row += 1)
    {
        CGContextMoveToPoint(ctx, minX, minY + cellSize * row);
        CGContextAddLineToPoint(ctx, minX + cellSize * [position columns], minY + cellSize * row);
    }
	
	CGContextStrokePath(ctx);
    
    NSArray *legalMoves = [_delegate generateMoves];
    
    for (int row = 0; row < [position rows]; row += 1)
    {
        for (int col = 0; col < [position columns]; col += 1)
        {
            int slot = row * [position columns] + col;
            NSNumber *slotNumber = [NSNumber numberWithInt: slot];
            
            CGRect pieceRect = CGRectMake(minX + col * cellSize, minY + row * cellSize, cellSize, cellSize);
            pieceRect = CGRectInset(pieceRect, cellSize * 0.1f, cellSize * 0.1f);
            
            if ([[[position board] objectAtIndex: slot] isEqual: GCOthelloBlackPiece])
            {
                CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
                CGContextFillEllipseInRect(ctx, pieceRect);
            }
            else if ([[[position board] objectAtIndex: slot] isEqual: GCOthelloWhitePiece])
            {
                CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
                CGContextFillEllipseInRect(ctx, pieceRect);
            }
            else if ([legalMoves containsObject: slotNumber])
            {
                CGRect moveRect = CGRectInset(pieceRect, cellSize * 0.2f, cellSize * 0.2f);
                CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
                CGContextFillEllipseInRect(ctx, moveRect);
            }
        }
    }
    
    
    NSUInteger blackCount = [position numberOfBlackPieces];
    NSUInteger whiteCount = [position numberOfWhitePieces];
    
    CGFloat blackHeight = ([position columns] * cellSize) * ((CGFloat) blackCount) / (blackCount + whiteCount);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
    CGContextFillRect(ctx, CGRectMake(minX + [position columns] * cellSize, minY, 20, blackHeight));
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextFillRect(ctx, CGRectMake(minX + [position columns] * cellSize, minY + blackHeight, 20, [position rows] * cellSize - blackHeight));
}

@end
