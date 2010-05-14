//
//  GCYGameViewController.h
//  GamesmanMobile
//
//  Created by Linsey Hansen on 3/7/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCYGame.h"
#import "GCYBoardView.h"


@interface GCYGameViewController : UIViewController {
	GCYGame *game;
	UILabel *message;
	GCYBoardView *boardView;
}

@property (nonatomic, retain) GCYBoardView *boardView;

//- (id) initWithLayers: (int) layers; //can probably delete
- (id) initWithGame: (GCYGame *) _game;
- (void) doMove: (NSNumber *) move;
- (void) disableButtons;
- (void) enableButtons;
- (void) newBoard;
- (void) displayPrimitive;
- (IBAction) tapped: (UIButton *) button;
- (void) updateLabels;
- (NSArray *) leftEdges;
- (NSSet *) positionEdges: (NSNumber *) position;
- (NSSet *) positionConnections: (NSNumber *) position;

@end
