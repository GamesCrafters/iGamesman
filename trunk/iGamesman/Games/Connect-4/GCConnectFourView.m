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

#define PIECE_OFFSET (10000)

@implementation GCConnectFourView

@synthesize delegate;


#pragma mark - Memory lifecycle

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.opaque = NO;
    }
    return self;
}


#pragma mark -

- (void) setFrame: (CGRect) frame
{
    [super setFrame: frame];
    
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.columns;
    CGFloat maxCellHeight = height / (position.rows + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.columns) / 2.0f;
    CGFloat minY = CGRectGetMinY(self.bounds) + (height - cellSize * (position.rows - 0.5f)) / 2.0f;
    
    for (NSUInteger slot = 0; slot < position.rows * position.columns; slot += 1)
    {
        GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: PIECE_OFFSET + slot];
        
        if (pieceView)
        {
            NSUInteger row = slot / position.columns;
            NSUInteger col = slot % position.columns;
            CGRect destinationFrame = CGRectMake(minX + col * cellSize, minY + (position.rows - row - 1) * cellSize, cellSize, cellSize);
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
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.columns;
    CGFloat maxCellHeight = height / (position.rows + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.columns) / 2.0f;
    CGFloat minY = CGRectGetMinY(self.bounds) + (height - cellSize * (position.rows - 0.5f)) / 2.0f;
    
    NSUInteger col = [column unsignedIntegerValue];
    
    for (int row = 0; row < position.rows; row += 1)
    {
        NSUInteger slot = row * position.columns + col;
        
        if ([[position.board objectAtIndex: slot] isEqual: GCConnectFourBlankPiece])
        {
            CGRect destinationFrame = CGRectMake(minX + col * cellSize, minY + (position.rows - row - 1) * cellSize, cellSize, cellSize);
            
            GCConnectFourPieceView *newPieceView;
            CGRect pieceFrame = CGRectMake(minX + col * cellSize, minY - cellSize, cellSize, cellSize);
            if (position.leftTurn)
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
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.columns;
    CGFloat maxCellHeight = height / (position.rows + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.columns) / 2.0f;
    
    
    NSUInteger col = [column unsignedIntegerValue];
    
    for (int row = position.rows - 1; row >= 0; row -= 1)
    {
        NSUInteger slot = row * position.columns + col;
        
        if (![[position.board objectAtIndex: slot] isEqual: GCConnectFourBlankPiece])
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
    GCConnectFourPosition *position = [delegate position];
    for (NSUInteger i = 0; i < position.rows * position.columns; i += 1)
    {
        UIView *pieceView = [self viewWithTag: PIECE_OFFSET + i];
        [pieceView removeFromSuperview];
    }
    
    [self setNeedsDisplay];
}


#pragma mark - Touch capture

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.columns;
    CGFloat maxCellHeight = height / (position.rows + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.columns) / 2.0f;
    CGFloat minY = CGRectGetMinY(self.bounds) + (height - cellSize * (position.rows - 0.5f)) / 2.0f;
    
    if (acceptingTouches)
    {
        UITouch *touch = [touches anyObject];
        CGFloat tapX = [touch locationInView: self].x;
        
        NSInteger column = (NSInteger) ((tapX - minX) / cellSize);
        if (column < 0)
            column = 0;
        if (column >= position.columns)
            column = position.columns - 1;
        
        GCConnectFourPieceView *newPieceView;
        CGRect pieceFrame = CGRectMake(minX + column * cellSize, minY - cellSize, cellSize, cellSize);
        if (position.leftTurn)
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
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.columns;
    CGFloat maxCellHeight = height / (position.rows + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.columns) / 2.0f;
    CGFloat minY = CGRectGetMinY(self.bounds) + (height - cellSize * (position.rows - 0.5f)) / 2.0f;
    
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
            if (column >= position.columns)
                column = position.columns - 1;
            
            CGRect newFrame = CGRectMake(minX + column * cellSize, minY - cellSize, cellSize, cellSize);
            [UIView animateWithDuration: 0.1f animations: ^{ [pieceView setFrame: newFrame]; }];
        }
    }
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.columns;
    CGFloat maxCellHeight = height / (position.rows + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.columns) / 2.0f;
    
    if (acceptingTouches)
    {
        GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: 123456789];
        if (pieceView)
        {
            NSInteger column = (NSInteger) (([pieceView center].x - minX) / cellSize);
            NSNumber *move = [NSNumber numberWithInteger: column];
            
            if ([[delegate generateMoves] containsObject: move])
                [delegate userChoseMove: move];
            
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
    CGContextFillRect(ctx, self.bounds);
#endif
    
    
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.columns;
    CGFloat maxCellHeight = height / (position.rows + 0.5f);
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.columns) / 2.0f;
    CGFloat minY = CGRectGetMinY(self.bounds) + (height - cellSize * (position.rows - 0.5f)) / 2.0f;
    
    
    NSArray *moveValues = [delegate moveValues];
    NSArray *remotenessValues = [delegate remotenessValues];
    
    for (int i = 0; i < position.columns; i += 1)
    {
        /* Draw move values at the top, if enabled */
        if ([delegate isShowingMoveValues])
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
                if ([delegate isShowingDeltaRemoteness] && (remoteness != 0))
                    alpha = 1.0f / log(remoteness + 1);
                
                if ([value isEqualToString: GCGameValueWin])
                    CGContextSetRGBFillColor(ctx, 0, 1, 0, alpha);
                else if ([value isEqualToString: GCGameValueLose])
                    CGContextSetRGBFillColor(ctx, 139.0f / 255.0f, 0, 0, alpha);
                else if ([value isEqualToString: GCGameValueTie])
                    CGContextSetRGBFillColor(ctx, 1, 1, 0, alpha);
                
                CGContextFillRect(ctx, valueRect);
            }
        }
        
        for (int j = 0; j < position.rows; j += 1)
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
