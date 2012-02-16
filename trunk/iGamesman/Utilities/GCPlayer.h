//
//  GCPlayer.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum { GC_HUMAN, GC_COMPUTER } GCPlayerType;


@interface GCPlayer : NSObject
{
    NSString *name;
    NSString *epithet;
    GCPlayerType type;
    CGFloat percentPerfect;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *epithet;
@property (nonatomic, assign) GCPlayerType type;
@property (nonatomic, assign) CGFloat percentPerfect;

@end
