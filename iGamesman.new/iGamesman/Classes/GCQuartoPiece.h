//
//  GCQuartoPiece.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCQuartoPiece : NSObject
{
    int pieceNumber;
}


+ (id) pieceWithSquare: (BOOL) isSquare 
                 solid: (BOOL) isSolid 
                  tall: (BOOL) isTall 
                 white: (BOOL) isWhite;

+ (id) blankPiece;


- (BOOL) isBlank;
- (BOOL) isSquare;
- (BOOL) isSolid;
- (BOOL) isTall;
- (BOOL) isWhite;

@end
