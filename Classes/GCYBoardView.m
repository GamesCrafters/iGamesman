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
		CGFloat distance, halfPadding;
        layers = myLayers;
		padding = 20;
		innerTriangleLength = innerLength;
		circleRadius = 0;
		GCYBoardConnectionsView * connectionsView = [[GCYBoardConnectionsView alloc] initWithFrame: frame];
		centers = [[NSMutableArray alloc] initWithCapacity: [self boardSize]];
		neighborsForPosition = [[NSMutableDictionary alloc] init];
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
		
		distance = sqrt(pow(self.frame.size.width - padding, 2) - pow((self.frame.size.width - padding)/2, 2));
		halfPadding = padding/2.;
		upperCorner = CGPointMake(self.frame.size.width/2, halfPadding);
		rightCorner = CGPointMake(self.frame.size.width - halfPadding, halfPadding + distance);
		leftCorner = CGPointMake(halfPadding, halfPadding + distance);
    }
	NSLog(@"layers and stuff: %d, %d", layers, innerTriangleLength);
	[self createBoardView];
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGPoint currentCenter; 
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//draw the board
	CGContextSetRGBFillColor(context, 0.5f, 0.5f, 0.5f, 1.0f);
	CGContextSetRGBStrokeColor(context, 0.5f, 0.5f, 0.5f, 1.0f);
	CGContextBeginPath(context);
	CGContextAddArc(context, leftCorner.x, leftCorner.y, self.frame.size.width - 20, (5*M_PI)/3, 0, 0);
	CGContextAddArc(context, upperCorner.x, upperCorner.y, self.frame.size.width - 20, M_PI/3, (2*M_PI)/3, 0);
	CGContextAddArc(context, rightCorner.x, rightCorner.y, self.frame.size.width - 20, M_PI, (4*M_PI)/3, 0);
	CGContextFillPath(context);
	
	
	CGContextSetRGBFillColor(context, 0.2f, 0.2f, 0.2f, 1.0f);
	
	//draw the centers connections
	for (NSValue *pointValue in centers){
		//CGContextBeginPath(context);
		currentCenter = [pointValue CGPointValue];
		CGContextAddArc(context, currentCenter.x, currentCenter.y, circleRadius, 0, 2*M_PI, 1);
		CGContextFillPath(context);
	}
	
}


