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
    id<GCQuickCrossViewDelegate> delegate;
    CGPoint backgroundCenter;
    
    BOOL acceptingTouches;
    
    BOOL receivingMove;
    CGPoint touchDownPoint;
    NSUInteger moveIndex;
}

@property (nonatomic, assign) id<GCQuickCrossViewDelegate> delegate;
@property (nonatomic, assign) CGPoint backgroundCenter;

- (void) startReceivingTouches;
- (void) stopReceivingTouches;

@end



@class GCQuickCrossPosition;

@protocol GCQuickCrossViewDelegate

- (GCQuickCrossPosition *) position;
- (void) userChoseMove: (NSArray *) move;

@end
