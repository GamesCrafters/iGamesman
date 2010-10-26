//
//  GCOthelloViewController.h
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCOthello.h"

@interface GCOthelloViewController : UIViewController {
	GCOthello *game;
	BOOL touchesEnabled;

}

@property (nonatomic, assign) BOOL touchesEnabled;

-(id) initWithGame: (GCOthello *) _game;
-(void) doMove: (NSNumber *) move;

@end
