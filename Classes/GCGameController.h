//
//  GCGameController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/10/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"
#ifndef GCGameViewController
#import "GCGameViewController.h"
#endif

@class GCGameViewController;


@interface GCGameController : NSObject {
	GCGame *game;
	GCGameViewController *viewController;
	NSThread *runner;
	BOOL turn;
	BOOL stopped;
	id computerMove;
	int position;
}

@property (nonatomic, assign, readonly) BOOL stopped;

- (id) initWithGame: (GCGame *) _game andViewController: (GCGameViewController *) viewControl;
- (void) go;
- (void) goGameReady;
- (void) stop;
- (void) restart;
- (void) takeHumanTurn;
- (void) takeComputerTurn;

@end
