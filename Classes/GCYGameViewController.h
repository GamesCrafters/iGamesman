//
//  GCYGameViewController.h
//  GamesmanMobile
//
//  Created by Linsey Hansen on 3/7/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCYGame.h"


@interface GCYGameViewController : UIViewController {
	GCYGame *game;

}

- (id) initWithLayers: (int) layers; //can probably delete
- (id) initWithGame: (GCYGame *) _game;
- (void) doMove: (NSNumber *) move;

- (void) disableButtons;
- (void) enableButtons;
- (IBAction) tapped: (UIButton *) button;

@end
