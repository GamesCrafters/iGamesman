//
//  GCYBoardView.m
//  GamesmanMobile
//
//  Created by Class Account on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYBoardView.h"
#import "GCYBoardConnectionsView.h"



#pragma mark PositionDistance

@implementation PositionDistance
@synthesize myPosition, myDistance;

- (id) initWithPosition: (NSNumber *) pos Distance: (CGFloat) dist{
	myPosition = pos;
	myDistance = dist;
	return self;
}

- (void) dealloc {
	[super dealloc];
}
@end


#pragma mark GCYBoardView

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


/** Inits the boardview **/
- (id) initWithFrame:(CGRect)frame withLayers: (int) myLayers andInnerLength: (int) innerLength{
	if (self = [super initWithFrame:frame]) {
		CGFloat distance, halfPadding;
        layers = myLayers;
		padding = 20;
		innerTriangleLength = innerLength;
		circleRadius = 0;
		connectionsView = [[GCYBoardConnectionsView alloc] initWithFrame: frame];
		[self addSubview: connectionsView];
		centers = [[NSMutableArray alloc] initWithCapacity: [self boardSize]];
		neighborsForPosition = [[NSMutableDictionary alloc] init];
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
		
		distance = sqrt(pow(self.frame.size.width - padding, 2) - pow((self.frame.size.width - padding)/2, 2));
		halfPadding = padding/2.;
		upperCorner = CGPointMake(self.frame.size.width/2, halfPadding);
		rightCorner = CGPointMake(self.frame.size.width - halfPadding, halfPadding + distance);
		leftCorner = CGPointMake(halfPadding, halfPadding + distance);
    }
	[self createBoardView];
    return self;
}


#pragma mark Drawing_Stuff

- (void)drawRect:(CGRect)rect {
	NSMutableArray *drawnConnections = [NSMutableArray arrayWithCapacity: 0];
	
    // Drawing code
	CGPoint currentCenter; 
	CGPoint neighborCenter;
	YNeighbors *neighbors;
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
	
	//draw the centers 
	for (NSValue *pointValue in centers){
		//CGContextBeginPath(context);
		currentCenter = [pointValue CGPointValue];
		CGContextAddArc(context, currentCenter.x, currentCenter.y, circleRadius, 0, 2*M_PI, 1);
		CGContextFillPath(context);
	}
	
	//draw the connections between neighboring centers
	CGContextSetRGBStrokeColor(context, 0.2f, 0.2f, 0.2f, 1.0f);
	CGContextSetLineWidth(context, circleRadius*3.5/8.);
	for (NSNumber *position in [neighborsForPosition allKeys]){
		currentCenter = [[centers objectAtIndex: [position intValue] - 1] CGPointValue];
		
		for (NSNumber *neighborPosition in [neighborsForPosition objectForKey: position]){
			neighbors = [[YNeighbors alloc] newNeighborsA: position neighborB: neighborPosition];
			//if we haven't drawn this connection already, draw it
			if (![drawnConnections containsObject: neighbors]){
				neighborCenter = [[centers objectAtIndex: [neighborPosition intValue] - 1] CGPointValue];
				CGContextMoveToPoint(context, currentCenter.x, currentCenter.y);
				CGContextAddLineToPoint(context, neighborCenter.x, neighborCenter.y);
				CGContextStrokePath(context);
				[drawnConnections addObject: neighbors];
			}
			[neighbors release];
		}
	}
	
}

