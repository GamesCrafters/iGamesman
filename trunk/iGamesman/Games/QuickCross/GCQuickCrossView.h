//
//  GCQuickCrossView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCQuickCrossViewDelegate;

@interface GCQuickCrossView : UIView
{
    id<GCQuickCrossViewDelegate> _delegate;
    
    BOOL _acceptingTouches;
    
    BOOL _receivingMove;
    CGPoint _touchDownPoint;
    NSUInteger _moveIndex;
}

@property (nonatomic, assign) id<GCQuickCrossViewDelegate> delegate;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end



@class GCQuickCrossPosition;

@protocol GCQuickCrossViewDelegate

- (GCQuickCrossPosition *) position;
- (void) userChoseMove: (NSArray *) move;

@end
