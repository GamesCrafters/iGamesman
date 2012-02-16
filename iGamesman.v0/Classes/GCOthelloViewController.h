//
//  GCOthelloViewController.h
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCOthello.h"
#import "GCJSONService.h"

@interface GCOthelloViewController : UIViewController {
    
    UIActivityIndicatorView *spinner;
	NSThread *waiter;
	NSTimer *timer;
    
    
	GCOthello *game;
	BOOL touchesEnabled;
    
    GCJSONService *service;

}

@property (nonatomic, assign) BOOL touchesEnabled;

-(id) initWithGame: (GCOthello *) _game;
-(void) doMove: (NSNumber *) move;
- (void) updateServerDataWithService: (GCJSONService *) _service;
- (void) fetchNewData: (BOOL) buttonsOn;
- (void) timedOut: (NSTimer *) theTimer;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) gameWon: (int) p1Won;
- (void) updateLegalMoves;
- (void) updateLabels;
- (void) undoMove:(NSNumber *)move;

@end
