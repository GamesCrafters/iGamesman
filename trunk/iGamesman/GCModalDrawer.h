//
//  GCModalDrawer.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

@class GCModalDrawerView;

@protocol GCModalDrawerPanelDelegate <NSObject>

- (BOOL) wantsSaveButton;
- (BOOL) wantsDoneButton;
- (BOOL) wantsCancelButton;
- (NSString *) title;

@optional
- (void) drawerWillAppear;
- (void) drawerWillDisappear;

- (BOOL) drawerShouldClose;

- (void) saveButtonTapped;
- (void) doneButtonTapped;
- (void) cancelButtonTapped;

@end



@protocol GCModalDrawerViewDelegate <NSObject>

- (void) addView: (UIView *) view behindDrawer: (GCModalDrawerView *) drawer;

@optional
- (void) drawerDidDisappear: (GCModalDrawerView *) drawer;

@end
