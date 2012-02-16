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
    id<GCGame> game;
    
    UITextField        *leftTextField,      *rightTextField;
    UISegmentedControl *leftPlayerType,     *rightPlayerType;
    UILabel            *leftPercentHeader,  *rightPercentHeader;
    UILabel            *leftPercentLabel,   *rightPercentLabel;
    UISlider           *leftPercentSlider,  *rightPercentSlider;
    UILabel            *leftInfoLabel,      *rightInfoLabel;
}

- (id) initWithGame: (id<GCGame>) game;

@end
