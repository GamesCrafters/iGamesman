//
//  NewGameOptionMenu.h
//  Gamesman
//
//  Created by AUTHOR_NAME on MM/DD/YYYY.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCOptionMenu.h"
#import "GCRulesDelegate.h"


@interface NewGameOptionMenu : UITableViewController <GCOptionMenu> {
	id <GCRulesDelegate> delegate;
}

// Add methods for retrieving particular option choices

@end
