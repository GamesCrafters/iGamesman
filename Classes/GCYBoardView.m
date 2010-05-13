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
@synthesize position, distance;

- (id) initWithPosition: (int) pos Distance: (CGFloat) dist{
	position = [NSNumber numberWithInt: pos];
	distance = dist;
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
	[self createBoardView];
    return self;
}


#pragma mark Drawing_Stuff

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

/** Draws the connections on the conectionsView when pieces of the same color are placed next to each other **/
- (void) drawConnections{
}




#pragma mark Create_Board

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
	
}

- (int) centersAlongLayer: (int) layer fromPointA: (CGPoint) pointA toPointB: (CGPoint) pointB withCenter: (CGPoint) arcCenter 
	   startingAtPosition: (int) position{
	CGFloat temp;
	CGFloat theta;
	CGFloat radius;
	CGFloat xCoord, yCoord;
	int currentPosition = position;
	int pointsForLayer;
	
	CGFloat angleA = atan2(pointA.y - arcCenter.y, pointA.x - arcCenter.x);
	CGFloat angleB = atan2(pointB.y - arcCenter.y, pointB.x - arcCenter.x);
	
	if (angleB > angleA){
		temp = angleA;
		angleA = angleB;
		angleB = temp;
	}
	
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



/** Find the neighboring pieces for a position and adds them to neighborsForPosition **/
- (void) calculateConnectionsForPosition: (int) position inLayerPosition: (int) layerPosition forLayer: (int) layer{
	NSMutableSet * neighbors;
	
	if (layer == 0)
		[self calculateConnectionsForInnerPosition: position];
	else if (layerPosition == 0)
		[self calculateConnectionsForCornerPosition: position forLayer: layer];
	else
		[self calculateConnectionsForLayerPosition: position];
	
}


- (void) calculateConnectionsForPosition: (int) position{
	BOOL outsideEdge = NO;
	BOOL corner = NO;
	BOOL innerCorner = NO;
	NSMutableArray * distances;
	NSMutableSet * neighbors = [NSMutableSet setWithCapacity: 0];
	
	/* Figure out what type of position this is */
	//check if this is a corner of the inner triangle
	if (position == 1 || position == [self positionsInTriangle: innerTriangleLength - 1] + 1 || position == [self positionsInTriangle: innerTriangleLength])
		innerCorner == YES;
	
	//check if this is in the outer layer
	if (layers == 0){
		
	}else if (position == 0){
		//check if this is an outer corner
	}
	
	/* Create an array of the other positions and their distance to this one */
	
	/* Sort the array of other positions */
	
	/* Choose the right ammount of connections based on position type */
	
}

- (CGFloat) distanceFrom: (CGPoint) pointA to: (CGPoint) pointB{
	
}

- (void) calculateConnectionsForInnerPosition: (int) position inRow: (int) row inColumn: (int) column{
	NSMutableSet * neighbors = [NSMutableSet setWithCapacity: 0];
	
	/* handle corners */
	if (row == 0){ //upper corner
		//top neighbors
		
		//side neighbors
		
		//bottom neighbors
		
	} else if (column == innerTriangleLength){ //right corner
		//top neighbors
		
		//side neighbors
		
		//bottom neighbors
		
	} else if (row == innerTriangleLength && column == 0){ //left corner
		//top neighbors
		
		//side neighbors
		
		//bottom neighbors
	}
	
	/* handle sides */
	else if (column == 0){ //left side
		//top neighbors
		
		//side neighbors
		
		//bottom neighbors
		
	}else if (column == row){ //right side
		//top neighbors
		
		//side neighbors
		
		//bottom neighbors
		
	}else if (row == innerTriangleLength){ //bottom
		//top neighbors
		
		//side neighbors
		
		//bottom neighbors
		
	}
	
	/* handle insides */
	else{
		//top neighbors
		[neighbors addObject: [NSNumber numberWithInt: position - row]];
		[neighbors addObject: [NSNumber numberWithInt: position - (row + 1)]];
		
		//side neighbors
		[neighbors addObject: [NSNumber numberWithInt: position + 1]];
		[neighbors addObject: [NSNumber numberWithInt: position - 1]];
		
		//bottom neighbors
		[neighbors addObject: [NSNumber numberWithInt: position + row + 1]];
		[neighbors addObject: [NSNumber numberWithInt: position + row + 2]];
	}
	
	[neighborsForPosition setObject: neighbors forKey: [NSNumber numberWithInt: position]];
}


- (void) calculateConnectionsForCornerPosition: (int) position forLayer: (int) layer{
}

- (void) calculateConnectionsForLayerPosition: (int) position{
}


#pragma mark Class_Callable_Functions


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

/** Returns the positions associated with the given edge in the triangle, or the positions along all edges for edge -1 **/
- (NSMutableSet *) trianglePositionsAtEdge: (int) edge{
}


- (void)dealloc {
	[centers release];
	[neighborsForPosition release];
	[connectionsView release];
    [super dealloc];
}

@end
