//
//  GCGameViewController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/29/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCGameViewController.h"
#import "GCConnectFourViewController.h"
#import "GCGameOptionsController.h"


@implementation GCGameViewController

@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//gameView = [[GCConnectFourViewController alloc] initWithNibName: @"Connect4" bundle: nil];
		//[self.view addSubview: gameView.view];
		gameView = [[GCConnectFourViewController alloc] initWithWidth: 5 height: 5 pieces: 4];
		[self.view addSubview: gameView.view];
		showPredictions = YES;
		showMoveValues = YES;
    }
    return self;
}


/*
- (void)loadView {	
}
*/

/*
- (void)viewDidLoad { [super viewDidLoad]; }
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

/** 
 Messages this view's delegate to dismiss me. 
 */
- (void) done {
	[delegate flipsideViewControllerDidFinish: self];
}


/** 
 Modally presents the option panel.
 */
- (void) changeOptions {
	GCGameOptionsController *options = [[GCGameOptionsController alloc] initWithStyle: UITableViewStyleGrouped];
	options.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: options];
	nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[options release];
	[self presentModalViewController: nav animated: YES];
	[nav release];
}


/* Cleans up after the option panel finishes (with updated values). */
- (void) optionPanelDidFinish:(GCGameOptionsController *)controller 
				  predictions:(BOOL)predictions 
				   moveValues:(BOOL)moveValues {
	[self dismissModalViewControllerAnimated: YES];
	showPredictions = predictions;
	showMoveValues = moveValues;
	SEL updater = @selector(updateDisplayOptions:);
	NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys: 
							 [NSNumber numberWithBool: showPredictions], @"predictions",
							 [NSNumber numberWithBool: showMoveValues], @"movevalues", nil];
	if ([gameView respondsToSelector: updater])
		[gameView performSelector: updater withObject: options];
}


/* Dismisses the option panel after the user cancels. */
- (void) optionPanelDidCancel:(GCGameOptionsController *)controller {
	[self dismissModalViewControllerAnimated: YES];
}


/* Returns YES if showing predictions, NO if not */
- (BOOL) showingPredictions {
	return showPredictions;
}


/* Returns YES if showing move values, NO if not */
- (BOOL) showingMoveValues {
	return showMoveValues;
}


- (void)dealloc {
    [super dealloc];
}


@end