/** Does all of the initial calculations, then procedes to find centers, connections, and edges **/
- (void) createBoardView{
	CGFloat bottomLayers;
	CGFloat boardHeight;
	
	CGFloat triangleHeight;
	CGFloat triangleWidth;
	
	CGFloat layerWidth;
	CGFloat layerHeight;
	
	CGPoint layerUpperCorner;
	CGPoint layerRightCorner;
	CGPoint layerLeftCorner;
	
	CGFloat xCoord;
	CGFloat yCoord;
	
	CGPoint currentCenter;
	CGPoint innerTriangleTop;
	CGFloat xCoordStart;
	int currentTag = 1;
	
	/* Calculate Spacing */
	//Find vertical distance between spaces for the mini inner triangles and the circles
	boardHeight = rightCorner.y - upperCorner.y; 
	bottomLayers = (layers + .5) * sin(M_PI/6);
	triangleHeight = boardHeight/(layers + innerTriangleLength + .5 + bottomLayers);
	triangleWidth = sqrt(4/3. * pow(triangleHeight, 2));
	circleRadius = 1/5.*triangleWidth;
	NSLog(@"%f, %f, %f", boardHeight, triangleHeight, triangleWidth);
	
	
	/* calculate innerTriangle centers and tags */
	innerTriangleTop = CGPointMake(upperCorner.x, upperCorner.y + (layers + .5)* triangleHeight);
	xCoordStart = innerTriangleTop.x;
	for (int i = 0; i <= innerTriangleLength; i++){
		yCoord = innerTriangleTop.y + i * triangleHeight;

		//find the centers in each column for the row i
		for (int j = 0; j <= i; j++){
			xCoord = xCoordStart + triangleWidth * j;
			NSLog(@"%f, %f", xCoord, yCoord);
			[centers insertObject: [NSValue valueWithCGPoint: CGPointMake(xCoord, yCoord)] atIndex: currentTag - 1];
			currentTag++;

		}
		xCoordStart -= .5 * triangleWidth;
	}
	
	/* Calculate layer positions */
	if (layers != 0){
		layerWidth = triangleHeight * cos(M_PI/6);
		layerHeight = triangleHeight * sin(M_PI/6);
		
		//calculate outmost layer's corner positions
		layerRightCorner.x = rightCorner.x - .5 * layerWidth; 
		layerRightCorner.y = rightCorner.y - .5 * layerHeight;
		
		layerLeftCorner.x = leftCorner.x + .5 * layerWidth;
		layerLeftCorner.y = leftCorner.y - .5 * layerHeight;
		
		layerUpperCorner.y = upperCorner.y + .5 * triangleHeight;
		
		for (int i = layers; i > 0; i--){
			//call draw arc on everything!!!!!!!!!!!!!!!!!!!
			//arc along upper -> right
			currentTag = [self centersAlongLayer: i fromPointA: layerUpperCorner toPointB: layerRightCorner 
									  withCenter: leftCorner startingAtPosition: currentTag];
						  
			//arc along right -> left
			currentTag = [self centersAlongLayer: i fromPointA: layerRightCorner toPointB: layerLeftCorner
									  withCenter: upperCorner startingAt: currentTag];
			
			//arc along left -> upper
			currentTag = [self centersAlongLayer: i fromPointA: layerLeftCorner toPointB: layerUpperCorner
									  withCenter: rightCorner startingAt: currentTag];
			
			
			//move down to the next layer
			layerRightCorner.x = layerRightCorner.x - layerWidth;
			layerRightCorner.y = layerRightCorner.y - layerHeight;
			
			layerLeftCorner.x = layerLeftCorner.x + layerWidth;
			layerLeftCorner.y = layerLeftCorner.y - layerHeight;
			
			layerUpperCorner.y = layerUpperCorner.y + triangleHeight;
		}
	}
	
}

- (int) centersAlongLayer: (int) layer fromPointA: (CGPoint) pointA toPointB: (CGPoint) pointB withCenter: (CGPoint) arcCenter startingAtPosition: (int) position{
	CGFloat temp;
	CGFloat theta;
	int currentPosition = position;
	int pointsForLayer;
	int currentPoint;
	
	CGFloat angleA = atan2(pointA.x - arcCenter.x, pointA.y - arcCenter.y);
	CGFloat angleB = atan2(pointB.x - arcCenter.x, pointB.y - arcCenter.y);
	
	if (angleB > angleA){
		temp = angleA;
		angleA = angleB;
		angleB = temp;
	}
	
	
	
//	while(outsideCounter <= depthOutside) {
//		var p0 = {x: x + v0.x * rowSpacingCopy * outsideCounter,
//		y: y + v0.y * rowSpacingCopy * outsideCounter };
//		var p1 = {x: llCorner.x + v1.x * rowSpacingCopy * outsideCounter, y: llCorner.y - v1.y * rowSpacingCopy * outsideCounter};
//		var p2 = {x: lrCorner.x + v2.x * rowSpacingCopy * outsideCounter, y: lrCorner.y - v2.y * rowSpacingCopy * outsideCounter};
//		drawArc(outsideLeftCorner, p2, p0,  outsideCounter+depthInsideCopy, 7 * Math.PI /6, outsideCounter == depthOutside);
//		drawArc(outsideRightCorner, p1, p0,  outsideCounter+depthInsideCopy, - Math.PI/6, outsideCounter == depthOutside);
//		drawArc(outsideTopCorner, p2, p1,  outsideCounter+depthInsideCopy, Math.PI/2, outsideCounter == depthOutside);
//		outsideCounter++;
//	}
	return currentPosition;
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
