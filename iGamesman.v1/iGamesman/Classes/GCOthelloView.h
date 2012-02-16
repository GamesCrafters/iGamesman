//
//  GCOthelloView.h
//  iGamesman
//
//  Created by Class Account on 10/24/10.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GCOthelloView : UIView {
	int rows, cols;
    id delegate;
}

-(id) initWithFrame:(CGRect)frame andRows: (int) r andCols:(int) c;

@end
