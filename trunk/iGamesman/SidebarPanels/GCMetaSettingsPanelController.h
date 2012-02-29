//
//  GCMetaSettingsPanelController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModalDrawerView.h"


@protocol GCMetaSettingsPanelDelegate;

@interface GCMetaSettingsPanelController : UIViewController <GCModalDrawerPanelDelegate>
{
    id<GCMetaSettingsPanelDelegate> delegate;
    
    UILabel *moveDelayLabel, *gameDelayLabel, *animationSpeedLabel;
    UISlider *moveDelaySlider, *gameDelaySlider, *animationSpeedSlider;
}

- (void) setDelegate: (id<GCMetaSettingsPanelDelegate>) delegate;

@end



@protocol GCMetaSettingsPanelDelegate

- (CGFloat) computerMoveDelay;
- (void) setComputerMoveDelay: (CGFloat) delay;

- (CGFloat) computerGameDelay;
- (void) setComputerGameDelay: (CGFloat) delay;

@end