//
//  GCOthelloPosition.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/21/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *GCOthelloPiece;

GCOthelloPiece const GCOthelloBlankPiece;
GCOthelloPiece const GCOthelloBlackPiece;
GCOthelloPiece const GCOthelloWhitePiece;

@interface GCOthelloPosition : NSObject <NSCopying>
{
    NSUInteger _rows;
    NSUInteger _columns;
    
    BOOL _leftTurn;
    
    NSMutableArray *_board;
    
    BOOL _misere;
}

@property (nonatomic, assign) NSUInteger rows, columns;
@property (nonatomic, assign) BOOL leftTurn;
@property (nonatomic, retain) NSMutableArray *board;
@property (nonatomic, assign, getter = isMisere) BOOL misere;

- (id) initWithWidth: (NSUInteger) width 
              height: (NSUInteger) height;

- (NSUInteger) numberOfBlackPieces;
- (NSUInteger) numberOfWhitePieces;

@end
