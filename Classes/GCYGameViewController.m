//
//  GCYGameViewController.m
//  GamesmanMobile
//
//  Created by Linsey Hansen on 3/7/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCYGameViewController.h"


@implementation GCYGameViewController

- (id) initWithLayers: (int) layers{
	switch (layers){
		case 0:
			self = [super initWithNibName:@"GCYBoardView0" bundle: nil];
			break;
		case 1:
			self = [super initWithNibName:@"GCYBoardView1" bundle: nil];
			break;
		case 2:
			self = [super initWithNibName:@"GCYBoardView2" bundle: nil];
			break;
		default:
			self = nil;
			break;
	}
	
	return self;
}


- (id) initWithGame: (GCYGame *) _game{
	if (self = [super init]){
		game = _game;
		
		switch  (game.layers){
			case 0:
				self = [super initWithNibName:@"GCYBoardView0" bundle: nil];
				break;
			case 1:
				self = [super initWithNibName:@"GCYBoardView1" bundle: nil];
				break;
			case 2:
				self = [super initWithNibName:@"GCYBoardView2" bundle: nil];
				break;
			default:
				self = nil;
				break;
		}
	}
	return self;
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
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


- (void)dealloc {
    [super dealloc];
}


@end
