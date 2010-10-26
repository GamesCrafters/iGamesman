    //
//  GCOthelloViewController.m
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCOthelloViewController.h"
#import "GCOthelloView.h"

#define PADDING 5



@implementation GCOthelloViewController

@synthesize touchesEnabled;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id) initWithGame: (GCOthello *) _game {
	if (self = [super init]) {
		game = _game;
	}
	return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (touchesEnabled) {		
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
		
		CGFloat size = MIN((w - 2*PADDING)/game.cols, (h - 80+PADDING)/game.rows);
		
		UITouch *theTouch = [touches anyObject];
		CGPoint loc = [theTouch locationInView: self.view];
		
		if (CGRectContainsPoint(CGRectMake(PADDING, PADDING, size * game.cols, size * game.rows), loc)) {
			int col = (loc.x - PADDING) / size;
			int row = (loc.y - PADDING) / size;
			
			CGRect rect = CGRectMake(PADDING + col * size, PADDING + row * size, size, size);
			NSArray *myFlips = [game getFlips:(col + row*game.cols)];
			if ([myFlips count] > 0){
				UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"C4X.png" : @"C4O.png"]];
				[piece setFrame: rect];
				piece.tag = 55555;
				[self.view addSubview: piece];
				for (NSNumber *flip in myFlips) {
					UIImageView *image = [self.view viewWithTag:1000 + [flip intValue]];
					[image setImage:[UIImage imageNamed: game.p1Turn ? @"C4X.png" : @"C4O.png"]];
				}
				[game postHumanMove: [NSNumber numberWithInt: col + row*game.cols]];
			}
		}
	}
}

- (void) doMove:(NSNumber *)move {
	if ((game.p1Turn) ? ([game player1Type] != HUMAN) : ([game player2Type] != HUMAN)) {
		UIImageView *piece = [[UIImageView alloc] initWithImage: [UIImage imageNamed: game.p1Turn ? @"C4X.png" : @"C4O.png"]];
		int col = [move intValue] % game.cols;
		int row = [move intValue] / game.cols;
		CGFloat w = self.view.bounds.size.width;
		CGFloat h = self.view.bounds.size.height;
		CGFloat size = MIN((w - PADDING)/game.cols, (h - (80+ PADDING))/game.rows);
		
		[piece setFrame: CGRectMake(PADDING	+ col * size, PADDING + row * size, size, size)];
		piece.tag = 1000 + [move intValue];
		[self.view addSubview: piece];
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[GCOthelloView alloc] initWithFrame: CGRectMake(0, 0, 320, 416) andRows: game.rows andCols: game.cols];
	
	CGFloat w = self.view.bounds.size.width;
	CGFloat h = self.view.bounds.size.height;
	
	CGFloat size = MIN((w - PADDING*2)/game.cols, (h - (80+ PADDING))/game.rows);
	int col = game.cols/2 -1;
	int row = game.rows/2 -1;
	
	
	UIImageView *piece1 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"C4X.png"]];
	UIImageView *piece2 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"C4O.png"]];
	
	UIImageView *piece3 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"C4O.png"]];
	UIImageView *piece4 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"C4X.png"]];
	[piece1 setFrame: CGRectMake(PADDING + col * size, PADDING + row * size, size, size)];
	piece1.tag = 1000 + row*game.cols + col;
	[self.view addSubview: piece1];
	[piece2 setFrame: CGRectMake(PADDING	+ (col+1) * size, PADDING + row * size, size, size)];
	piece2.tag = 1000 + row*game.cols + col +1;
	[self.view addSubview: piece2];
	[piece3 setFrame: CGRectMake(PADDING	+ col * size, PADDING + (row +1) * size, size, size)];
	piece3.tag = 1000 + (row+1)*game.cols + col;
	[self.view addSubview: piece3];
	[piece4 setFrame: CGRectMake(PADDING	+ (col +1) * size, PADDING + (row+1) * size, size, size)];
	piece4.tag = 1000 + (row+1)*game.cols + col+1;
	[self.view addSubview: piece4];
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
