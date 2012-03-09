//
//  GCVVHView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GCVVHViewDataSource;

@interface GCVVHView : UIView
{
    id<GCVVHViewDataSource> _dataSource;
}

- (void) setDataSource: (id<GCVVHViewDataSource>) dataSource;

- (void) reloadData;

@end



@protocol GCVVHViewDataSource

- (NSEnumerator *) historyItemEnumerator;

@end
