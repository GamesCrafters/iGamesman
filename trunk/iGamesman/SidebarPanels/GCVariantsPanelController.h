//
//  GCVariantsPanelController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModalDrawer.h"


@protocol GCVariantsPanelDelegate;

@interface GCVariantsPanelController : UIViewController <GCModalDrawerPanelDelegate, UIAlertViewDelegate>
{
    id<GCVariantsPanelDelegate> _delegate;
}

@property (nonatomic, assign) id<GCVariantsPanelDelegate> delegate;

@end



@protocol GCVariantsPanelDelegate

- (void) closeDrawer;

@end
