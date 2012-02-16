//
//  GCConnectFourPosition.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *GCConnectFourPiece;

GCConnectFourPiece const GCConnectFourBlankPiece;
GCConnectFourPiece const GCConnectFourRedPiece;
GCConnectFourPiece const GCConnectFourBluePiece;

@interface GCConnectFourPosition : NSObject <NSCopying>
{
    NSUInteger columns;
    NSUInteger rows;
    NSUInteger toWin;
    
    BOOL leftTurn;
    
    NSMutableArray *board;
}

@property (nonatomic, readonly) NSUInteger columns, rows, toWin;
@property (nonatomic, assign) BOOL leftTurn;
@property (nonatomic, retain) NSMutableArray *board;

- (id) initWithWidth: (NSUInteger) width
              height: (NSUInteger) height
               toWin: (NSUInteger) needed;

@end
