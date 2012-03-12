//
//  GCConstants.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConstants.h"

@implementation GCConstants

+ (GCColor) winColor
{
    GCColor color = { 0.0f, 1.0f, 0.0f };
    return color;
}


+ (GCColor) loseColor
{
    GCColor color = { 139.0f / 255.0f, 0.0f, 0.0f };
    return color;
}


+ (GCColor) tieColor
{
    GCColor color = { 1.0f, 1.0f, 0.0f };
    return color;
}


+ (GCColor) drawColor
{
    GCColor color = { 1.0f, 1.0f, 0.0f };
    return color;
}

@end
