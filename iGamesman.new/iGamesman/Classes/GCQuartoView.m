//
//  GCQuartoView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCQuartoView.h"

#define GRID_SPACING (5)


@implementation GCQuartoView

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


- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawBoardIntoContext: ctx];
}

@end
