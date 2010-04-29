//
//  GCYBoardConnectionsView.h
//  GamesmanMobile
//
//  Created by Class Account on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GCYBoardConnectionsView : UIView {
	NSMutableArray *p1Connections;
	NSMutableArray *p2Connections;
	UIColor *p1Color;
	UIColor *p2Color;
}

@property (nonatomic, retain) NSMutableArray *p1Connections;
@property (nonatomic, retain) NSMutableArray *p2Connections;

@end
