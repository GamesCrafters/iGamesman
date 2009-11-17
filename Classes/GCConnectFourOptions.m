//
//  GCConnectFourOptions.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/16/09.
//  Copyright 2009 Kevin Jorgensen. All rights reserved.
//

#import "GCConnectFourOptions.h"


@implementation GCConnectFourOptions

- (id) init {
	if (self = [super init]) {
		widths  = [[NSArray alloc] initWithObjects: @"4", @"5", @"6", @"7", nil];
		heights = [[NSArray alloc] initWithObjects: @"4", @"5", @"6", nil];
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

@end
