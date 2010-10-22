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
#import "GCJSONService.h"


@interface GCYGameViewController : UIViewController {
	UIActivityIndicatorView		*spinner;
	GCYGame						*game;
	UILabel						*message;
	GCYBoardView				*boardView;
	NSTimer						*timer;
	NSThread					*waiter;
	GCJSONService				*service;
	BOOL						touchesEnabled;
}

@property (nonatomic, retain) GCYBoardView *boardView;
@property (nonatomic, retain) GCJSONService *service;
@property (nonatomic, assign) BOOL touchesEnabled;


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
- (int) boardSize;

- (NSArray *) translateToServer: (NSArray *) moveArray;
- (NSDictionary *) getServerValues: (NSArray *) moves;

- (void) updateServerDataWithService: (GCJSONService *) service;
- (void) fetchNewData: (BOOL) buttonsOn;
- (void) fetchFinished: (BOOL) buttonsOn;

@end
