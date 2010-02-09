//
//  GCGameMenuController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGame.h"
#import "GCNameChangeController.h"
#import "GCRulesDelegate.h"
#import "GCGameViewController.h"


@interface GCGameMenuController : UITableViewController <NameChangeDelegate, GCRulesDelegate, FlipsideViewControllerDelegate> {
	GCGame *game;
	NSArray *section0, *section1;
}

- (id)initWithGame: (GCGame *) _game andName: (NSString *) gameName;

@end
