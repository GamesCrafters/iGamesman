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
@synthesize p1Name, p2Name;


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
	
	int maxRemote = -1;
	for (NSDictionary *entry in data)
		maxRemote = MAX(maxRemote, [[entry objectForKey: @"remoteness"] integerValue]);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	CGContextSetLineWidth(context, 4.0);
	
	float x = self.frame.origin.x, y = self.frame.origin.y;
	float w = self.frame.size.width, h = self.frame.size.height;
	
	CGContextMoveToPoint(context, x + w/2.0, y + 40);
	CGContextAddLineToPoint(context, x + w/2.0, y + h);
	CGContextStrokePath(context);
	
	CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
	// Flip drawing direction because of inverted coordinate system
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextShowTextAtPoint(context, x + w/2.0 - 4, y + 35, "D", 1);
	
	CGContextSetLineWidth(context, 2.0);
	
	for (int i = 0; i <= maxRemote/5 + 1; i += 1) {
		float x0 = ((w/2.0 - 20) / (maxRemote + 5)) * i * 5;
		// Left side line
		CGContextMoveToPoint(context, 20 + x0, y + 40);
		CGContextAddLineToPoint(context, 20 + x0, y + h);
		CGContextStrokePath(context);
		
		// Right side line
		CGContextMoveToPoint(context, w - 20 - x0, y + 40);
		CGContextAddLineToPoint(context, w - 20 - x0, y + h);
		CGContextStrokePath(context);
		
		if (x0 != w/2.0 - 20) { // We don't want to label the center with a value
			CGContextSetTextDrawingMode(context, kCGTextFill);
			const char *str = [[NSString stringWithFormat: @"%d", i * 5] UTF8String];
			
			// Left side label
			CGContextShowTextAtPoint(context, 17 + x0, y + 35, str, strlen(str));
			
			// Right side label
			CGContextShowTextAtPoint(context, w - 23 - x0, y + 35, str, strlen(str));
		}
	}
	
	const char *leftStr = [[NSString stringWithFormat: @"<<<< %@ Winning", p1Name] UTF8String];
	const char *rightStr = [[NSString stringWithFormat: @"%@ Winning >>>>", p2Name] UTF8String];
	CGContextShowTextAtPoint(context, 10, y + 15, leftStr, strlen(leftStr));
	CGContextShowTextAtPoint(context, w - 10 - 6.5 * strlen(rightStr), y + 15, rightStr, strlen(rightStr));
	
	float step = (w/2.0 - 20) / (maxRemote + 5); // Number of points per one step in remoteness
	int y1 = 60;
	
	for (int i = 0; i < [data count]; i += 1) {
		NSDictionary *entry = (NSDictionary *) [data objectAtIndex: i];
		int remoteness = [[entry objectForKey: @"remoteness"] integerValue];
		NSString *value = [[entry objectForKey: @"value"] uppercaseString];
		BOOL left = [[entry objectForKey: @"player"] isEqual: @"1"];
	
		float leftX  = remoteness * step + 20;
		float rightX = w - 20 - remoteness * step;
		float r = 10; // radius
		
		if ([value isEqual: @"WIN"]) {
			CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
			CGContextSetRGBFillColor(context, 0, 1, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake((left ? leftX : rightX) - r, y1 - r, 2*r, 2*r));
		} else if ([value isEqual: @"LOSE"]) {
			CGContextSetRGBStrokeColor(context, 139.0/255.0, 0, 0, 1);
			CGContextSetRGBFillColor(context, 139.0/255.0, 0, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake((left ? rightX : leftX) - r, y1 - r, 2*r, 2*r));
		} else if ([value isEqual: @"DRAW"]) {
			CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
			CGContextSetRGBFillColor(context, 1, 1, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake(w/2.0 - 2*r, y1 - r, 2*r, 2*r));
			CGContextFillEllipseInRect(context, CGRectMake(w/2.0, y1 - r, 2*r, 2*r));
		} else if ([value isEqual: @"TIE"]) {
			CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
			CGContextSetRGBFillColor(context, 1, 1, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake(leftX - r, y1 - r, 2*r, 2*r));
			CGContextFillEllipseInRect(context, CGRectMake(rightX - r, y1 - r, 2*r, 2*r));
		}
		
		y1 += 25;
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
