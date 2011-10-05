//
//  GCConnectFourPosition.h
//  iGamesman
//
//  Created by Jordan Salter on 05/10/2011.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCConnectFourPosition : NSObject <NSCopying> {
    BOOL                _p1Turn;
    NSMutableArray      *_board;
}

- (id)initWithWidth:(int)width height:(int)height;

@property (nonatomic, assign) BOOL              p1Turn;
@property (nonatomic, assign) NSMutableArray    *board;

@end
