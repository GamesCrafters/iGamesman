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
    id<GCConnectFourViewDelegate> delegate;
    CGPoint backgroundCenter;
    
    BOOL acceptingTouches;
}

@property (nonatomic, assign) id<GCConnectFourViewDelegate> delegate;
@property (nonatomic, assign) CGPoint backgroundCenter;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

- (void) doMove: (NSNumber *) column;
- (void) undoMove: (NSNumber *) column;

@end



@class GCConnectFourPosition;

@protocol GCConnectFourViewDelegate

- (GCConnectFourPosition *) position;
- (NSArray *) generateMoves;
- (void) userChoseMove: (NSNumber *) column;

@end
