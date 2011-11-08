//
//  GCDrawerView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDrawerView : UIView
{
    UIButton *closeButton;
}

- (id) initWithFrame: (CGRect) frame startOffscreen: (BOOL) offscreen;

- (void) slideIn;
- (void) slideOut;

@end
