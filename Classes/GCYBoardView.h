//
//  GCYBoardView.h
//  GamesmanMobile
//
//  Created by Class Account on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCYGame;
@interface GCYBoardView : UIView {
	GCYGame *game;
}

@property (nonatomic, retain) GCYGame *game;

@end
