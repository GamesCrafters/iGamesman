//
//  GCConnectFourView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConnectFourView.h"

#import "GCGame.h"

#import "GCConnectFourPieceView.h"
#import "GCConnectFourPosition.h"
#import "GCUtilities.h"

#define PIECE_OFFSET (10000)

@implementation GCConnectFourView

@synthesize delegate = _delegate;


#pragma mark - Memory lifecycle

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self setOpaque: NO];
    }
    return self;
}


#pragma mark -

- (void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    
    GCConnectFourPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / ([position rows] + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - cellSize * ([position rows] - 0.5f)) / 2.0f;
    
    for (NSUInteger slot = 0; slot < ([position rows] * [position columns]); slot += 1)
    {
        GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: PIECE_OFFSET + slot];
        
        if (pieceView)
        {
            NSUInteger row = slot / [position columns];
            NSUInteger col = slot % [position columns];
            CGRect destinationFrame = CGRectMake(minX + col * cellSize, minY + ([position rows] - row - 1) * cellSize, cellSize, cellSize);
            [pieceView setFrame: destinationFrame];
        }
    }
}


- (void) startReceivingTouches
{
    acceptingTouches = YES;
}


- (void) stopReceivingTouches
{
    acceptingTouches = NO;
}


- (void) doMove: (NSNumber *) column
{
    GCConnectFourPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / ([position rows] + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - cellSize * ([position rows] - 0.5f)) / 2.0f;
    
    NSUInteger col = [column unsignedIntegerValue];
    
    for (int row = 0; row < [position rows]; row += 1)
    {
        NSUInteger slot = row * [position columns] + col;
        
        if ([[[position board] objectAtIndex: slot] isEqual: GCConnectFourBlankPiece])
        {
            CGRect destinationFrame = CGRectMake(minX + col * cellSize, minY + ([position rows] - row - 1) * cellSize, cellSize, cellSize);
            
            GCConnectFourPieceView *newPieceView;
            CGRect pieceFrame = CGRectMake(minX + col * cellSize, minY - cellSize, cellSize, cellSize);
            if ([position leftTurn])
                newPieceView = [[GCConnectFourPieceView alloc] initRedWithFrame: pieceFrame];
            else
                newPieceView = [[GCConnectFourPieceView alloc] initBlueWithFrame: pieceFrame];
            
            [newPieceView setTag: PIECE_OFFSET + slot];
            [self addSubview: newPieceView];
            [self sendSubviewToBack: newPieceView];
            
            [UIView animateWithDuration: 0.25f
                             animations: ^{ [newPieceView setFrame: destinationFrame]; } ];
            
            [newPieceView release];
            
            return;
        }
    }
}


- (void) undoMove: (NSNumber *) column
{
    GCConnectFourPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / ([position rows] + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    
    
    NSUInteger col = [column unsignedIntegerValue];
    
    for (int row = [position rows] - 1; row >= 0; row -= 1)
    {
        NSUInteger slot = row * [position columns] + col;
        
        if (![[[position board] objectAtIndex: slot] isEqual: GCConnectFourBlankPiece])
        {
            CGRect destinationFrame = CGRectMake(minX + col * cellSize, -cellSize, cellSize, cellSize);
            
            GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: PIECE_OFFSET + slot];
            
            [UIView animateWithDuration: 0.25f
                             animations: ^{ [pieceView setFrame: destinationFrame]; } 
                             completion: ^(BOOL done) { [pieceView removeFromSuperview]; }];
            
            return;
        }
    }
}


- (void) resetBoard
{
    GCConnectFourPosition *position = [_delegate position];
    for (NSUInteger i = 0; i < [position rows] * [position columns]; i += 1)
    {
        UIView *pieceView = [self viewWithTag: PIECE_OFFSET + i];
        [pieceView removeFromSuperview];
    }
    
    [self setNeedsDisplay];
}


#pragma mark - Touch capture

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    GCConnectFourPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / ([position rows] + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - cellSize * ([position rows] - 0.5f)) / 2.0f;
    
    if (acceptingTouches)
    {
        UITouch *touch = [touches anyObject];
        CGFloat tapX = [touch locationInView: self].x;
        
        NSInteger column = (NSInteger) ((tapX - minX) / cellSize);
        if (column < 0)
            column = 0;
        if (column >= [position columns])
            column = [position columns] - 1;
        
        GCConnectFourPieceView *newPieceView;
        CGRect pieceFrame = CGRectMake(minX + column * cellSize, minY - cellSize, cellSize, cellSize);
        if ([position leftTurn])
            newPieceView = [[GCConnectFourPieceView alloc] initRedWithFrame: pieceFrame];
        else
            newPieceView = [[GCConnectFourPieceView alloc] initBlueWithFrame: pieceFrame];
        
        [newPieceView setTag: 123456789];
        [self addSubview: newPieceView];
        
        [newPieceView release];
    }
}


- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
    GCConnectFourPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / ([position rows] + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - cellSize * ([position rows] - 0.5f)) / 2.0f;
    
    if (acceptingTouches)
    {
        UITouch *touch = [touches anyObject];
        CGFloat dragX = [touch locationInView: self].x;
        
        GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: 123456789];
        if (pieceView)
        {
            NSInteger column = (NSInteger) ((dragX - minX) / cellSize);
            if (column < 0)
                column = 0;
            if (column >= [position columns])
                column = [position columns] - 1;
            
            CGRect newFrame = CGRectMake(minX + column * cellSize, minY - cellSize, cellSize, cellSize);
            [UIView animateWithDuration: 0.1f animations: ^{ [pieceView setFrame: newFrame]; }];
        }
    }
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    GCConnectFourPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / ([position rows] + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    
    if (acceptingTouches)
    {
        GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: 123456789];
        if (pieceView)
        {
            NSInteger column = (NSInteger) (([pieceView center].x - minX) / cellSize);
            NSNumber *move = [NSNumber numberWithInteger: column];
            
            if ([[_delegate generateMoves] containsObject: move])
                [_delegate userChoseMove: move];
            
            [pieceView removeFromSuperview];
        }
    }
}


- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (acceptingTouches)
    {
        GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: 123456789];
        if (pieceView)
        {
            [pieceView removeFromSuperview];
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
    
    
    GCConnectFourPosition *position = [_delegate position];
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / [position columns];
    CGFloat maxCellHeight = height / ([position rows] + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + (width - cellSize * [position columns]) / 2.0f;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - cellSize * ([position rows] - 0.5f)) / 2.0f;
    
    
    NSArray *moveValues = [_delegate moveValues];
    NSArray *remotenessValues = [_delegate remotenessValues];
    
    NSArray *sortedValues = [GCValuesHelper sortedValuesForMoveValues: moveValues remotenesses: remotenessValues];
    
    for (int i = 0; i < [position columns]; i += 1)
    {
        /* Draw move values at the top, if enabled */
        if ([_delegate isShowingMoveValues])
        {
            GCGameValue *value = [moveValues objectAtIndex: i];
            NSInteger remoteness = [[remotenessValues objectAtIndex: i] integerValue];
            
            CGRect valueRect = CGRectMake(minX + cellSize * i, minY - (cellSize / 2.0f), cellSize, cellSize / 2.0f);
            /* Expand in X direction by 1/2 pixel each side to overlap */
            valueRect = CGRectInset(valueRect, -0.5f, 0);
            
            
            if (![value isEqualToString: GCGameValueUnknown])
            {
                CGContextSetRGBFillColor(ctx, 0.8f, 0.8f, 0.8f, 1);
                CGContextFillRect(ctx, valueRect);
                
                CGFloat alpha = 1;
                
                if ([_delegate isShowingDeltaRemoteness])
                {
                    alpha = 0.2f;
                    
                    if ([sortedValues count] > 0)
                    {
                        NSArray *pair = [sortedValues objectAtIndex: 0];
                        GCGameValue *v = [pair objectAtIndex: 0];
                        NSNumber *n = [pair objectAtIndex: 1];
                        
                        if ([v isEqualToString: value] && ([n integerValue] == remoteness))
                            alpha = 1;
                    }
                    
                    if ([sortedValues count] > 1)
                    {
                        NSArray *pair = [sortedValues objectAtIndex: 1];
                        GCGameValue *v = [pair objectAtIndex: 0];
                        NSNumber *n = [pair objectAtIndex: 1];
                        
                        if ([v isEqualToString: value] && ([n integerValue] == remoteness))
                            alpha = 0.5f;
                    }
                    
                    if ([sortedValues count] > 2)
                    {
                        NSArray *pair = [sortedValues objectAtIndex: 2];
                        GCGameValue *v = [pair objectAtIndex: 0];
                        NSNumber *n = [pair objectAtIndex: 1];
                        
                        if ([v isEqualToString: value] && ([n integerValue] == remoteness))
                            alpha = 0.3f;
                    }
                }
                
                
                GCColor color = {0.0f, 0.0f, 0.0f};
                if ([value isEqualToString: GCGameValueWin])
                    color = [GCConstants winColor];
                else if ([value isEqualToString: GCGameValueLose])
                    color = [GCConstants loseColor];
                else if ([value isEqualToString: GCGameValueTie])
                    color = [GCConstants tieColor];
                
                CGContextSetRGBFillColor(ctx, color.red, color.green, color.blue, alpha);
                
                CGContextFillRect(ctx, valueRect);
            }
        }
        
        for (int j = 0; j < [position rows]; j += 1)
        {
            CGMutablePathRef path = CGPathCreateMutable();
            CGRect cellRect = CGRectMake(minX + cellSize * i, minY + cellSize * j, cellSize, cellSize);
            /* Expand rectangle by a pixel to overlap them */
            cellRect = CGRectInset(cellRect, -1, -1);
            
            /* Add the outer (square) boundary */
            CGPathAddRect(path, NULL, cellRect);
            /* Add the inner (circular) boundary */
            CGPathAddEllipseInRect(path, NULL, CGRectInset(cellRect, cellSize * 0.15f, cellSize * 0.15f));
            CGContextAddPath(ctx, path);
            
            /* Fill according to the even-odd rule */
            CGContextSetRGBFillColor(ctx, 0.5f, 0.5f, 0.5f, 1);
            CGContextEOFillPath(ctx);
            
            CGPathRelease(path);
        }
    }
}


@end
