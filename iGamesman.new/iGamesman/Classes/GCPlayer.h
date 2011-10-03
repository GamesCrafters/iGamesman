//
//  GCPlayer.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/28/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { HUMAN, COMPUTER } PlayerType;

@interface GCPlayer : NSObject
{
    NSString *_name;
    PlayerType _type;
    CGFloat _percentPerfect;
}

- (NSString *) name;
- (void) setName: (NSString *) name;
- (PlayerType) type;
- (void) setType: (PlayerType) type;
/* Percent perfect: floating-point value in range [0,100] */
- (CGFloat) percentPerfect;
- (void) setPercentPerfect: (CGFloat) percentPerfect;

@end
