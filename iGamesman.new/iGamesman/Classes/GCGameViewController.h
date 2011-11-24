//
//  GCGameViewController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCGame;
@protocol GCGameControllerDelegate;

@class GCGameController;

@interface GCGameViewController : UIViewController <GCGameControllerDelegate>
{
    id<GCGame> _game;
    
    GCGameController *gameController;
}

- (id) initWithGame: (id<GCGame>) game;

@end
