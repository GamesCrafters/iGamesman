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
	NSMutableArray *moveStack, *undoStack;
	NSMutableArray *dataHistoryStack, *dataUndoStack;
	NSThread *runner;
	BOOL turn;
	BOOL stopped;
	id computerMove;
	int position, maxPosition;
	float DELAY;
}

@property (nonatomic, assign, readonly) BOOL stopped;
@property (nonatomic, assign) float DELAY;
@property (nonatomic, assign) int position, maxPosition;

- (id) initWithGame: (GCGame *) _game andViewController: (GCGameViewController *) viewControl;
- (void) undo;
- (void) redo;
- (void) go;
- (void) goGameReady;
- (void) end;
- (void) stop;
- (void) restart;
- (void) takeHumanTurn;
- (void) takeComputerTurn;

@end
