//
//  GCYGame.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"


@interface GCYGame : GCGame {
	NSString *player1Name, *player2Name;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;

@end
