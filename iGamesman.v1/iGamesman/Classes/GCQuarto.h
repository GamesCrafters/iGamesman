//
//  GCQuarto.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/3/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"
#import "GCQuartoView.h"


@class GCPlayer;
@class GCQuartoPosition;

@interface GCQuarto : NSObject <GCGame, GCQuartoViewDelegate>
{
    GCQuartoPosition *position;
    
    GCPlayer *leftPlayer, *rightPlayer;
    
    PlayMode mode;
}

@end
