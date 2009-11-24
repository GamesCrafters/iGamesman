//
//  GCConnectFourOptions.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/16/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCConnectFourOptions.h"


@implementation GCConnectFourOptions

- (id) init {
	if (self = [super init]) {
		widths  = [[NSArray alloc] initWithObjects: @"4", @"5", @"6", @"7", nil];
		heights = [[NSArray alloc] initWithObjects: @"4", @"5", @"6", nil];
		currentlySelectedOptions = [[NSMutableArray alloc] initWithArray: [self defaultOptions]];
	}
	return self;
}

- (NSInteger) numberOfCategories {
	return 2;
}

- (NSString *) titleForCategory: (NSInteger) category {
	return (category == 0) ? @"Width" : @"Height";
}

- (NSInteger) numberOfChoicesInCategory: (NSInteger) category {
	return (category == 0) ? 4 : 3;
}

- (NSString *) titleForChoice: (NSInteger) choice inCategory: (NSInteger) category {
	if (category == 0)
		return (NSString *) [widths objectAtIndex: choice];
	else
		return (NSString *) [heights objectAtIndex: choice];
}

- (NSArray *) defaultOptions {
	return [NSArray arrayWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 1], nil];
}

- (NSArray *) getCurrentlySelectedOptions {
	return (NSArray *) currentlySelectedOptions;
}

- (void) setSelectedOptionAtIndex: (NSInteger) choice inCategory: (NSInteger) category {
	[currentlySelectedOptions replaceObjectAtIndex: category withObject: [NSNumber numberWithInt: choice]];
}

- (NSInteger) getWidth {
	int choice = [[currentlySelectedOptions objectAtIndex: 0] intValue];
	return [[widths objectAtIndex: choice] intValue];
}

- (NSInteger) getHeight {
	int choice = [[currentlySelectedOptions objectAtIndex: 1] intValue];
	return [[heights objectAtIndex: choice] intValue];
}

@end
