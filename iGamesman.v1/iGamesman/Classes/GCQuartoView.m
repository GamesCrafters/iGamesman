//
//  GCQuartoView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCQuartoView.h"

#import "GCQuartoPiece.h"
#import "GCQuartoPosition.h"

#define GRID_SPACING (5)


@implementation GCQuartoView

@synthesize delegate;


- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGPoint topLeft = self.bounds.origin;
        CGPoint bottomRight = CGPointMake(topLeft.x + width, topLeft.y + height);
        
        boardFrame = CGRectMake(bottomRight.x - ((4.0f / 5.0f) * height), height / 5.0f, (4.0f / 5.0f) * height, (4.0f / 5.0f) * height);
        
        self.opaque = NO;
    }
    return self;
}


- (void) drawBoardIntoContext: (CGContextRef) ctx
{
    CGImageRef image = [[UIImage imageNamed: @"quartoBoard"] CGImage];
    
    CGContextDrawImage(ctx, boardFrame, image);
    
    
    CGFloat boardWidth = boardFrame.size.width;
    CGFloat boardHeight = boardFrame.size.height;
    CGFloat cellWidth = (boardWidth - 5 * GRID_SPACING) / 4.0f;
    CGFloat cellHeight = (boardHeight - 5 * GRID_SPACING) / 4.0f;
    
    for (int i = 0; i < 16; i += 1)
    {
        int row = i / 4;
        int col = i % 4;
        
        CGRect cellFrame = CGRectMake(boardFrame.origin.x + GRID_SPACING + col * (cellWidth + GRID_SPACING),
                                      boardFrame.origin.y + GRID_SPACING + row * (cellHeight + GRID_SPACING), 
                                      cellWidth,
                                      cellHeight);
        
        CGImageRef image = [[UIImage imageNamed: [NSString stringWithFormat: @"quartoSquare%d", i]] CGImage];
        
        CGContextDrawImage(ctx, cellFrame, image);
    }
    
    CGImageRef platformImage = [[UIImage imageNamed: @"quartoPlatform"] CGImage];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGPoint topLeft = self.bounds.origin;
    CGPoint bottomRight = CGPointMake(topLeft.x + width, topLeft.y + height);
    
    CGContextDrawImage(ctx, CGRectMake(bottomRight.x - boardWidth - height / 5.0f, 0, height / 5.0f, height / 5.0f), platformImage);
}


- (void) drawPiece: (GCQuartoPiece *) piece intoContext: (CGContextRef) ctx inRect: (CGRect) rect
{
    CGFloat alpha = ([piece isSolid] ? 1.0f : 0.5f);
    
    if ([piece isWhite])
        CGContextSetRGBFillColor(ctx, 1, 1, 1, alpha);
    else
        CGContextSetRGBFillColor(ctx, 0, 0, 0, alpha);
    
    CGRect pieceRect = CGRectInset(rect, rect.size.width * 0.2f, rect.size.height * 0.2f);
    
    if ([piece isSquare])
    {
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathAddRect(path, NULL, pieceRect);
        CGPathCloseSubpath(path);
        
        if (![piece isTall])
        {
            CGPathAddRect(path, NULL, CGRectInset(pieceRect, pieceRect.size.width * 0.3f, pieceRect.size.height * 0.3f));
            CGPathCloseSubpath(path);
        }
        
        CGContextAddPath(ctx, path);
        
        CGPathRelease(path);
        
        CGContextEOFillPath(ctx);
    }
    else
    {
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathAddEllipseInRect(path, NULL, pieceRect);
        CGPathCloseSubpath(path);
        
        if (![piece isTall])
        {
            CGPathAddEllipseInRect(path, NULL, CGRectInset(pieceRect, pieceRect.size.width * 0.3f, pieceRect.size.height * 0.3f));
            CGPathCloseSubpath(path);
        }
        
        CGContextAddPath(ctx, path);
        
        CGPathRelease(path);
        
        CGContextEOFillPath(ctx);
    }
}


- (void) drawPosition: (GCQuartoPosition *) position intoContext: (CGContextRef) ctx
{
    CGRect piecesRect = CGRectMake(self.bounds.origin.x, boardFrame.origin.y + 20, self.bounds.size.width - boardFrame.size.width - 20, self.bounds.size.width - boardFrame.size.width - 20);
    CGPoint piecesOrigin = piecesRect.origin;
    CGSize piecesSize = piecesRect.size;
    CGFloat cellWidth = piecesSize.width / 4.0f;
    CGFloat cellHeight = piecesSize.height / 4.0f;
    
    for (int i = 0; i < 16; i += 1)
    {
        BOOL square = (i >> 0) & 1;
        BOOL solid  = (i >> 1) & 1;
        BOOL tall   = (i >> 2) & 1;
        BOOL white  = (i >> 3) & 1;
        
        int row = i / 4;
        int column = i % 4;
        
        GCQuartoPiece *piece = [GCQuartoPiece pieceWithSquare: square solid: solid tall: tall white: white];
        if ([[position availablePieces] containsObject: piece])
        {
            [self drawPiece: piece intoContext: ctx inRect: CGRectMake(piecesOrigin.x + column * cellWidth,
                                                                       piecesOrigin.y + row * cellHeight,
                                                                       cellWidth,
                                                                       cellHeight)];
        }
    }
}


- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawBoardIntoContext: ctx];
    
    [self drawPosition: [delegate currentPosition] intoContext: ctx];
}

@end
