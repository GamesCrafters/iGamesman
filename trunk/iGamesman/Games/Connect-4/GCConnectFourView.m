//
//  GCConnectFourView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConnectFourView.h"

#import "GCConnectFourPieceView.h"
#import "GCConnectFourPosition.h"

@implementation GCConnectFourView

@synthesize delegate;
@synthesize backgroundCenter;


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
            
            [newPieceView setTag: 10000 + slot];
            [self addSubview: newPieceView];
            [self sendSubviewToBack: newPieceView];
            
            [UIView animateWithDuration: 0.25f animations: ^{ [newPieceView setFrame: destinationFrame]; } ];
            
            [newPieceView release];
            
            return;
        }
    }
}


- (void) undoMove: (NSNumber *) column
{
    GCConnectFourPosition *position = [delegate position];
    
    CGFloat height = self.bounds.size.height;
    
    CGFloat halfWidth  = backgroundCenter.x - self.bounds.origin.x;
    CGFloat halfHeight = self.bounds.origin.y + height - backgroundCenter.y;
    
    CGFloat maxCellWidth  = (2 * halfWidth) / position.columns;
    CGFloat maxCellHeight = (2 * halfHeight) / position.rows;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    
    minX += (backgroundCenter.x - cellSize * position.columns / 2.0f);
    
    
    NSUInteger col = [column unsignedIntegerValue];
    
    for (int row = position.rows - 1; row >= 0; row -= 1)
    {
        NSUInteger slot = row * position.columns + col;
        
        if (![[position.board objectAtIndex: slot] isEqual: GCConnectFourBlankPiece])
        {
            CGRect destinationFrame = CGRectMake(minX + col * cellSize, -cellSize, cellSize, cellSize);
            
            GCConnectFourPieceView *pieceView = (GCConnectFourPieceView *) [self viewWithTag: 10000 + slot];
            
            [UIView animateWithDuration: 0.25f animations: ^{ [pieceView setFrame: destinationFrame]; } completion: ^(BOOL done) { [pieceView removeFromSuperview]; }];
            
            return;
        }
    }
}


#pragma mark - Touch capture

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    GCConnectFourPosition *position = [delegate position];
    
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
    
    CGFloat height = self.bounds.size.height;
    
    CGFloat halfWidth  = backgroundCenter.x - self.bounds.origin.x;
    CGFloat halfHeight = self.bounds.origin.y + height - backgroundCenter.y;
    
    CGFloat maxCellWidth  = (2 * halfWidth) / position.columns;
    CGFloat maxCellHeight = (2 * halfHeight) / position.rows;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    
    minX += (backgroundCenter.x - cellSize * position.columns / 2.0f);
    
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
    CGContextFillEllipseInRect(ctx, CGRectMake(backgroundCenter.x - 5, backgroundCenter.y - 5, 10, 10));
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
    CGContextFillRect(ctx, self.bounds);
#endif
    
    
    GCConnectFourPosition *position = [delegate position];
    
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
    
    for (int i = 0; i < position.columns; i += 1)
    {
        for (int j = 0; j < position.rows; j += 1)
        {
            CGMutablePathRef path = CGPathCreateMutable();
            CGRect rect = CGRectMake(minX + cellSize * i, minY + cellSize * j, cellSize, cellSize);
            /* Expand rectangle by a pixel to overlap them */
            rect = CGRectInset(rect, -1, -1);
            
            /* Add the outer (square) boundary */
            CGPathAddRect(path, NULL, rect);
            /* Add the inner (circular) boundary */
            CGPathAddEllipseInRect(path, NULL, CGRectInset(rect, cellSize * 0.15f, cellSize * 0.15f));
            CGContextAddPath(ctx, path);
            
            /* Fill according to the even-odd rule */
            CGContextSetRGBFillColor(ctx, 0.5f, 0.5f, 0.5f, 1);
            CGContextEOFillPath(ctx);
            
            CGPathRelease(path);
        }
    }
}


@end
