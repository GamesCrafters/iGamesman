    //
//  GCOthelloView.m
//  GamesmanMobile
//
//  Created by Class Account on 10/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCOthelloView.h"
#define PADDING 5

@implementation GCOthelloView



-(id) initWithFrame:(CGRect)frame andRows: (int) r andCols: (int) c {
	if ((self = [super initWithFrame:frame])) {
		rows = r;
		cols = c;
		self.opaque = NO;
		self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 102.0/256.0 alpha: 1];
	}
	return self;
}

- (void) drawRect:(CGRect) rect {
	CGFloat w = self.bounds.size.width;
	CGFloat h = self.bounds.size.height;
	
	CGFloat size = MIN((w-(2*PADDING))/cols, (h- (80+PADDING))/rows);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//Making Green Rectangle Background
	//CGContextSetRGBFillColor(ctx, 0, .5, 0, 1);
	UIImage *bg = [UIImage imageNamed: @"379.jpg"];
	[bg drawInRect:CGRectMake(PADDING, PADDING, cols*size, rows*size)];
	//[background setFrame: CGRectMake(PADDING, PADDING, cols*size, rows*size)];
	//[self addSubview:background];
	//CGContextFillRect(ctx, CGRectMake(PADDING, PADDING, cols*size, rows*size));
	
	//Draw lines within Rectangle
	
	CGContextSetLineWidth(ctx, 1);
	CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
	
	for (int i = 0; i <= cols; i += 1) {
		CGContextMoveToPoint(ctx, PADDING + size * i, PADDING);
		CGContextAddLineToPoint(ctx, PADDING + size * i, PADDING + size * rows);
	}
	
	for (int j = 0; j <= rows; j += 1) {
		CGContextMoveToPoint(ctx, PADDING, PADDING + size * j);
		CGContextAddLineToPoint(ctx, PADDING + size * cols, PADDING + size * j);
	}
	
	CGContextStrokePath(ctx);
	
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
