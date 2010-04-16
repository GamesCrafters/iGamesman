//
//  GCYBoardView.m
//  GamesmanMobile
//
//  Created by Class Account on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCYBoardView.h"
#import "GCYGame.h"

@implementation GCYBoardView
@synthesize game;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		p1Connectors = [[NSMutableArray alloc] initWithObjects: nil];
		p2Connectors = [[NSMutableArray alloc] initWithObjects: nil];
    }
    return self;
}


- (void) doMove: (NSNumber *) move{
	CGPoint begin;
	CGPoint end;
	UIButton *button;
	
	if (game.p1Turn){
		for (NSNumber *position in [[game positionConnections] objectForKey: move]){
			if ([game boardContainsPlayerPiece: @"X" forPosition: position]){
				button = (UIButton *) [[[game yGameView] view] viewWithTag: [move integerValue]];
				begin = [button center];
				button = (UIButton *) [[[game yGameView] view] viewWithTag: [position integerValue]];
				end = [button center];
				[p1Connectors addObject: [NSSet setWithObjects: [NSValue valueWithCGPoint: begin], [NSValue valueWithCGPoint: end], nil]];
			}
		}
	}
	else{
		for (NSNumber *position in [[game positionConnections] objectForKey: move]){
			if ([game boardContainsPlayerPiece: @"O" forPosition: position]){
				button = (UIButton *) [[[game yGameView] view] viewWithTag: [move integerValue]];
				begin = [button center];
				button = (UIButton *) [[[game yGameView] view] viewWithTag: [position integerValue]];
				end = [button center];
				[p2Connectors addObject: [NSSet setWithObjects: [NSValue valueWithCGPoint: begin], [NSValue valueWithCGPoint: end], nil]];
			}
		}
	}
}

		
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGPoint *begin;
	CGPoint *end;
	
//	for (NSSet *link in p1Connectors){
//		begin = [[link objectAtIndex: 0] CGPointValue];
//		end = [[link objectAtIndex: 0] CGPointValue];
//	}
//	
//	for (NSSet *link in p2Connectors){
//		begin = [[link objectAtIndex: 0] CGPointValue];
//		end = [[link objectAtIndex: 0] CGPointValue];
//	}
	
    
}


- (void)dealloc {
	[p1Connectors release];
	[p2Connectors release];
    [super dealloc];
}


@end
