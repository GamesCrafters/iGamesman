//
//  GCConnectionsView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/20/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConnectionsView.h"

#import "GCConnectionsPosition.h"

@implementation GCConnectionsView

@synthesize delegate;


#pragma mark - Memory lifecycle

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.opaque = NO;
        self.clipsToBounds = NO;
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
    
    GCConnectionsPosition *position = [delegate position];
    
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.size;
    CGFloat maxCellHeight = height / position.size;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.size) / 2.0f;
    CGFloat minY = CGRectGetMinY(self.bounds) + (height - cellSize * position.size) / 2.0f;
    
    CGRect boardRect = CGRectMake(minX, minY, cellSize * position.size, cellSize * position.size);
    boardRect = CGRectInset(boardRect, (cellSize * 0.2f) + 2, (cellSize * 0.2f) + 2);
    
    /* Recompute minX/Y and cellSize to fit */
    maxCellWidth  = boardRect.size.width / position.size;
    maxCellHeight = boardRect.size.height / position.size;
    cellSize = MIN(maxCellWidth, maxCellHeight);
    minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.size) / 2.0f;
    minY = CGRectGetMinY(self.bounds) + (height - cellSize * position.size) / 2.0f;
    
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    
    for (int col = 0; col < position.size; col += 1)
    {
        for (int row = 0; row < position.size; row += 1)
        {
            NSArray *moves = [delegate generateMoves];
            
            BOOL isLegalSquare = [moves containsObject: [NSNumber numberWithInt: row * position.size + col + 1]];
            
            if (!isLegalSquare)
                continue;
            
            CGRect cellRect = CGRectMake(minX + col * cellSize, minY + row * cellSize, cellSize, cellSize);
            cellRect = CGRectInset(cellRect, -(cellSize * 0.2f), -(cellSize * 0.2f));
            
#warning TODO: Improve this logic. Should check the octagonal area, not the bounding rectangle (overlapping!)
            if (CGRectContainsPoint(cellRect, location))
            {
                [delegate userChoseMove: [NSNumber numberWithInt: row * position.size + col + 1]];
                return;
            }
        }
    }
}


#pragma mark - Drawing

