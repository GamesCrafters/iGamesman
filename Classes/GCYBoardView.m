//
//  GCYBoardView.m
//  GamesmanMobile
//
//  Created by Class Account on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYBoardView.h"
#import "GCYBoardConnectionsView.h"

@implementation GCYBoardView
@synthesize layers, innerTriangleLength;
@synthesize centers;
@synthesize neighborsForPosition;
@synthesize connectionsView;
@synthesize circleRadius;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame withLayers: (int) myLayers andInnerLength: (int) innerLength{
	if (self = [super initWithFrame:frame]) {
        layers = myLayers;
		innerTriangleLength = innerLength;
		circleRadius = 0;
		GCYBoardConnectionsView * connectionsView = [[GCYBoardConnectionsView alloc] initWithFrame: frame];
		centers = [[NSMutableArray alloc] initWithCapacity: [self boardSize]];
		neighborsForPosition = [[NSMutableDictionary alloc] init];
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
	double triangleHeight;
	double triangleWidth;
	double layerWidth;
	double layerHeight;
	CGFloat xCoord;
	CGFloat yCoord;
	CGPoint currentCenter;
	CGPoint innerTriangleTop;
	CGFloat xCoordStart;
	int currentTag = 1;
	
	CGPoint boardCenter = CGPointMake(self.frame.size.width/2, self.frame.size.width/2 + 5);
	CGPoint rightCorner = CGPointMake(self.frame.size.width - 5, self.frame.size.width + 5);
	CGPoint leftCorner = CGPointMake(5, self.frame.size.width + 5);
	CGPoint upperCorner = CGPointMake(self.frame.size.width/2, 5); 
	
	
	/* Calculate Spacing */
	//Find vertical distance between spaces for the mini inner triangles and the circles
	triangleHeight = (self.frame.size.width/2 - 10)/(layers + 1/2 * innerTriangleLength + 1/2);
	triangleWidth = sqrt(4/5*pow(triangleHeight, 2));
	circleRadius = 1/5*triangleWidth;
	
	
	/* calculate innerTriangle centers and tags */
	innerTriangleTop = CGPointMake(upperCorner.x, upperCorner.y + layers * triangleHeight);
	xCoordStart = innerTriangleTop.x;
	for (int i = 0; i <= innerTriangleLength; i++){
		yCoord = innerTriangleTop.x + i * triangleHeight;
		
		//find the centers in each column for the row i
		for (int j = 0; j <= i; j++){
			xCoord = xCoordStart + .5 * triangleWidth * j;
			[centers insertObject: [NSValue valueWithCGPoint: CGPointMake(xCoord, yCoord)] atIndex: currentTag - 1];
			currentTag++;
		}
		xCoordStart -= .5 * triangleWidth;
	}
	
	layerWidth = xCoordStart - leftCorner.x;
	layerHeight = leftCorner.y - (innerTriangleTop.y + innerTriangleLength * triangleHeight);
	
	
	/* Calculate layer positions */
	rightCorner.x = rightCorner.x; 
	rightCorner.y = rightCorner.y - .5 * triangleHeight;
	
	leftCorner.x = leftCorner.x;
	leftCorner.y = leftCorner.y - .5 * triangleHeight;
	
	upperCorner.y = upperCorner.y + .5 * triangleHeight;
	
	for (int i = layers; i > 0; i--){
		
	}
	
}

- (int) centersAlongLayer: (int) layer fromPointA: (CGPoint *) pointA toPointB: (CGPoint *) pointB withCenter: (CGPoint *) arcCenter startingAt: (int) position{
	int currentPosition = position;
	
	
	return currentPosition;
}


/** Draws the initial board shape based on the positions of the outsideCorners **/
- (void) drawBoard{
	CGPoint rightCorner = CGPointMake(self.frame.size.width - 5, self.frame.size.width + 5);
	CGPoint leftCorner = CGPointMake(5, self.frame.size.width + 5);
	CGPoint upperCorner = CGPointMake(self.frame.size.width/2, 5);
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
- (NSMutableSet *) edgesForPosition: (int) position{
}


/** Returns the starting edges **/
- (NSMutableArray *) startingEdges{
}




- (void)dealloc {
	[centers release];
	[neighborsForPosition release];
	[connectionsView release];
    [super dealloc];
}


@end
