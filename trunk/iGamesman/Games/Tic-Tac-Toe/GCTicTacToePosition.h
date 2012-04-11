//
//  GCTicTacToePosition.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *GCTTTPiece;

GCTTTPiece const GCTTTBlankPiece;
GCTTTPiece const GCTTTXPiece;
GCTTTPiece const GCTTTOPiece;

@interface GCTicTacToePosition : NSObject <NSCopying>
{
    NSUInteger _columns;
    NSUInteger _rows;
    NSUInteger _toWin;
    
    BOOL _leftTurn;
    
    BOOL _misere;
    
    NSMutableArray *_board;
}

@property (nonatomic, readonly) NSUInteger columns, rows, toWin;
@property (nonatomic, assign) BOOL leftTurn;
@property (nonatomic, retain) NSMutableArray *board;
@property (nonatomic, assign, getter = isMisere) BOOL misere;

- (id) initWithWidth: (NSUInteger) width
              height: (NSUInteger) height
               toWin: (NSUInteger) needed;


@end
