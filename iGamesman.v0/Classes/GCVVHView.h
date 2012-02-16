//
//  GCVVHView.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 6/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GCVVHView : UIView {
	NSArray *data;
	NSString *p1Name, *p2Name;
}

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSString *p1Name, *p2Name;

@end
