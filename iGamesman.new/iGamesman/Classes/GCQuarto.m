//
//  GCQuarto.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/3/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCQuarto.h"

#import "GCQuartoView.h"


@implementation GCQuarto

- (UIView *) viewWithFrame: (CGRect) frame
{
    return [[[GCQuartoView alloc] initWithFrame: frame] autorelease];
}

@end
