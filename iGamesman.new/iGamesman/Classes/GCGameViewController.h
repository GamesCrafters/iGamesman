//
//  GCGameViewController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCGame;

@interface GCGameViewController : UIViewController
{
    id<GCGame> _game;
}

- (id) initWithGame: (id<GCGame>) game;

@end
