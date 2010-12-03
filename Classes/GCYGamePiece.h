//
//  GCYGamePiece.h
//  GamesmanMobile
//
//  Created by Class Account on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GCYGamePiece : UIButton{
	UIImageView		*playerPiece;
	UIImageView		*moveValue;
}

@property (nonatomic, retain) UIImageView *playerPiece;
@property (nonatomic, retain) UIImageView *moveValue;

- (void) makeMove: (BOOL) p1;
- (void) moveCenter: (CGPoint) centerPoint;
- (void) undoMove;

@end
