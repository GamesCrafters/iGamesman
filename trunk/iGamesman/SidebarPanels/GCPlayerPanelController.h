//
//  GCPlayerPanelController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCGame.h"
#import "GCModalDrawerView.h"

@interface GCPlayerPanelController : UIViewController <GCModalDrawerPanelDelegate, UITextFieldDelegate>
{
    id<GCGame> _game;
    
    UITextField        *_leftTextField,      *_rightTextField;
    UISegmentedControl *_leftPlayerType,     *_rightPlayerType;
    UILabel            *_leftPercentHeader,  *_rightPercentHeader;
    UILabel            *_leftPercentLabel,   *_rightPercentLabel;
    UISlider           *_leftPercentSlider,  *_rightPercentSlider;
    UILabel            *_leftInfoLabel,      *_rightInfoLabel;
}

- (id) initWithGame: (id<GCGame>) game;

@end
