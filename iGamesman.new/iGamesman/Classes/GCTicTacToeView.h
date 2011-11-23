//
//  GCTicTacToeView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GCTicTacToeViewDelegate;

@interface GCTicTacToeView : UIView
{
    id<GCTicTacToeViewDelegate> delegate;
    BOOL acceptingTouches;
}

@property (nonatomic, assign) id<GCTicTacToeViewDelegate> delegate;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end



@class GCTicTacToePosition;

@protocol GCTicTacToeViewDelegate

- (GCTicTacToePosition *) currentPosition;
- (void) userChoseMove: (NSNumber *) slot;

@end
