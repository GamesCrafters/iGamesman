//
//  GCQuickCrossViewController.h
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCQuickCross.h"


@interface GCQuickCrossViewController : UIViewController {
	GCQuickCross *game;
	
	UILabel *messageLabel;
	
	BOOL touchesEnabled;
}

@property (nonatomic, assign) BOOL touchesEnabled;


- (id) initWithGame: (GCQuickCross *) _game;
- (void) doMove: (NSArray *) move;
- (void) undoMove: (NSArray *) move; 

@end

