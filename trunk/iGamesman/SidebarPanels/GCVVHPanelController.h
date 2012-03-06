//
//  GCVVHPanelController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModalDrawerView.h"
#import "GCVVHView.h"

/**
 * Note: this panel is only used on iPhone-family.
 */
@interface GCVVHPanelController : UIViewController <GCModalDrawerPanelDelegate>
{
    id<GCVVHViewDataSource> dataSource;
    
    GCVVHView *vvh;
}

- (id) initWithDataSource: (id<GCVVHViewDataSource>) dataSource;

@end
