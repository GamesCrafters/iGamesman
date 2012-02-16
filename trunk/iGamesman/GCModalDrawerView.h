//
//  GCDrawerView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCModalDrawerPanelDelegate;
@protocol GCModalDrawerViewDelegate;

@interface GCModalDrawerView : UIView
{
    UIButton *closeButton;
    UIToolbar *toolbar;
    
    UIView *backgroundView;
    
    UIViewController<GCModalDrawerPanelDelegate> *panelController;
    
    id<GCModalDrawerViewDelegate> delegate;
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

/* Slide the drawer in from offscreen */
- (void) slideIn;

/* Slide the drawer offscreen */
- (void) slideOut;

@end



@protocol GCModalDrawerPanelDelegate <NSObject>

- (BOOL) wantsSaveButton;
- (BOOL) wantsDoneButton;
- (BOOL) wantsCancelButton;
- (NSString *) title;

@optional
- (void) drawerWillAppear;
- (void) drawerWillDisappear;

- (void) saveButtonTapped;
- (void) doneButtonTapped;
- (void) cancelButtonTapped;

@end


@protocol GCModalDrawerViewDelegate <NSObject>

- (void) addView: (UIView *) view behindDrawer: (GCModalDrawerView *) drawer;

@optional
- (void) drawerDidDisappear: (GCModalDrawerView *) drawer;

@end