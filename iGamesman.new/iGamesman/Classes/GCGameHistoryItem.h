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
    GCPosition *position;
    GCMove *move;
}

- (id) initWithPosition: (GCPosition *) position
                andMove: (GCMove *) move;

- (GCPosition *) position;
- (GCMove *) move;

@end
