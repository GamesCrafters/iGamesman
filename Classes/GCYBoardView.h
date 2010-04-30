//
//  GCYBoardView.h
//  GamesmanMobile
//
//  Created by Class Account on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCYBoardConnectionsView;
@interface GCYBoardView : UIView {
	int layers;
	int innerTriangleLength;
	NSMutableArray *bottomEdgePieces;
	NSMutableDictionary *edgesForPosition;
	NSMutableDictionary *neighborsForPosition;
	NSMutableArray *centers;
	GCYBoardConnectionsView *connectionsView;
	
	NSMutableArray *outsideCorners;
	CGFloat *smallestDistance;
	
}

@property (nonatomic, assign) int layers;
@property (nonatomic, assign) int innerTriangleLength;
@property (nonatomic, retain) NSMutableArray *bottomEdgePieces;
@property (nonatomic, retain) NSMutableDictionary *edgesForPosition;
@property (nonatomic, retain) NSMutableDictionary *neighborsForPosition;
@property (nonatomic, retain) NSMutableArray  *centers;
@property (nonatomic, retain) GCYBoardConnectionsView *connectionsView;

/** Does all of the initial calculations, then procedes to find centers, connections, and edges **/
- (void) createBoardView;


/** Draws the initial board shape based on the positions of the outsideCorners **/
- (void) drawBoard;


/** Draws the initial lines and positions on the board **/
- (void) drawDetails;


/** Draws the connections on the conectionsView when pieces of the same color are placed next to each other **/
- (void) drawConnections;


/** Calculates the number of positions, probably unnecessary **/
- (void) calculateNumberOfPositions;


/** Find the neighboring pieces for a position and adds them to neighborsForPosition **/
- (void) calculateConnectionsForPosition: (int) position inLayer: (int) layer;

@end
