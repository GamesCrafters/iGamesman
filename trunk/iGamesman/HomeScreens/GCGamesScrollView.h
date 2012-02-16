//
//  GCGamesScrollView.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 12/29/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCGamesScrollView : UIScrollView
{
    NSMutableArray *gameInfos, *visibleGameInfos;
    NSMutableArray *visibleGames;
}

- (NSDictionary *) centerGame;

@end
