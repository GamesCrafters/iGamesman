//
//  GCNameChangeController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 11/10/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGame.h"


@protocol PlayerChangeDelegate;

@interface GCPlayerChangeController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	id <PlayerChangeDelegate> delegate;
	GCGame *game;
	int playerNum;
	UITextField *nameField;
	UIPickerView *typePicker;
}

@property (nonatomic, assign) id <PlayerChangeDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UIPickerView *typePicker;

- (id) initWithPlayerNumber: (NSInteger) num andGame: (GCGame *) _game;

@end


@protocol PlayerChangeDelegate

- (void) nameChangerDidCancel;
- (void) nameChangerDidFinishWithPlayer: (NSInteger) playerNum 
								newName: (NSString *) name 
						  andPlayerType: (PlayerType) type;

@end

