//
//  GCConnections.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/20/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCConnectionsView.h"

@class GCConnectionsPosition;

@interface GCConnections : NSObject <GCGame, GCConnectionsViewDelegate>
{
    GCConnectionsPosition *_position;
    
    GCPlayer *_leftPlayer, *_rightPlayer;
    
    GCMoveCompletionHandler _moveHandler;
    
    GCConnectionsView *_connectionsView;
}

@end
