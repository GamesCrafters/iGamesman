//
//  GCVVHView.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 6/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCVVHView.h"


@implementation GCVVHView

@synthesize data;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	for (NSDictionary *entry in data) {
		NSLog(@"%@ %d %@", [[entry objectForKey: @"player"] isEqual: @"1"] ? @"Left" : @"Right", 
			  [[entry objectForKey: @"remoteness"] integerValue], [entry objectForKey: @"value"]);
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	CGContextSetLineWidth(context, 2.0);
	
	float x = self.frame.origin.x, y = self.frame.origin.y;
	float w = self.frame.size.width, h = self.frame.size.height;
	
	CGContextMoveToPoint(context, x + w/2.0, y + 20);
	CGContextAddLineToPoint(context, x + w/2.0, y + h);
	CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
