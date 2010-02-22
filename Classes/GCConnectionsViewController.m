    //
//  GCConnectionsViewController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/21/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectionsViewController.h"


@implementation GCConnectionsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (id) initWithSize: (int) _size {
	if (self = [super init]) {
		size = _size;
	}
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 416)];
	else
		self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 256)];
	
	self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];

	float squareSize;
	// Come back to this bit later after I figure out how tall the top
	// Row will be to make the move value bigger
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		squareSize = MIN(300.0 / size, 356.0 / size);
	else
		squareSize = MIN(236.0 / size, 380.0 / size);
	
	int tag = 1;
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			float x = i * squareSize;
			float y = j * squareSize;
			
			if (i % 2 == j % 2) {		// It's a slot (except the corners)
				if ( (i != 0 || j != 0) && (i != 0 || j != size-1) && (i != size-1 || j != 0) && (i != size-1 || j != size-1) ) {
					UIButton *button = [[UIButton buttonWithType: UIButtonTypeCustom]
										initWithFrame: CGRectMake(10 + x, 
																  10 + y, 
																  squareSize,  squareSize)];
					//[button setBackgroundColor: [UIColor whiteColor]];
					[button setTitle: [NSString stringWithFormat: @"%d", tag] forState: UIControlStateNormal];
					//[button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
					[self.view addSubview: button];
				}
			} else if (i % 2 == 0) {	// It's O
				UIImageView *O = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x, 10 + y, 
																				squareSize, 
																				squareSize)];
				[O setImage: [UIImage imageNamed: @"ConO.png"]];
				[self.view addSubview: O];
			} else {					// It's X
				UIImageView *X = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x, 10 + y, 
																				squareSize, 
																				squareSize)];
				[X setImage: [UIImage imageNamed: @"ConX.png"]];
				[self.view addSubview: X];
			}
			tag += 1;
		}
	}
}

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
