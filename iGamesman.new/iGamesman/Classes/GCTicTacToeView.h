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
}

@property (nonatomic, assign) id<GCTicTacToeViewDelegate> delegate;

@end



@class GCTicTacToePosition;

@protocol GCTicTacToeViewDelegate

- (GCTicTacToePosition *) currentPosition;

@end
