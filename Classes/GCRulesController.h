//
//  GCRulesController.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/16/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCRulesDelegate.h"

@interface GCRulesController : UITableViewController {
	id <GCRulesDelegate> delegate;
	id gameOptions;
}

@property (nonatomic, assign) id <GCRulesDelegate> delegate;

- (id) initWithGameName: (NSString *) name andGameOptions: (id) _gameOptions;
- (void) done;

@end

