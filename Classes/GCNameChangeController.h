//
//  GCNameChangeController.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/10/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NameChangeDelegate;

@interface GCNameChangeController : UIViewController {
	id <NameChangeDelegate> delegate;
}

@property (nonatomic, assign) id <NameChangeDelegate> delegate;

@end


@protocol NameChangeDelegate

- (void) nameChangerDidCancel;

@end

