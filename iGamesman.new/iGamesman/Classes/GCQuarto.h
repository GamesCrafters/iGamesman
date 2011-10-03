//
//  GCQuarto.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/3/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

@interface GCQuarto : NSObject <GCGame>
{
    NSMutableArray *board;
    NSMutableArray *pieces;
}

@end
