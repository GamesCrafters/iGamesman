//
//  GCOthelloOptionMenu.h
//  GamesmanMobile
//
//  Created by Class Account on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCOthello.h"
#import "GCOptionMenu.h"
#import "GCRulesDelegate.h"


@interface GCOthelloOptionMenu : UITableViewController <GCOptionMenu> {
	id <GCRulesDelegate> delegate;
	GCOthello *game;
	int rows, cols;
	BOOL misere;
}

@property (nonatomic, assign) id <GCRulesDelegate> delegate;


- (id) initWithGame: (GCOthello *) _game;
- (void) cancel;
- (void) done;
- (void) update: (UISegmentedControl *) sender;


@end
