//
//  GCQuartoView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GCQuartoViewDelegate;


@interface GCQuartoView : UIView
{
    id<GCQuartoViewDelegate> delegate;
    
    CGRect boardFrame;
}

@property (nonatomic, assign) id<GCQuartoViewDelegate> delegate;

@end



@class GCQuartoPosition;

@protocol GCQuartoViewDelegate

- (GCQuartoPosition *) currentPosition;

@end