#pragma mark Create_Board
// I hate my life so much...
// TODO:  Change EVERYTHING!!!!


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
	
	CGPoint innerTriangleTop;
	CGFloat xCoordStart;
	int currentPosition = 1;
	
	/* Calculate Spacing */
	//Find vertical distance between spaces for the mini inner triangles and the circles
	boardHeight = rightCorner.y - upperCorner.y; 
	bottomLayers = (layers + .5) * sin(M_PI/6);
	triangleHeight = boardHeight/(layers + innerTriangleLength + .5 + bottomLayers);
	triangleWidth = sqrt(4/3. * pow(triangleHeight, 2));
	circleRadius = 1/5.*triangleWidth;
	connectionsView.lineWidth =  circleRadius*1/2.;
	
	
	/* calculate innerTriangle centers and tags */
	innerTriangleTop = CGPointMake(upperCorner.x, upperCorner.y + (layers + .5)* triangleHeight);
	xCoordStart = innerTriangleTop.x;
	for (int i = 0; i <= innerTriangleLength; i++){
		yCoord = innerTriangleTop.y + i * triangleHeight;

		//find the centers in each column for the row i
		for (int j = 0; j <= i; j++){
			xCoord = xCoordStart + triangleWidth * j;
			[centers insertObject: [NSValue valueWithCGPoint: CGPointMake(xCoord, yCoord)] atIndex: currentPosition - 1];
			currentPosition++;

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
		
		layerUpperCorner.x = upperCorner.x;
		layerUpperCorner.y = upperCorner.y + .5 * triangleHeight;
		
		for (int i = layers; i > 0; i--){
			//call draw arc on everything!!!!!!!!!!!!!!!!!!!
			//arc along upper -> right
			currentPosition = [self centersAlongLayer: i fromPointA: layerUpperCorner toPointB: layerRightCorner 
									  withCenter: leftCorner startingAtPosition: currentPosition];
						  
			//arc along right -> left
			currentPosition = [self centersAlongLayer: i fromPointA: layerRightCorner toPointB: layerLeftCorner
									  withCenter: upperCorner startingAtPosition: currentPosition];

			
			//arc along left -> upper
			currentPosition = [self centersAlongLayer: i fromPointA: layerLeftCorner toPointB: layerUpperCorner
									  withCenter: rightCorner startingAtPosition: currentPosition];
			
			
			//move down to the next layer
			layerRightCorner.x = layerRightCorner.x - layerWidth;
			layerRightCorner.y = layerRightCorner.y - layerHeight;
			
			layerLeftCorner.x = layerLeftCorner.x + layerWidth;
			layerLeftCorner.y = layerLeftCorner.y - layerHeight;
			
			layerUpperCorner.y = layerUpperCorner.y + triangleHeight;
		}
	}
	
	/* Calculate all of the connections */
	for (int i = 1; i <= [self boardSize]; i++)
		[self calculateConnectionsForPosition: i];

}


/** Given two corners, the current layer, the current position number, and a radius, calculates the centers along the arc 
 ** between the two corners and returns the new position.  Assumes it is going clockwise **/
- (int) centersAlongLayer: (int) layer fromPointA: (CGPoint) pointA toPointB: (CGPoint) pointB withCenter: (CGPoint) arcCenter 
	   startingAtPosition: (int) position{
	CGFloat theta;
	CGFloat radius;
	CGFloat xCoord, yCoord;
	int currentPosition = position;
	int pointsForLayer;
	
	CGFloat angleA = atan2(pointA.y - arcCenter.y, pointA.x - arcCenter.x);
	CGFloat angleB = atan2(pointB.y - arcCenter.y, pointB.x - arcCenter.x);
	
	
	//Determine how many points will be in the layer and what the radius of the current arc is
	pointsForLayer = layer + innerTriangleLength;
	radius = sqrt(pow((arcCenter.x - pointA.x), 2) + pow((arcCenter.y - pointA.y), 2));
	
	for (int currentPoint = 0; currentPoint < pointsForLayer; currentPoint++){
		theta = angleA + (angleB - angleA)*(((float) currentPoint)/((float) pointsForLayer));
		xCoord = cos(theta)*radius + arcCenter.x;
		yCoord = sin(theta)*radius + arcCenter.y;
		[centers insertObject: [NSValue valueWithCGPoint: CGPointMake(xCoord, yCoord)] atIndex: currentPosition - 1];
		currentPosition++;
	}

	return currentPosition;
}


