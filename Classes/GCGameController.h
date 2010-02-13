//
//  GCGameController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/10/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"


@interface GCGameController : NSObject {
	GCGame *game;
	BOOL turn;
}

- (id) initWithGame: (GCGame *) _game;
- (void) go;
- (void) takeHumanTurn;

@end
