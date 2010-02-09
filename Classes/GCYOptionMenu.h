//
//  GCYOptionMenu.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCRulesDelegate.h"
#import "GCOptionMenu.h"

@class GCYGame;


@interface GCYOptionMenu : UITableViewController <GCOptionMenu> {
	id <GCRulesDelegate> delegate;
}

@property (nonatomic, retain) id <GCRulesDelegate> delegate;

- (id) initWithGame: (GCYGame *) _game;
- (void) cancel;
- (void) done;

@end
