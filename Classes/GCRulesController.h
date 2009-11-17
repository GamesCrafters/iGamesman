//
//  GCRulesController.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/16/09.
//  Copyright 2009 Kevin Jorgensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RulesDelegate;

@interface GCRulesController : UITableViewController {
	id <RulesDelegate> delegate;
	id gameOptions;
}

@property (nonatomic, assign) id <RulesDelegate> delegate;

- (id) initWithGameName: (NSString *) name;

@end


@protocol RulesDelegate

- (void) rulesPanelDidCancel;

@end

