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
	int width;						///< The number of columns
	int height;						///< The number of rows
	int pieces;						///< The number in a row needed to win
}

/// The designated initializer
- (id) initWithGame: (GCConnectFour *) _game;

@end
