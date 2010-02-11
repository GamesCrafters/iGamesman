//
//  GCConnectFourViewController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCConnectFour.h"


@interface GCConnectFourViewController : UIViewController {
	GCConnectFour *game;			///< The Connect-4 controlling object for this VC
	int width;						///< The number of columns
	int height;						///< The number of rows
	int pieces;						///< The number in a row needed to win
}

/// The designated initializer
- (id) initWithGame: (GCConnectFour *) _game;

/// Receiver of button taps. Simply converts the button into a move and sends it to GAME
- (void) tapped: (UIButton *) sender;
- (void) doMove: (NSString *) move;
- (void) disableButtons;
- (void) enableButtons;

@end
