//
//  GCQuickCrossOptionMenu.h
//  GamesmanMobile
//
//  Created by Andrew Zhai and Chih Hu on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCQuickCross.h"
#import "GCOptionMenu.h"
#import "GCRulesDelegate.h"

@interface GCQuickCrossOptionMenu : UITableViewController <GCOptionMenu> {
	GCQuickCross *game;	
	int width, height, pieces;
	BOOL misere;
	NSArray *headings;
	id <GCRulesDelegate> delegate;
}

@property (nonatomic, assign) id <GCRulesDelegate> delegate;

- (id) initWithGame: (GCQuickCross *) _game;
- (void) cancel;
- (void) done;
- (void) update: (UISegmentedControl *) sender;

@end