#pragma mark Finding_Neighbors 
/** Find the neighboring pieces for a position and adds them to neighborsForPosition **/
- (void) calculateConnectionsForPosition: (int) position{
	int neighborCount = 6;
	int positionInArray = position - 1;
	NSMutableArray *distances = [NSMutableArray arrayWithCapacity: 0];
	NSArray *potentialNeighbors;
	NSMutableSet *myNeighbors = [NSMutableSet setWithCapacity: 0];
	NSNumber *numberValue = [NSNumber numberWithInt: position];
	CGPoint center = [[centers objectAtIndex: positionInArray] CGPointValue];
	
	/* Figure out how many neighbors the position has */
	//check if this is a corner of the inner triangle
	if (position == 1 || position == [self positionsInTriangle: innerTriangleLength - 1] + 1 || position == [self positionsInTriangle: innerTriangleLength]){
		neighborCount -= 1;
	}
	
	//check if this is in the outer layer
	NSMutableArray * edges = [self positionsAtEdge: 0];
	if ([edges containsObject: numberValue]){
		neighborCount -= 2;
		
		//check if this is a corner
		if (layers == 0){
			if (neighborCount == 3)
				neighborCount -= 1;

		}else {
			int topPosition = [self positionsInTriangle: innerTriangleLength] + 1;
			int layerSize = layers + innerTriangleLength;
			if (position == topPosition || position == topPosition + layerSize || position == topPosition + 2 * layerSize){
				neighborCount -= 1;
			}
		}
	}

	potentialNeighbors = [self potentialNeighborsForPosition: position];
	/* Create an array of the other positions and their distance to this one */
	for (NSNumber *potentialNeighbor in potentialNeighbors){
		
		if (position != [potentialNeighbor intValue]){
			PositionDistance * pd = [[PositionDistance alloc] initWithPosition: potentialNeighbor
																	  Distance: [self distanceFrom: center 
																								to: [[centers objectAtIndex: ([potentialNeighbor intValue] - 1)] CGPointValue]]];
			[distances addObject: pd];
			[pd release];
		}
	}
	
	/* Sort the array of other position distances */
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey: @"myDistance" ascending: YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
	NSArray  *sortedDistances = [distances sortedArrayUsingDescriptors: sortDescriptors];
	
	/* Choose the right ammount of connections based on position type */
	for (int i = 0; i < neighborCount; i++){
		[myNeighbors addObject: [[sortedDistances objectAtIndex: i] myPosition]];
	}
	

	[neighborsForPosition setObject: myNeighbors forKey: numberValue];
}


#pragma mark Callables
- (void) addConnectionFrom: (int) posA to: (int) posB forPlayer: (BOOL) p1{
	[connectionsView addConnectionFrom: [[centers objectAtIndex: posA] CGPointValue] To: [[centers objectAtIndex: posB] CGPointValue] ForPlayer: p1];
	[connectionsView setNeedsDisplay];
}

