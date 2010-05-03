//
//  GCYBoardView.m
//  GamesmanMobile
//
//  Created by Class Account on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYBoardView.h"


@implementation GCYBoardView
@synthesize layers, innerTriangleLength;
@synthesize centers;
@synthesize neighborsForPosition;
@synthesize connectionsView;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	//draw the board
	//draw the other stuff
}


/** Does all of the initial calculations, then procedes to find centers, connections, and edges **/
- (void) createBoardView{
	//calculate spacing
	//calculate innertriangle dimensions/height
}


/** Draws the initial board shape based on the positions of the outsideCorners **/
- (void) drawBoard{
}


/** Draws the initial lines and positions on the board **/
- (void) drawDetails{
}


/** Draws the connections on the conectionsView when pieces of the same color are placed next to each other **/
- (void) drawConnections{
}

/** Find the neighboring pieces for a position and adds them to neighborsForPosition **/
- (void) calculateConnectionsForPosition: (int) position inLayerPosition: (int) layerPosition forLayer: (int) layer{
//	int previousLayerPosition;
//	int nextLayerPosition;
//	NSMutableSet *neighbors = [NSMutableSet setWithObject: nil];
//	
//	//if this is in the inner triangle
//	if (layer == 0){
//	}
//	//if this is a corner position in it's current layer
//	else if{
//		//check if this is the first corner
//		if (layerPosition == 1){
//			nextLayerPosition = (layer - 1 + innerTriangleLength) * 3
//			
//			//add postions from the upper layer if this isn't the last layer
//			if (layer != layers){
//				previousFirstPosition = position - (layer + innerTriangleLength) * 3; 
//				[neighbors addObject: [NSNumber numberWithInt: position - 1]];
//				[neighbors addObject: [NSNumber numberWithInt: previousLayerPosition]];
//				[neighbors addObject: [NSNumber numberWithInt:  previousLayerPosition + 1]];
//			}
//			
//			//add positions in same layer
//			[neighbors addObject: [NSNumber numberWithInt: position + 1]];
//			[neighbors addObject: [NSNumber numberWithInt: position + nextLayerPosition - 1]];
//			
//			//add position in lower layer
//			if (layer == 0){
//				[neighbors addObject: [NSNumber numberWithInt: 0]];
//			}else{
//				[neighbors addObject: [NSNumber numberWithInt: position + nextLayerPosition]];
//			}
//		}
//		//check if this is the second corner
//		if (layerPosition == layer + innerTriangleLength){
//			//add postions from the upper layer if this isn't the last layer
//			if (layer != layers){
//				nextLayerPosition = position - (layer + innerTriangleLength);
//			}
//			
//			//add positions in same layer
//			
//			//add positions in lower layer
//		}
//		//check if this is the third corner
//		if (layerPosition == 1){
//			//add postions from the upper layer if this isn't the last layer
//			if (layer != layers){
//			}
//			
//			//add positions in same layer
//			
//			//add positions in lower layer
//		}
//	}
//	//Solve for regular layer pieces
//	else{
//		//check if this is the last piece in the layer
//		else if (layerPosition == (innerTriangleLength + layer - 1) * 3){
//			//add positions from the upper layer if this isn't the last layer
//			if (layer != layers){
//			}
//			
//			//add positions in same layer
//			
//			//add positions in lower layer
//		}
//		else{
//			//add positions from the upper layer if this isn't the last layer
//			if (layer != layers){
//				
//			}
//			
//			//add positions in same layer
//			
//			//add positions in lower layer
//		}
//	}
//	[neighborsForPosition setObject: neighbors forKey: [NSNumber numberWithInt: position]];
}

/** Utility function that solves for n! aka the positions in a triangle with side length n**/
- (int) positionsInTriangle: (int) triangleSideLength{
	int size = 0;
	for (int i = 1; i <= triangleSideLength; i++)
		size += i;
	return size;
}

/** Utility function that returns the board size **/
- (int) boardSize{
	int size = 0;
	if (!centers){
		//calculate center triangle size
		size += [self positionsInTriangle: innerTriangleLength];
		//calculate the sizes of each layer
		for (int i = 1; i <= layers; i++){
			size += (innerTriangleLength + i - 1) * 3;
		}
	}else size = [centers count];
	return size;
}
			


/** Returns the edges for a position **/
(NSMutableSet *) edgesForPosition: (int) position{
}


/** Returns the starting edges **/
(NSMutableArray *) startingEdges{
}




- (void)dealloc {
    [super dealloc];
}


@end
