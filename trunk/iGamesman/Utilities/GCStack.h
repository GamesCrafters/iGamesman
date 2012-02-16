//
//  GCStack.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/23/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCStack : NSObject

- (BOOL) isEmpty;
- (NSUInteger) count;
- (void) push: (id) object;
- (id) peek;
- (void) pop;
- (void) flush;

@end
