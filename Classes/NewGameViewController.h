//
//  NewGameViewController.h
//  Gamesman
//
//  Created by AUTHOR_NAME on MM/DD/YYYY.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGameView.h"


@interface NewGameViewController : UIViewController <GCGameView> {
	BOOL showPredictions;			///< Keeps track of whether or not to display predictions
	BOOL showMoveValues;			///< Keeps track of whether or not to display move values
	NSString *p1Name, *p2Name;
}

@end
