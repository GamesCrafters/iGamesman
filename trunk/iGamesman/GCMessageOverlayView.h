//
//  GCMessageOverlayView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCMessageOverlayView : UIView
{
    UIActivityIndicatorView *_spinner;
    
    UILabel *_messageLabel;
}

+ (GCMessageOverlayView *) sharedOverlayView;

- (void) beginLoadingWithMessage: (NSString *) message;
- (void) finishingLoading;

@end
