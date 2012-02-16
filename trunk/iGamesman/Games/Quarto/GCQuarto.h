//
//  GCQuarto.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCQuartoView.h"


@class GCQuartoPosition;

@interface GCQuarto : NSObject <GCGame, GCQuartoViewDelegate>
{
    GCQuartoPosition *position;
    
    GCPlayer *leftPlayer, *rightPlayer;
    
    GCMoveCompletionHandler moveHandler;
    
    GCQuartoView *quartoView;
    
    
    BOOL showMoveValues, showDeltaRemoteness;
}

@end
