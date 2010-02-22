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
	
	/*
	UIButton *button = [[UIButton buttonWithType: UIButtonTypeCustom]
						initWithFrame: CGRectMake(30, 30, 60, 60)];
	[button setBackgroundColor: [UIColor whiteColor]];
	[self.view addSubview: button];
	UIImageView *X = [[UIImageView alloc] initWithFrame: CGRectMake(0, 45, 30, 30)];
	[X setImage: [UIImage imageNamed: @"X.png"]];
	[self.view addSubview: X];
	UIImageView *O = [[UIImageView alloc] initWithFrame: CGRectMake(45, 0, 30, 30)];
	[O setImage: [UIImage imageNamed: @"O.png"]];
	[self.view addSubview: O];*/
	
	float squareSize;
	// Come back to this bit later after I figure out how tall the top
	// Row will be to make the move value bigger
	if ([self interfaceOrientation] == UIInterfaceOrientationPortrait)
		squareSize = MIN(300.0 / (size + 1.0/3), 356.0 / (size + 1.0/3) );
	else
		squareSize = MIN(236.0 / (size + 1.0/3), 380.0 / (size + 1.0/3) );
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			float x = i * squareSize;
			float y = j * squareSize;
			UIButton *button = [[UIButton buttonWithType: UIButtonTypeCustom]
								initWithFrame: CGRectMake(10 + 1.0/3.0 * squareSize + x, 
														  10 + 1.0/3.0 * squareSize + y, 
														  2.0/3.0 * squareSize,  2.0/3.0 * squareSize)];
			[button setBackgroundColor: [UIColor whiteColor]];
			[self.view addSubview: button];
			
			UIImageView *X = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x, 10 + y + 1.0/2.0 * squareSize, 
																			1.0/3.0 * squareSize, 
																			1.0/3.0 * squareSize)];
			[X setImage: [UIImage imageNamed: @"X.png"]];
			[self.view addSubview: X];
			
			UIImageView *O = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x + 1.0/2.0 * squareSize, 10 + y, 
																			1.0/3.0 * squareSize, 
																			1.0/3.0 * squareSize)];
			[O setImage: [UIImage imageNamed: @"O.png"]];
			[self.view addSubview: O];
		}
		
		float x = size * squareSize;
		float y = j * squareSize;
		
		UIImageView *X = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x, 10 + y + 1.0/2.0 * squareSize, 
																		1.0/3.0 * squareSize, 
																		1.0/3.0 * squareSize)];
		[X setImage: [UIImage imageNamed: @"X.png"]];
		[self.view addSubview: X];
	}
	
	for (int i = 0; i < size; i += 1) {
		float x = i * squareSize;
		float y = size * squareSize;
		UIImageView *O = [[UIImageView alloc] initWithFrame: CGRectMake(10 + x + 1.0/2.0 * squareSize, 10 + y, 
																		1.0/3.0 * squareSize, 
																		1.0/3.0 * squareSize)];
		[O setImage: [UIImage imageNamed: @"O.png"]];
		[self.view addSubview: O];
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
