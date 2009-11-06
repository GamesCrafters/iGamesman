//
//  GCGameMenuController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/14/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGameViewController.h"


@interface GCGameMenuController : UITableViewController <FlipsideViewControllerDelegate> {
	NSArray *cellLabels;
}

- (id)initWithGame: (id) game andName: (NSString *) gameName;

@end
