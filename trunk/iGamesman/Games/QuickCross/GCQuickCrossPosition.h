//
//  GCQuickCrossPosition.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *GCQuickCrossPiece;

GCQuickCrossPiece const GCQuickCrossBlankPiece;
GCQuickCrossPiece const GCQuickCrossHorizontalPiece;
GCQuickCrossPiece const GCQuickCrossVerticalPiece;


typedef NSString *GCQuickCrossMove;

GCQuickCrossMove const GCQuickCrossSpinMove;
GCQuickCrossMove const GCQuickCrossPlaceHorizontalMove;
GCQuickCrossMove const GCQuickCrossPlaceVerticalMove;


@interface GCQuickCrossPosition : NSObject <NSCopying>
{
    NSUInteger _rows;
    NSUInteger _columns;
    NSUInteger _toWin;
    
    BOOL _leftTurn;
    
    NSMutableArray *_board;
}

@property (nonatomic, readonly) NSUInteger rows, columns, toWin;
@property (nonatomic, assign) BOOL leftTurn;
@property (nonatomic, retain) NSMutableArray *board;

- (id) initWithWidth: (NSUInteger) width
              height: (NSUInteger) height
               toWin: (NSUInteger) needed;

@end
