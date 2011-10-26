//
//  GCConnectFourPosition.h
//  iGamesman
//
//  Created by Jordan Salter on 05/10/2011.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCConnectFourPosition : NSObject <NSCopying> {
    int                 _width, _height, _pieces;
    BOOL                _p1Turn;
    NSMutableArray      *_board;
}

- (id)initWithWidth:(int)width height:(int)height pieces:(int)pieces;

@property (nonatomic, assign) BOOL              p1Turn;
@property (nonatomic, assign) NSMutableArray    *board;
@property (readonly)          int               width, height, pieces;

@end
