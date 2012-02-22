//
//  GCGameViewController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCGameController.h"

#import "GCModalDrawerView.h"
#import "GCValuesPanelController.h"


@protocol GCGame;
@class GCSidebarView;
@class GCVVHView;


@interface GCGameViewController : UIViewController <GCGameControllerDelegate, GCModalDrawerViewDelegate, GCValuesPanelDelegate>
{
    id<GCGame> game;
    GCGameController *gameController;
    
    UILabel *messageLabel;
    
    UIView *gameView;
    
    BOOL showingPredictions;
    BOOL showingVVH;
    
    GCSidebarView *sideBar;
    GCVVHView *vvh;
}

- (id) initWithGame: (id<GCGame>) game;

@end
