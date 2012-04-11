//
//  GCDrawerView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModalDrawer.h"

#import "GCVariantsPanelController.h"


@interface GCModalDrawerView : UIView
{
    UIToolbar *_toolbar;
    
    UIView *_backgroundView;
    
    UIViewController<GCModalDrawerPanelDelegate> *_panelController;
    
    id<GCModalDrawerViewDelegate> _delegate;
}

@property (nonatomic, assign) id<GCModalDrawerViewDelegate> delegate;

/**
 * Initialize the view with the desired frame.
 *
 * @param frame The frame for the drawer when it is/will be visible
 * @param offscreen YES if the drawer starts offscreen (and will later be slid to frame), NO if not
 *
 * @return The drawer view
 */
- (id) initWithFrame: (CGRect) frame startOffscreen: (BOOL) offscreen;

- (void) setPanelController: (UIViewController<GCModalDrawerPanelDelegate> *) controller;
- (UIViewController<GCModalDrawerPanelDelegate> *) panelController;

/* Slide the drawer in from offscreen */
- (void) slideIn;

/* Slide the drawer offscreen */
- (void) slideOut;

@end