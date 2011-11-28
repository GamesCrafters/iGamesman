//
//  GCTicTacToeView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCTicTacToeView.h"

#import "GCPlayer.h"
#import "GCTicTacToePosition.h"

@implementation GCTicTacToeView

@synthesize delegate;

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.opaque = NO;
        
        acceptingTouches = NO;
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        CGFloat labelHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 30 : 60;
        
        UIFont *font = [UIFont systemFontOfSize: (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 16 : 24];
        
        messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, height - labelHeight, width, labelHeight)];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = UITextAlignmentCenter;
        messageLabel.font = font;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = @"";
        
        [self addSubview: messageLabel];
    }
    return self;
}


- (void) dealloc
{
    [messageLabel release];
    
    [super dealloc];
}


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
    
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        height -= 30;
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        height -= 60;
    
    GCTicTacToePosition *position = [delegate position];
    
    CGFloat maxCellWidth = width / position.columns;
    CGFloat maxCellHeight = height / position.rows;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    
    minX += ((width - (position.columns * cellSize)) / 2.0f);
    
    for (int row = 0; row < position.rows; row += 1)
    {
        for (int column = 0; column < position.columns; column += 1)
        {
            CGRect cellRect = CGRectMake(minX + column * cellSize,
                                         minY + row * cellSize,
                                         cellSize,
                                         cellSize);
            if (CGRectContainsPoint(cellRect, location))
            {
                NSNumber *slotNumber = [NSNumber numberWithInt: row * position.columns + column];
                if ([[position.board objectAtIndex: slotNumber.unsignedIntegerValue] isEqualToString: GCTTTBlankPiece])
                    [delegate userChoseMove: slotNumber];
            }
        }
    }
}


- (void) drawXInRect: (CGRect) rect intoContext: (CGContextRef) ctx
{
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
    CGContextSetLineWidth(ctx, rect.size.width * 0.1f);
    
    CGFloat insetX = rect.size.width * 0.15f;
    CGFloat insetY = rect.size.height * 0.15f;
    
    CGRect insetRect = CGRectInset(rect, insetX, insetY);
    
    CGFloat minX = CGRectGetMinX(insetRect);
    CGFloat minY = CGRectGetMinY(insetRect);
    CGFloat maxX = CGRectGetMaxX(insetRect);
    CGFloat maxY = CGRectGetMaxY(insetRect);
    
    CGContextMoveToPoint(ctx, minX, minY);
    CGContextAddLineToPoint(ctx, maxX, maxY);
    
    CGContextMoveToPoint(ctx, minX, maxY);
    CGContextAddLineToPoint(ctx, maxX, minY);
    
    CGContextStrokePath(ctx);
}


- (void) drawOInRect: (CGRect) rect intoContext: (CGContextRef) ctx
{
    CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
    CGContextSetLineWidth(ctx, rect.size.width * 0.1f);
    
    CGFloat insetX = rect.size.width * 0.15f;
    CGFloat insetY = rect.size.height * 0.15f;
    
    CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, insetX, insetY));
}


- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    GCTicTacToePosition *position = [delegate position];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        height -= 30;
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        height -= 60;
    
    CGFloat maxCellWidth = width / position.columns;
    CGFloat maxCellHeight = height / position.rows;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    
    minX += ((width - (position.columns * cellSize)) / 2.0f);
    
    for (int i = 1; i < position.columns; i += 1)
    {
        CGContextMoveToPoint(ctx, minX + i * cellSize, minY);
        CGContextAddLineToPoint(ctx, minX + i * cellSize, minY + position.rows * cellSize);
    }
    
    for (int j = 1; j < position.rows; j += 1)
    {
        CGContextMoveToPoint(ctx, minX, minY + j * cellSize);
        CGContextAddLineToPoint(ctx, minX + position.columns * cellSize, minY + j * cellSize);
    }
    
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, width * 0.01f);
    CGContextStrokePath(ctx);
    
    
    for (int i = 0; i < [position.board count]; i += 1)
    {
        GCTTTPiece piece = [position.board objectAtIndex: i];
        
        NSUInteger row = i / position.columns;
        NSUInteger column = i % position.columns;
        
        CGRect cellRect = CGRectMake(minX + column * cellSize, minY + row * cellSize, cellSize, cellSize);
        
        if (piece == GCTTTXPiece)
            [self drawXInRect: cellRect intoContext: ctx];
        else if (piece == GCTTTOPiece)
            [self drawOInRect: cellRect intoContext: ctx];
    }
    
    
    /* Update the label */
    NSString *playerName, *otherPlayerName;
    NSString *playerColor, *otherPlayerColor;
    if (position.leftTurn)
    {
        playerName = [[delegate leftPlayer] name];
        playerColor = @"X";
        
        otherPlayerName = [[delegate rightPlayer] name];
        otherPlayerColor = @"O";
    }
    else
    {
        playerName = [[delegate rightPlayer] name];
        playerColor = @"O";
        
        otherPlayerName = [[delegate leftPlayer] name];
        otherPlayerColor = @"X";
    }
    
    
    GCGameValue *value = [delegate primitive];
    if (value != nil)
    {
        NSString *winner, *winnerColor;
        if ([value isEqualToString: GCGameValueWin])
        {
            winner = playerName;
            winnerColor = playerColor;
        }
        else if ([value isEqualToString: GCGameValueLose])
        {
            winner = otherPlayerName;
            winnerColor = otherPlayerColor;
        }
        
        if ([value isEqualToString: GCGameValueTie])
            messageLabel.text = @"It's a tie!";
        else
            messageLabel.text = [NSString stringWithFormat: @"%@ (%@) wins!", winner, winnerColor];
    }
    else
    {
        messageLabel.text = [NSString stringWithFormat: @"%@ (%@)'s turn", playerName, playerColor];
    }
}

@end
