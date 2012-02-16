//
//  GCQuartoView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/7/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCQuartoViewDelegate;

@interface GCQuartoView : UIView
{
    id<GCQuartoViewDelegate> delegate;
    CGPoint backgroundCenter;
    
    BOOL acceptingTouches;
}

@property (nonatomic, assign) id<GCQuartoViewDelegate> delegate;
@property (nonatomic, assign) CGPoint backgroundCenter;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end



@class GCQuartoPiece;
@class GCQuartoPosition;

@protocol GCQuartoViewDelegate

- (GCQuartoPosition *) position;
- (NSString *) leftPlayerName;
- (NSString *) rightPlayerName;
- (void) userChosePiece: (GCQuartoPiece *) piece;
- (void) userPlacedPiece: (NSUInteger) slot;

- (BOOL) isShowingMoveValues;
- (BOOL) isShowingDeltaRemoteness;

@end
