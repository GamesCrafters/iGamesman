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
    UIButton *aboutGame, *playGame;
    GCGamesScrollView *scroller;
    
    NSDictionary *currentEntry;
}

@end
