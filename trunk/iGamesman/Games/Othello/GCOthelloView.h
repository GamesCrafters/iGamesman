//
//  GCOthelloView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/21/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCOthelloViewDelegate;

@interface GCOthelloView : UIView
{
    id<GCOthelloViewDelegate> delegate;
    
    BOOL acceptingTouches;
}

@property (nonatomic, assign) id<GCOthelloViewDelegate> delegate;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end



@class GCOthelloPosition;

@protocol GCOthelloViewDelegate

- (GCOthelloPosition *) position;
- (NSArray *) generateMoves;
- (void) userChoseMove: (NSNumber *) slot;

@end