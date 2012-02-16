//
//  GCConnectionsView.h
//  iGamesman
//
//  Created by Ian Ackerman on 11/21/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCGame.h"

@protocol GCConnectionsViewDelegate;

@interface GCConnectionsView : UIView {

	UIView* _board;
	UILabel *message;
	id<GCConnectionsViewDelegate> delegate;
    BOOL acceptingTouches;
}

@property (nonatomic, assign) id<GCConnectionsViewDelegate> delegate;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end


@class GCConnectionsPosition;

@protocol GCConnectionsViewDelegate

- (GCConnectionsPosition *) currentPosition;
- (GCGameValue *) primitive;
- (GCPlayer *) leftPlayer;
- (GCPlayer *) rightPlayer;
- (void) userChoseMove: (NSNumber *) slot;

@end
