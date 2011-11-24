//
//  GCGameHistoryItem.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/23/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

@interface GCGameHistoryItem : NSObject
{
    Position position;
    Move move;
}

- (id) initWithPosition: (Position) position
                andMove: (Move) move;

- (Position) position;
- (Move) move;

@end
