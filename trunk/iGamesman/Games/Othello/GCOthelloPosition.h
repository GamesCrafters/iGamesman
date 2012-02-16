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
    NSUInteger rows;
    NSUInteger columns;
    
    BOOL leftTurn;
    
    NSMutableArray *board;
}

@property (nonatomic, assign) NSUInteger rows, columns;
@property (nonatomic, assign) BOOL leftTurn;
@property (nonatomic, retain) NSMutableArray *board;

- (id) initWithWidth: (NSUInteger) width 
              height: (NSUInteger) height;

- (NSUInteger) numberOfBlackPieces;
- (NSUInteger) numberOfWhitePieces;

@end
