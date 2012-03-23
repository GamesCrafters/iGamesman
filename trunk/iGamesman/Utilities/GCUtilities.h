//
//  GCConstants.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>


struct _GCColor {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
};

typedef struct _GCColor GCColor;


@interface GCConstants : NSObject

+ (GCColor) winColor;
+ (GCColor) loseColor;
+ (GCColor) tieColor;
+ (GCColor) drawColor;

@end



@interface GCValuesHelper : NSObject

+ (NSArray *) sortedValuesForMoveValues: (NSArray *) moveValues remotenesses: (NSArray *) remotenesses;

@end
