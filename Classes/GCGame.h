//
//  GCGame.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/19/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCOptionMenu.h"
#import "GCGameView.h"


@protocol GCGame

- (UIViewController<GCOptionMenu> *) getOptionMenu;
- (UIViewController<GCGameView> *) getGameViewController;
- (NSString *) player1Name;
- (NSString *) player2Name;
- (void) setPlayer1Name:(NSString *) name;
- (void) setPlayer2Name:(NSString *) name;

@end
