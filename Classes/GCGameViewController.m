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
@synthesize playPauseButton, slider;


- (id)initWithGame: (GCGame *) _game andPlayMode: (PlayMode) mode {
    if (self = [super initWithNibName: @"GameView" bundle: nil]) {
		game = _game;
		gameMode = mode;
		
		[game startGameInMode: gameMode];
		
		gameView = [game gameViewController];
		[self.view addSubview: gameView.view];
		
		/* Tell the game about the mode */
		
		gameControl = [[GCGameController alloc] initWithGame: game andViewController: self];
		//while (![game gameReady]);
		[gameControl go];
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
	[gameControl stop];
	[delegate flipsideViewControllerDidFinish: self];
}


- (void) playPause {
	if (![game primitive: [game getBoard]]) {
		if (gameControl.stopped) {
			[gameControl restart];
			[playPauseButton setImage: [UIImage imageNamed: @"Pause.png"]];
		} else {
			[gameControl stop];
			[playPauseButton setImage: [UIImage imageNamed: @"Resume.png"]];
		}
	}
}


- (void) stepForward {
	[gameControl redo];
}


- (void) stepBackward {
	[gameControl undo];
}


- (void) undoRedoSliderChanged: (UISlider *) sender {
	[slider setValue: round([slider value])];
	if (slider.value < gameControl.position)
		[gameControl undo];
	else if (slider.value > gameControl.position)
		[gameControl redo];
}


/** 
 Modally presents the option panel.
 */
- (void) changeOptions {
	wasPaused = [gameControl stopped];
	[gameControl stop];
	
	GCGameOptionsController *options = [[GCGameOptionsController alloc] initWithOrientation: [self interfaceOrientation]];
	options.delegate = self;
	options.mode = gameMode;
	options.delay = gameControl.DELAY;
	options.sliderOn = ([game player1Type] != HUMAN && [game player2Type] != HUMAN) ? YES : NO;
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
				   moveValues:(BOOL)moveValues
				computerDelay:(float) delay {
	[self dismissModalViewControllerAnimated: YES];
	[game setPredictions: predictions];
	[game setMoveValues: moveValues];
	//[game updateDisplay];
	gameControl.DELAY = delay;
	if (!wasPaused)
		[gameControl restart];
}


/* Dismisses the option panel after the user cancels. */
- (void) optionPanelDidCancel:(GCGameOptionsController *)controller {
	[self dismissModalViewControllerAnimated: YES];
	if (!wasPaused)
		[gameControl restart];
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
	[gameControl release];
    [super dealloc];
}


@end
