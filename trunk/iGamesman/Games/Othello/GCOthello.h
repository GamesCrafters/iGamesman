//
//  GCOthello.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/21/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCOthelloView.h"

@class GCOthelloPosition;

@interface GCOthello : NSObject <GCGame, GCOthelloViewDelegate, UIAlertViewDelegate>
{
    GCOthelloPosition *position;
    
    GCPlayer *leftPlayer, *rightPlayer;
    
    GCMoveCompletionHandler moveHandler;
    
    GCOthelloView *othelloView;
}

@end
