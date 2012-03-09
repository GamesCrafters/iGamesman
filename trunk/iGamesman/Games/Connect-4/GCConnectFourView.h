//
//  GCConnectFourView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCConnectFourViewDelegate;

@interface GCConnectFourView : UIView
{
    id<GCConnectFourViewDelegate> _delegate;
    
    BOOL acceptingTouches;
}

@property (nonatomic, assign) id<GCConnectFourViewDelegate> delegate;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

- (void) doMove: (NSNumber *) column;
- (void) undoMove: (NSNumber *) column;

- (void) resetBoard;

@end



@class GCConnectFourPosition;

@protocol GCConnectFourViewDelegate

- (GCConnectFourPosition *) position;
- (NSArray *) generateMoves;
- (void) userChoseMove: (NSNumber *) column;

- (BOOL) isShowingMoveValues;
- (NSArray *) moveValues;
- (BOOL) isShowingDeltaRemoteness;
- (NSArray *) remotenessValues;

@end
