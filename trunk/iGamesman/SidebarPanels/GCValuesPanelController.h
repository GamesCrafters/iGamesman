//
//  GCValuesPanelController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCGame.h"
#import "GCModalDrawerView.h"


@protocol GCValuesPanelDelegate;

@interface GCValuesPanelController : UIViewController <GCModalDrawerPanelDelegate>
{
    id<GCGame> game;
    id<GCValuesPanelDelegate> delegate;
    
    UILabel *moveValueLabel, *deltaRemotenessLabel;
    UISwitch *predictionsSwitch, *moveValueSwitch, *deltaRemotenessSwitch;
    
    UIPopoverController *helpPopover;
}

@property (nonatomic, assign) id<GCValuesPanelDelegate> delegate;

- (id) initWithGame: (id<GCGame>) game;

@end



@protocol GCValuesPanelDelegate

- (BOOL) isShowingPredictions;
- (void) setShowingPredictions: (BOOL) predictions;

- (void) presentViewController: (UIViewController *) viewController;

@end
