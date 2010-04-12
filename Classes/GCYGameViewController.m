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
			
			for (int i = 1; i < 16; i++){
				UIButton *button = (UIButton *) [self.view viewWithTag: i];
				[button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
			} 
			break;
		case 1:
			self = [super initWithNibName:@"GCYBoardView1" bundle: nil];
			
			for (int i = 1; i < 31; i++){
				UIButton *button = (UIButton *) [self.view viewWithTag: i];
				[button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
			} 
			break;
		case 2:
			self = [super initWithNibName:@"GCYBoardView2" bundle: nil];
			
			for (int i = 1; i < 49; i++){
				UIButton *button = (UIButton *) [self.view viewWithTag: i];
				[button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
			} 
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
				
//				for (int i = 1; i < 16; i++){
//					UIView *button = [self.view viewWithTag: i];
//					if ([button isKindOfClass: [UIButton class]]){
//						NSLog(@"altering %d", i);
//						[(UIButton *) button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
//					}
//				} 
				break;
			case 1:
				self = [super initWithNibName:@"GCYBoardView1" bundle: nil];
				
//				for (int i = 1; i < 31; i++){
//					UIView *button = [self.view viewWithTag: i];
//					if ([button isKindOfClass: [UIButton class]])
//						[(UIButton *) button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
//				} 
				break;
			case 2:
				self = [super initWithNibName:@"GCYBoardView2" bundle: nil];
				
//				for (int i = 1; i < 49; i++){
//					UIView *button = [self.view viewWithTag: i];
//					if ([button isKindOfClass: [UIButton class]])
//						[(UIButton *) button addTarget: self	action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
//				} 
				break;
			default:
				self = nil;
				break;
		}
	}
	return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self disableButtons];
}


- (void) doMove: (NSNumber *) move {
	NSLog(@"do move: %d", move);
	UIButton *B = (UIButton *) [self.view viewWithTag: [move integerValue]];
	//[B retain];
	//[B removeFromSuperview];
	//[self.view insertSubview: B atIndex: 0];
	//[B release];
	//float B_width = B.frame.size.width;
	//B.frame = CGRectMake(B.center.x - B_width / 4, B.center.y - B_width / 4, B_width / 2, B_width / 2);
	[B setBackgroundImage: [UIImage imageNamed: (game.p1Turn ? @"C4X.png" : @"C4O.png")] forState: UIControlStateNormal];
	
	// do the board animations here (ie piece and connection animations)
//	UIImageView *image = [[UIImageView alloc] initWithImage: (game.p1Turn? @"ConX.png" : @"ConO.png")];
//	[UIView beginAnimations: @"Stretch" context: NULL];
//	for (NSNumber *neighbor in [[game positionConnections] objectForKey: move]){
//		int neighborAsInt = [neighbor integerValue];
//		if (([[game getBoard] objectAtIndex: neighborAsInt] == X && game.p1Turn) || [[game getBoard] objectAtIndex: neighborAsInt] == O && !game.p1Turn){
//			UIButton *neighborButton = (UIButton *) [self.view viewWithTag: neighborAsInt];
//			image.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//		}
//	}
//	[UIView commitAnimations];
}


- (IBAction) tapped: (UIButton *) button{
	NSLog(@"tapped");
	NSNumber * num = [NSNumber numberWithInt: button.tag];
	if([[game legalMoves] containsObject: num]){
		NSLog(@"posting human move");
		[game postHumanMove: num];
	}
}


/** Convenience method for disabling all of the board's buttons. */
- (void) disableButtons {
	switch (game.layers){
		case 0:
			for (int i = 1; i < 16; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: NO];
			} 
			break;
		case 1:
			for (int i = 1; i < 31; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: NO];
			} 
			break;
		case 2:
			for (int i = 1; i < 49; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: NO];
			} 
			break;
		default:
			break;
	}
}


- (void) enableButtons {
	switch (game.layers){
		case 0:
			for (int i = 1; i < 16; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: YES];
			} 
			break;
		case 1:
			for (int i = 1; i < 31; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: YES];
			} 
			break;
		case 2:
			for (int i = 1; i < 49; i++){
				UIView *button = (UIButton *) [self.view viewWithTag: i];
				if ([button isKindOfClass: [UIButton class]])
					[(UIButton *) button setEnabled: YES];
			} 
			break;
		default:
			break;
	}
}

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
