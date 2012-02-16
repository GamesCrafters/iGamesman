//
//  GCQuickCross.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCQuickCrossView.h"

@class GCQuickCrossPosition;

@interface GCQuickCross : NSObject <GCGame, GCQuickCrossViewDelegate>
{
    GCQuickCrossPosition *position;
    
    GCPlayer *leftPlayer, *rightPlayer;
    
    GCMoveCompletionHandler moveHandler;
    
    GCQuickCrossView *quickCrossView;
}

@end
