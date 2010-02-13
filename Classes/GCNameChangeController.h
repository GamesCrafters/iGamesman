//
//  GCNameChangeController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 11/10/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum { HUMAN, COMPUTER } PlayerType;

@protocol NameChangeDelegate;

@interface GCNameChangeController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	id <NameChangeDelegate> delegate;
	int playerNum;
	UITextField *nameField;
	UIPickerView *typePicker;
}

@property (nonatomic, assign) id <NameChangeDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UIPickerView *typePicker;

- (id) initWithPlayerNumber: (NSInteger) num;

@end


@protocol NameChangeDelegate

- (void) nameChangerDidCancel;
- (void) nameChangerDidFinishWithPlayer: (NSInteger) playerNum 
								newName: (NSString *) name 
						  andPlayerType: (PlayerType) type;

@end

