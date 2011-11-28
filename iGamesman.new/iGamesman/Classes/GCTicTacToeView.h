//
//  GCTicTacToeView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCGame.h"


@protocol GCTicTacToeViewDelegate;

@interface GCTicTacToeView : UIView
{
    id<GCTicTacToeViewDelegate> delegate;
    BOOL acceptingTouches;
    
    UILabel *messageLabel;
}

@property (nonatomic, assign) id<GCTicTacToeViewDelegate> delegate;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end



@class GCTicTacToePosition;
@class GCPlayer;

@protocol GCTicTacToeViewDelegate

- (GCTicTacToePosition *) position;
- (GCGameValue *) primitive;
- (GCPlayer *) leftPlayer;
- (GCPlayer *) rightPlayer;
- (void) userChoseMove: (NSNumber *) slot;

@end
