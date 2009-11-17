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
	int playerNum;
	UITextField *nameField;
}

@property (nonatomic, assign) id <NameChangeDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *nameField;

- (id) initWithPlayerNumber: (NSInteger) num;

@end


@protocol NameChangeDelegate

- (void) nameChangerDidCancel;
- (void) nameChangerDidFinishWithPlayer: (NSInteger) playerNum andNewName: (NSString *) name;

@end

