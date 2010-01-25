//
//  NewGame.h
//  Gamesman
//
//  Created by AUTHOR_NAME on MM/DD/YYYY.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewGameOptionMenu.h"
#import "GCGame.h"


@interface NewGame : NSObject <GCGame> {
	NewGameOptionMenu *optionMenu;
	NSString *p1Name;
	NSString *p2Name;
}

@end
