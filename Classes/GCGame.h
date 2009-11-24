//
//  GCGame.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/19/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCOptionMenu.h"
#import "GCGameView.h"


@protocol GCGame

- (id<GCOptionMenu>) getOptionMenu;
- (UIViewController<GCGameView> *) getGameViewController;

@end