- (void) fillOctagonInRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat insetWidth = width / (2 + sqrt(2));
    CGFloat insetHeight = height / (2 + sqrt(2));
    
    
    CGContextMoveToPoint(ctx, minX + insetWidth, minY);
    CGContextAddLineToPoint(ctx, maxX - insetWidth, minY);
    CGContextAddLineToPoint(ctx, maxX, minY + insetHeight);
    CGContextAddLineToPoint(ctx, maxX, maxY - insetHeight);
    CGContextAddLineToPoint(ctx, maxX - insetWidth, maxY);
    CGContextAddLineToPoint(ctx, minX + insetWidth, maxY);
    CGContextAddLineToPoint(ctx, minX, maxY - insetHeight);
    CGContextAddLineToPoint(ctx, minX, minY + insetHeight);
    CGContextAddLineToPoint(ctx, minX + insetWidth, minY);
    
    CGContextFillPath(ctx);
    
    
    CGContextMoveToPoint(ctx, minX + insetWidth, minY);
    CGContextAddLineToPoint(ctx, maxX - insetWidth, minY);
    CGContextAddLineToPoint(ctx, maxX, minY + insetHeight);
    CGContextAddLineToPoint(ctx, maxX, maxY - insetHeight);
    CGContextAddLineToPoint(ctx, maxX - insetWidth, maxY);
    CGContextAddLineToPoint(ctx, minX + insetWidth, maxY);
    CGContextAddLineToPoint(ctx, minX, maxY - insetHeight);
    CGContextAddLineToPoint(ctx, minX, minY + insetHeight);
    CGContextAddLineToPoint(ctx, minX + insetWidth, minY);
    
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    CGContextSetLineWidth(ctx, 2);
    CGContextStrokePath(ctx);
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
    
    GCConnectionsPosition *position = [delegate position];
    
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat maxCellWidth  = width / position.size;
    CGFloat maxCellHeight = height / position.size;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.size) / 2.0f;
    CGFloat minY = CGRectGetMinY(self.bounds) + (height - cellSize * position.size) / 2.0f;
    
    CGRect boardRect = CGRectMake(minX, minY, cellSize * position.size, cellSize * position.size);
    boardRect = CGRectInset(boardRect, (cellSize * 0.2f) + 2, (cellSize * 0.2f) + 2);
    
    /* Recompute minX/Y and cellSize to fit */
    maxCellWidth  = boardRect.size.width / position.size;
    maxCellHeight = boardRect.size.height / position.size;
    cellSize = MIN(maxCellWidth, maxCellHeight);
    minX = CGRectGetMinX(self.bounds) + (width - cellSize * position.size) / 2.0f;
    minY = CGRectGetMinY(self.bounds) + (height - cellSize * position.size) / 2.0f;
    
    
    
    for (int col = 0; col < position.size; col += 1)
    {
        for (int row = 0; row < position.size; row += 1)
        {
            CGRect cellRect = CGRectMake(minX + col * cellSize, minY + row * cellSize, cellSize, cellSize);
            
            if ((row % 2) == (col % 2))
            {
                int size = position.size;
                if (!((row == 0 && col == 0) || (row == 0 && col == size - 1) || (row == size - 1 && col == 0) || (row == size - 1 && col == size - 1)))
                {
                    NSArray *moves = [delegate generateMoves];
                    
                    BOOL isLegalSquare = [moves containsObject: [NSNumber numberWithInt: row * position.size + col + 1]];
                    
                    if (isLegalSquare)
                        CGContextSetRGBFillColor(ctx, 0, 1, 1, 1);
                    else
                        CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1);
                    
                    [self fillOctagonInRect: CGRectInset(cellRect, -(cellSize * 0.2f), -(cellSize * 0.2f))];
                }
            }
        }
    }
    
    for (int col = 0; col < position.size; col += 1)
    {
        for (int row = 0; row < position.size; row += 1)
        {
            CGRect cellRect = CGRectMake(minX + col * cellSize, minY + row * cellSize, cellSize, cellSize);
            
            if ((row % 2) == (col % 2))
            {              
                if ([[position.board objectAtIndex: col + row * position.size] isEqual: GCConnectionsRedPiece])
                {
                    CGRect pieceRect;
                    if ((col % 2) == 1)
                        pieceRect = CGRectInset(cellRect, cellSize * 0.3f, -(cellSize * 0.21f));
                    else
                        pieceRect = CGRectInset(cellRect, -(cellSize * 0.21f), cellSize * 0.3f);
                    
                    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
                    CGContextFillRect(ctx, pieceRect);
                }
                else if ([[position.board objectAtIndex: col + row * position.size] isEqual: GCConnectionsBluePiece])
                {
                    CGRect pieceRect;
                    if ((col % 2) == 1)
                        pieceRect = CGRectInset(cellRect, -(cellSize * 0.21f), cellSize * 0.3f);
                    else
                        pieceRect = CGRectInset(cellRect, cellSize * 0.3f, -(cellSize * 0.21f));
                    
                    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
                    CGContextFillRect(ctx, pieceRect);
                }
            }
            else if ((col % 2) == 0)
            {
                CGFloat insetWidth = cellSize * 0.19f;
                CGFloat insetHeight = cellSize * 0.19f;
                
                CGRect spotRect = CGRectInset(cellRect, insetWidth, insetHeight);
                
                CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
                CGContextFillRect(ctx, spotRect);
            }
            else
            {
                CGFloat insetWidth = cellSize * 0.19f;
                CGFloat insetHeight = cellSize * 0.19f;
                
                CGRect spotRect = CGRectInset(cellRect, insetWidth, insetHeight);
                
                CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
                CGContextFillRect(ctx, spotRect);
            }
        }
    }
}

@end
