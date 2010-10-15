//
//  GCTicTacToeViewController.h
//  GamesmanMobile
//
//  Created by Class Account on 10/8/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTicTacToe.h"


@interface GCTicTacToeViewController : UIViewController {
	GCTicTacToe *game;
}

- (id) initWithGame: (GCTicTacToe *) _game;
- (void) doMove: (NSNumber *) move;

@end
