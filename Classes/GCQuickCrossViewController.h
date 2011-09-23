//
//  GCQuickCrossViewController.h
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCQuickCross.h"
#import "GCJSONService.h"


@interface GCQuickCrossViewController : UIViewController {
    UIActivityIndicatorView *spinner;
    NSThread *waiter;
    NSTimer *timer;
    
    UILabel *messageLabel;
        
    GCJSONService *service;
	GCQuickCross *game;
	
    CGPoint start;

	BOOL touchesEnabled;	
}

@property (nonatomic, assign) BOOL touchesEnabled;


- (id) initWithGame: (GCQuickCross *) _game;

- (void) updateServerDataWithService: (GCJSONService *) service;
- (void) fetchNewData: (BOOL) buttonsOn;
- (void) fetchFinished: (BOOL) buttonsOn;
- (void) timedOut: (NSTimer *) theTimer;
- (void) stop;


- (void) doMove: (NSArray *) move;
- (void) undoMove: (NSArray *) move; 
- (void) updateDisplay;

@end

