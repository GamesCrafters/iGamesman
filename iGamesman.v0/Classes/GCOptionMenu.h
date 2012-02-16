//
//  GCOptionMenu.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/19/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCRulesDelegate.h"


@protocol GCOptionMenu

- (void) setDelegate: (id <GCRulesDelegate>) del;
- (id <GCRulesDelegate>) delegate;

@end
