//
//  GCGameListController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/12/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Lists the games avaiable for play. Tapping on a game takes the user
 to that game's menu.
 */
@interface GCGameListController : UITableViewController {
	NSArray *gameNames;  ///< An array of game names
	NSDictionary *games; ///< A dictionary of game objects, keyed on the game names
}

@end
