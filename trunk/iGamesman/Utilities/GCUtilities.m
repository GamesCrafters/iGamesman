//
//  GCUtilities.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCUtilities.h"

#import "GCGame.h"

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



@implementation GCValuesHelper

+ (NSArray *) sortedValuesForMoveValues: (NSArray *) moveValues remotenesses: (NSArray *) remotenesses
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity: [moveValues count]];
    
    /* Split into win, tie, draw, and lose buckets */
    NSMutableArray *wins  = [[NSMutableArray alloc] initWithCapacity: [moveValues count]];
    NSMutableArray *ties  = [[NSMutableArray alloc] initWithCapacity: [moveValues count]];
    NSMutableArray *draws = [[NSMutableArray alloc] initWithCapacity: [moveValues count]];
    NSMutableArray *loses = [[NSMutableArray alloc] initWithCapacity: [moveValues count]];
    
    for (int i = 0; i < [moveValues count]; i += 1)
    {
        GCGameValue *value = [moveValues objectAtIndex: i];
        NSNumber *remoteness = [remotenesses objectAtIndex: i];
        NSArray *pair = [NSArray arrayWithObjects: value, remoteness, nil];
        
        if ([value isEqualToString: GCGameValueWin])
            [wins addObject: pair];
        else if ([value isEqualToString: GCGameValueTie])
            [ties addObject: pair];
        else if ([value isEqualToString: GCGameValueDraw])
            [draws addObject: pair];
        else if ([value isEqualToString: GCGameValueLose])
            [loses addObject: pair];
    }
    
    /* Sort the wins bucket first */
    [wins sortUsingComparator: ^(id a, id b)
     {
         NSNumber *left = [(NSArray *) a objectAtIndex: 1];
         NSNumber *right = [(NSArray *) b objectAtIndex: 1];
         
         return [left compare: right];
     }];
    
    
    /* Sort the ties bucket */
    [ties sortUsingComparator: ^(id a, id b)
     {
         NSNumber *left = [(NSArray *) a objectAtIndex: 1];
         NSNumber *right = [(NSArray *) b objectAtIndex: 1];
         
         return [right compare: left];
     }];
    
    
    /* No need to sort the draws bucket. Draw positions don't have a remoteness value */
    
    
    /* Sort the loses bucket */
    [loses sortUsingComparator: ^(id a, id b)
     {
         NSNumber *left = [(NSArray *) a objectAtIndex: 1];
         NSNumber *right = [(NSArray *) b objectAtIndex: 1];
         
         return [right compare: left];
     }];
    
    
    for (NSArray *pair in wins)
        [result addObject: pair];
    for (NSArray *pair in ties)
        [result addObject: pair];
    for (NSArray *pair in draws)
        [result addObject: pair];
    for (NSArray *pair in loses)
        [result addObject: pair];
    
    
    [wins release];
    [ties release];
    [draws release];
    [loses release];
    
    /* Remove duplicates */
    int count = 0;
    while (count < [result count])
    {
        NSArray *pair = [result objectAtIndex: count];
        
        NSMutableIndexSet *toRemoveIndexSet = [[NSMutableIndexSet alloc] init];
        
        for (int i = count + 1; i < [result count]; i += 1)
        {
            NSArray *next = [result objectAtIndex: i];
            if ([next isEqualToArray: pair])
                [toRemoveIndexSet addIndex: i];
        }
        
        [result removeObjectsAtIndexes: toRemoveIndexSet];
        [toRemoveIndexSet release];
        
        count += 1;
    }
    
    return [result autorelease];
}

@end
