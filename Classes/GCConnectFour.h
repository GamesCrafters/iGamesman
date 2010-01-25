//
//  GCConnectFour.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/19/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCConnectFourOptionMenu.h"
#import "GCGame.h"


@interface GCConnectFour : NSObject <GCGame> {
	GCConnectFourOptionMenu *optionMenu;
	NSString *p1Name;
	NSString *p2Name;
}

@end
