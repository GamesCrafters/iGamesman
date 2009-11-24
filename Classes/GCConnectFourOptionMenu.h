//
//  GCConnectFourOptionMenu.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/18/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCOptionMenu.h"
#import "GCRulesDelegate.h"


@interface GCConnectFourOptionMenu : UITableViewController <GCOptionMenu> {
	id <GCRulesDelegate> delegate;
	NSArray *headings;
	NSMutableDictionary *currentlySelectedOptions;
}

- (int) getWidth;
- (int) getHeight;
- (int) getPieces;

@end

