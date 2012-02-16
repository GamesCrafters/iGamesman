//
//  GCQuartoPiece.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCQuartoPiece : NSObject <NSCopying>
{
    BOOL tall, square, hollow, white;
    
    BOOL blank;
}

@property (nonatomic, readonly) BOOL tall, square, hollow, white;
@property (nonatomic, readonly) BOOL blank;


+ (id) pieceWithTall: (BOOL) isTall square: (BOOL) isSquare hollow: (BOOL) isHollow white: (BOOL) isWhite;
+ (id) blankPiece;

@end
