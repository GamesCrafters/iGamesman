//
//  GCCreditsController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 11/24/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The view controller for the credits screen
 */
@interface GCCreditsController : UITableViewController {
	NSArray *headers; ///< An array containing the section headers
	NSArray *info;	  ///< An array containing the table data
}

@end
