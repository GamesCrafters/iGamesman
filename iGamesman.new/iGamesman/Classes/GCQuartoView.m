//
//  GCQuartoView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCQuartoView.h"

#define GRID_SPACING (5)


@interface GCQuartoView ()

- (void) drawPhoneInterfaceIntoContext: (CGContextRef) ctx;
- (void) drawPadInterfaceIntoContext: (CGContextRef) ctx;

@end


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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            boardFrame = CGRectMake(bottomRight.x - ((5.0f / 6.0f) * height), height / 6.0f, (5.0f / 6.0f) * height, (5.0f / 6.0f) * height);
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            boardFrame = CGRectMake(bottomRight.x - ((3.0f / 4.0f) * height), height / 4.0f, (3.0f / 4.0f) * height, (3.0f / 4.0f) * height);
        }
        else
        {
            NSAssert(false, @"Invalid User Interface Idiom! (Should never get here!)");
        }
        
        self.opaque = NO;
    }
    return self;
}


- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIUserInterfaceIdiom idiom = UI_USER_INTERFACE_IDIOM();
    
    if (idiom == UIUserInterfaceIdiomPhone)
    {
        [self drawPhoneInterfaceIntoContext: ctx];
    }
    else if (idiom == UIUserInterfaceIdiomPad)
    {
        [self drawPadInterfaceIntoContext: ctx];
    }
    else
    {
        NSAssert(false, @"Invalid User Interface Idiom! (Should never get here!)");
    }
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
}


- (void) drawPhoneInterfaceIntoContext: (CGContextRef) ctx
{
    [self drawBoardIntoContext: ctx];
    
    CGImageRef platformImage = [[UIImage imageNamed: @"quartoPlatform"] CGImage];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGPoint topLeft = self.bounds.origin;
    CGPoint bottomRight = CGPointMake(topLeft.x + width, topLeft.y + height);
    
    CGContextDrawImage(ctx, CGRectMake(bottomRight.x - boardFrame.size.width - height / 6.0f, 0, height / 6.0f, height / 6.0f), platformImage);
}


- (void) drawPadInterfaceIntoContext: (CGContextRef) ctx
{
    [self drawBoardIntoContext: ctx];
    
    CGImageRef platformImage = [[UIImage imageNamed: @"quartoPlatform"] CGImage];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGPoint topLeft = self.bounds.origin;
    CGPoint bottomRight = CGPointMake(topLeft.x + width, topLeft.y + height);
    
    CGContextDrawImage(ctx, CGRectMake(bottomRight.x - boardFrame.size.width - height / 4.0f, 0, height / 4.0f, height / 4.0f), platformImage);
}

@end
