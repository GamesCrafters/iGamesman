//
//  GCCarouselViewController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 12/29/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCGamesScrollView;

@interface GCCarouselViewController : UIViewController <UIScrollViewDelegate>
{
    UIButton *_aboutGameButton, *playGame;
    GCGamesScrollView *_scroller;
    
    NSDictionary *_currentEntry;
}

@end
