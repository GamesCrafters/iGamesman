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
	int p1Count;
	int p2Count;
	CGFloat lineWidth;
}

@property (nonatomic, retain) NSMutableArray *p1Connections;
@property (nonatomic, retain) NSMutableArray *p2Connections;
@property (nonatomic, retain) UIColor *p1Color;
@property (nonatomic, retain) UIColor *p2Color;
@property (nonatomic, assign) int p1Count;
@property (nonatomic, assign) int p2Count;
@property (nonatomic, assign) CGFloat lineWidth;

- (void) addConnectionFrom: (CGPoint) point1 To: (CGPoint) point2 ForPlayer: (BOOL) player1;

@end


/** Used to store two CGPoints **/
@interface YConnection: NSObject{
	CGPoint pointA;
	CGPoint pointB;
}

@property (nonatomic, assign) CGPoint pointA;
@property (nonatomic, assign) CGPoint pointB;

- (id) initWithPointA: (CGPoint) pA andPointB: (CGPoint) pB;

@end


@interface YNeighbors : NSObject{
	NSNumber *positionA;
	NSNumber *positionB;
}

- (id) newNeighborsA: (NSNumber *) posA neighborB: (NSNumber *) posB;

@end