//
//  GCGameView.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/23/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GCGameView

/// Handles the changing of appearance options
- (void) updateDisplayOptions: (NSDictionary *) options;

@end
