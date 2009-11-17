//
//  GCConnectFourOptions.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/16/09.
//  Copyright 2009 Kevin Jorgensen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GCConnectFourOptions : NSObject {
	NSArray *widths, *heights;
}

- (NSInteger) numberOfCategories;
- (NSString *) titleForCategory: (NSInteger) category;
- (NSInteger) numberOfChoicesInCategory: (NSInteger) category;
- (NSString *) titleForChoice: (NSInteger) choice inCategory: (NSInteger) category;

@end
