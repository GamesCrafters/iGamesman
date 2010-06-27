//
//  GCVVHViewController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 6/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GCVVHViewController : UIViewController {
	UIInterfaceOrientation orientation;
	NSArray *data;
}

- (id) initWithVVHData: (NSArray *) _data andOrientation: (UIInterfaceOrientation) orient;

@end
