//
//  GCGameController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/22/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCGame;

@interface GCGameController : NSObject
{
    id<GCGame> game;
}

- (id) initWithGame: (id<GCGame>) game;

- (void) go;

@end
