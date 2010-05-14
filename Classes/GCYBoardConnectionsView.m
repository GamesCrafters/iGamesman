//
//  GCYBoardConnectionsView.m
//  GamesmanMobile
//
//  Created by Class Account on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYBoardConnectionsView.h"


#pragma mark YConnection Class
@implementation YNeighbors

- (id) newNeighborsA: (NSNumber *) posA neighborB: (NSNumber *) posB{
	if (posA < posB){
		positionA = posA;
		positionB = posB;
	}else{
		positionA = posB;
		positionB = posA;
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

@end


@implementation YConnection
@synthesize pointA, pointB;

- (id) initWithPointA: (CGPoint *) pA andPointB: (CGPoint *) pB{
	pointA = pA;
	pointB = pB;
	return self;
}

- (void)dealloc {
    [super dealloc];
}

@end


#pragma mark GCYBoardConnectionsView Class
@implementation GCYBoardConnectionsView
@synthesize p1Connections, p2Connections;
@synthesize p1Color, p2Color;
@synthesize p1Count, p2Count;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        p1Connections = [[NSMutableArray alloc] init];
		p2Connections = [[NSMutableArray alloc] init];
		p1Color = [UIColor redColor];
		p2Color = [UIColor blueColor];
		p1Count = 0;
		p2Count = 0;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) addConnectionFrom: (CGPoint *) point1 To: (CGPoint *) point2 ForPlayer: (BOOL) player1{
	YConnection *connection = [[YConnection alloc] initWithPointA: point1 andPointB: point2];
	if (player1)
		[p1Connections addObject: connection];
	else
		[p2Connections addObject: connection];
	
	[connection release];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code for all of the connections... yay!
	
	//Animate new connections
	if (p1Count <  [p1Connections count]){
		//animate new p1Connections
	}
	
	if (p2Count < [p2Connections count]){
		//animate new p2 Connections
	}
	
	//Draw old connections
	for (int i = 0; i < p1Count; i++){
		//draw old p1 Connections
	}
	
	for (int i = 0; i < p2Count; i++){
		//draw old p2 connections
	}
	
	p1Count = [p1Connections count];
	p2Count = [p1Connections count];
}


- (void)dealloc {
	[p1Connections release];
	[p2Connections release];
    [super dealloc];
}


@end
