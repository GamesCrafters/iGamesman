//
//  GCGameViewController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/29/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCGameViewController.h"
#import "GCGame.h"


@implementation GCGameViewController

@synthesize delegate;


- (id)initWithGame: (GCGame *) _game andPlayMode: (PlayMode) mode {
    if (self = [super initWithNibName: @"GameView" bundle: nil]) {
		game = _game;
		
		gameView = [game gameViewController];
		[self.view addSubview: gameView.view];
		
		/* Tell the game about the mode */
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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [gameView shouldAutorotateToInterfaceOrientation: interfaceOrientation];
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
	GCGameOptionsController *options = [[GCGameOptionsController alloc] initWithOrientation: [self interfaceOrientation]];
	options.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: options];
	nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	nav.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
	[options release];
	[self presentModalViewController: nav animated: YES];
	[nav release];
}


/* Cleans up after the option panel finishes (with updated values). */
- (void) optionPanelDidFinish:(GCGameOptionsController *)controller 
				  predictions:(BOOL)predictions 
				   moveValues:(BOOL)moveValues {
	[self dismissModalViewControllerAnimated: YES];
	SEL updater = @selector(updateDisplayOptions:);
	NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys: 
							 [NSNumber numberWithBool: predictions], @"predictions",
							 [NSNumber numberWithBool: moveValues], @"movevalues", nil];
	/* Notify the game that the display options have changed */
}


/* Dismisses the option panel after the user cancels. */
- (void) optionPanelDidCancel:(GCGameOptionsController *)controller {
	[self dismissModalViewControllerAnimated: YES];
}


/* Returns YES if showing predictions, NO if not */
- (BOOL) showingPredictions {
	return [game predictions];
}


/* Returns YES if showing move values, NO if not */
- (BOOL) showingMoveValues {
	return [game moveValues];
}


- (void)dealloc {
    [super dealloc];
}


@end
