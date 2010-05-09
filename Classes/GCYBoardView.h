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
	NSMutableArray *centers;
	GCYBoardConnectionsView *connectionsView;
	NSMutableDictionary *neighborsForPosition;
	NSMutableArray *outsideCorners;
	CGFloat circleRadius;
	CGFloat padding;
	CGPoint upperCorner;
	CGPoint rightCorner;
	CGPoint leftCorner;
	
}

@property (nonatomic, assign) int layers;
@property (nonatomic, assign) int innerTriangleLength;
@property (nonatomic, retain) NSMutableArray  *centers;
@property (nonatomic, retain) NSMutableDictionary *neighborsForPosition;
@property (nonatomic, retain) GCYBoardConnectionsView *connectionsView;
@property (nonatomic, assign) CGFloat circleRadius;



/** Inits the boardview **/
- (id) initWithFrame:(CGRect)frame withLayers: (int) myLayers andInnerLength: (int) innerLength;

/** Does all of the initial calculations, then procedes to find centers, connections, and edges **/
- (void) createBoardView;


/** Given two corners, the current layer, the current position number, and a radius, calculates the centers along the arc 
 ** between the two corners and returns the new position.  Assumes it is going clockwise **/
- (int) centersAlongLayer: (int) layer fromPointA: (CGPoint) pointA toPointB: (CGPoint) pointB withCenter: (CGPoint) arcCenter startingAtPosition: (int) position;


/** Draws the connections on the conectionsView when pieces of the same color are placed next to each other **/
- (void) drawConnections;

/** Find the neighboring pieces for a position and adds them to neighborsForPosition **/
- (void) calculateConnectionsForPosition: (int) position inLayerPosition: (int) layerPosition forLayer: (int) layer;

/** Utility function that solves for n! **/
- (int) positionsInTriangle: (int) triangleSideLength;

/** Utility function that returns the board size **/
- (int) boardSize;

/** Returns the edges for a position **/
- (NSMutableSet *) edgesForPosition: (int) position;


/** Returns the starting edges **/
- (NSMutableArray *) startingEdges;


@end