- (void) removeConnectionFrom: (int) posA forPlayer: (BOOL) p1 {
	[connectionsView removeConnectionFrom: [[centers objectAtIndex: posA] CGPointValue] ForPlayer: p1];
	[connectionsView setNeedsDisplay];
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
- (NSMutableSet *) edgesForPosition: (NSNumber *) position{
	NSMutableSet *positionEdges = [NSMutableSet setWithCapacity: 0];
	//This is SOOOO cheap and inefficient, but I don't care. 
	if ([[self positionsAtEdge: 1] containsObject: position])
		[positionEdges addObject: [NSNumber numberWithInt: 1]];
	
	if ([[self positionsAtEdge: 2] containsObject: position])
		[positionEdges addObject: [NSNumber numberWithInt: 2]];
	
	if ([[self positionsAtEdge: 3] containsObject: position])
		[positionEdges addObject: [NSNumber numberWithInt: 3]];
	
	return positionEdges;
}




- (NSMutableArray *) positionsAtEdge: (int) edge{
	if (layers == 0)
		return [self trianglePositionsAtEdge: edge];
	else return [self layerPositionsAtEdge: edge];
}



#pragma mark Helpers
/** Checks if numB is a legit neighbor for numA **/
- (NSMutableArray *) potentialNeighborsForPosition: (int) pos{
	//figure out what layer this is
	int myLayer = [self layerForPos: pos];
	NSMutableArray *potentialNeighbors = [self positionsInLayer: myLayer];
	
	if (myLayer == 0){
		if (layers > 0)
			[potentialNeighbors addObjectsFromArray: [self positionsInLayer: myLayer + 1]];
	}else if (myLayer == layers){
		[potentialNeighbors addObjectsFromArray: [self positionsInLayer: myLayer - 1]];
	}else {
		[potentialNeighbors addObjectsFromArray: [self positionsInLayer: myLayer - 1]];
		[potentialNeighbors addObjectsFromArray: [self positionsInLayer: myLayer + 1]];
	}
	return potentialNeighbors;
}

/** returns the layer for a number **/
- (int) layerForPos: (int) pos{
	int lastPositionInLayer = [self positionsInTriangle: innerTriangleLength];
	
	if (layers == 0 || pos <= lastPositionInLayer)
		return 0;
	
	for (int i = layers; i > 0; i--){
		lastPositionInLayer += (i + innerTriangleLength) * 3;
		if (pos <= lastPositionInLayer)
			return i;
	}
	return 1;
}

/** Returns the positions along a given layer **/
- (NSMutableArray *) positionsInLayer: (int) layer{
	int start, end;
	NSMutableArray *positions = [NSMutableArray arrayWithCapacity: 0];
	
	//find the start point
	if (layer == 0)
		start = 1;
	else {
		start = [self positionsInTriangle: innerTriangleLength];
		for (int i = layers; i > layer; i--){
			start += (i + innerTriangleLength) * 3;
		}
		//makes up for the fact that we are starting on the next layer
		start += 1;
	}
	
	//find the end point
	if (layer == 0)
		end = [self positionsInTriangle: innerTriangleLength];
	else end = start + 3 * (layer + innerTriangleLength) - 1;
	
	//add all of the pieces
	for (int i = start; i <= end; i++)
		[positions addObject: [NSNumber numberWithInt: i]];
	
	return positions;
}


/** Utility function that solves for n! aka the positions in a triangle with side length n**/
- (int) positionsInTriangle: (int) triangleSideLength{
	int size = 0;
	for (int i = 1; i <= triangleSideLength + 1; i++)
		size += i;
	return size;
}


/** Utility function that finds the distance between two points **/
- (CGFloat) distanceFrom: (CGPoint) pointA to: (CGPoint) pointB{
	return sqrt(pow(pointA.x - pointB.x, 2) + pow(pointA.y - pointB.y, 2));
}


/** Returns positoins associated with the given edge in the outer layters, or the positions along all edges if edge != 1, 2, or 3 **/
- (NSMutableArray *) layerPositionsAtEdge: (int) edge{
	NSMutableArray * edgePositions = [NSMutableArray arrayWithCapacity: 0];
	int currentPosition;
	int firstPosition = [self positionsInTriangle: innerTriangleLength] + 1;
	
	switch (edge){
			//Add in positions along edge 1
		case 1:
			currentPosition = firstPosition + 2 * (innerTriangleLength + layers);
			[edgePositions addObject: [NSNumber numberWithInt: firstPosition]];
			for (int i = 0; i < (innerTriangleLength + layers); i++){
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
				currentPosition++;
			}
			break;
			//Add in positions along edge 2
		case 2:
			currentPosition = firstPosition + innerTriangleLength + layers;
			for (int i = 0; i <= (innerTriangleLength + layers); i++){
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
				currentPosition++;
			}
			break;
			//Add in positions along edge 3
		case 3:
			currentPosition = firstPosition;
			for (int i = 0; i <= (innerTriangleLength + layers); i++){
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
				currentPosition++;
			}
			break;
			//Add in positions along all edges
		default:
			currentPosition = firstPosition;
			for (int i = 0; i < 3*(innerTriangleLength + layers); i++){
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
				currentPosition++;
			}
			break;
	}
	return edgePositions;
}

/** Returns the positions associated with the given edge in the triangle, or the positions along all edges if edge != 1, 2, or 3 **/
- (NSMutableArray *) trianglePositionsAtEdge: (int) edge{
	NSMutableArray * edgePositions = [NSMutableArray arrayWithCapacity: 0];
	int currentPosition; 
	
	switch (edge){
			//Add in positions along edge 1
		case 1:
			currentPosition = 1;
			for (int i = 0; i <= innerTriangleLength; i++){
				currentPosition += i;
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
			}
			break;
			//Add in positions along edge 2
		case 2:
			currentPosition = [self boardSize] - innerTriangleLength;
			for (int i = 0; i <= innerTriangleLength; i++){
				currentPosition += i;
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
			}
			break;
			//Add in positions along edge 3
		case 3:
			currentPosition = 0;
			for (int i = 1; i <= innerTriangleLength + 1; i++){
				currentPosition += i;
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
			}
			break;
		default:
			[edgePositions addObject: [NSNumber numberWithInt: 1]];
			currentPosition = 2;
			for (int i = 1; i < innerTriangleLength; i++){
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
				currentPosition += i;
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
				currentPosition++;
			}
			for (int i = 0; i <= innerTriangleLength; i++){
				[edgePositions addObject: [NSNumber numberWithInt: currentPosition]];
				currentPosition ++;
			}
			break;
	}
	
	return edgePositions;
}


- (void)dealloc {
	//[centers release];
	//[neighborsForPosition release];
	//[connectionsView release];
    [super dealloc];
}

@end
