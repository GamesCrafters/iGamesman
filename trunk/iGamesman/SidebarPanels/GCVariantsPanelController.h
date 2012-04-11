//
//  GCVariantsPanelController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModalDrawer.h"
#import "GCGame.h"


@protocol GCVariantsPanelDelegate;

@interface GCVariantsPanelController : UIViewController <GCModalDrawerPanelDelegate, UIAlertViewDelegate>
{
    id<GCVariantsPanelDelegate> _delegate;
    id<GCGame> _game;
    
    UILabel *_misereLabel;
    UISwitch *_misereSwitch;
}

@property (nonatomic, assign) id<GCVariantsPanelDelegate> delegate;

- (id) initWithGame: (id<GCGame>) game;

@end



@protocol GCVariantsPanelDelegate

- (void) closeDrawer: (GCVariantsPanelController *) sender;
- (void) startNewGameWithOptions: (NSDictionary *) options;

@end
