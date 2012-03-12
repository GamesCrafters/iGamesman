//
//  GCTicTacToeView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCGame.h"


@protocol GCTicTacToeViewDelegate;

@interface GCTicTacToeView : UIView
{
    id<GCTicTacToeViewDelegate> _delegate;
    
    BOOL _acceptingTouches;
}

@property (nonatomic, assign) id<GCTicTacToeViewDelegate> delegate;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end



@class GCTicTacToePosition;
@class GCPlayer;

@protocol GCTicTacToeViewDelegate

- (GCTicTacToePosition *) position;
- (NSArray *) moveValues;
- (NSArray *) remotenessValues;
- (void) userChoseMove: (NSNumber *) slot;

- (BOOL) isShowingMoveValues;
- (BOOL) isShowingDeltaRemoteness;

@end
