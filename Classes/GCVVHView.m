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
	int maxRemote = -1;
	for (NSDictionary *entry in data)
		maxRemote = MAX(maxRemote, [[entry objectForKey: @"remoteness"] integerValue]);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	float x = self.frame.origin.x, y = self.frame.origin.y;
	float w = self.frame.size.width, h = self.frame.size.height;
	
	CGContextSelectFont(context, "Helvetica", 11, kCGEncodingMacRoman);
	// Flip drawing direction because of inverted coordinate system
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextShowTextAtPoint(context, x + w/2.0 - 4, y + 35, "D", 1);
	
	CGContextSetLineWidth(context, 2.0);
	
	for (int i = 0 ; i <= maxRemote + 5; i += 1) {
		float x0 = ((w/2.0 - 20) / (maxRemote + 5)) * i;
		
		float dash[] = {5.0, 5.0};
		if (i % 5 == 0) {
			// Major tick line
			CGContextSetLineDash(context, 0, NULL, 0);
			CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
		} else {
			// Minor tick line
			CGContextSetLineDash(context, 0, dash, 2);
			CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1);
		}
		
		// Left side line
		CGContextMoveToPoint(context, 20 + x0, y + 40);
		CGContextAddLineToPoint(context, 20 + x0, y + h);
		CGContextStrokePath(context);
		
		// Right side line
		CGContextMoveToPoint(context, w - 20 - x0, y + 40);
		CGContextAddLineToPoint(context, w - 20 - x0, y + h);
		CGContextStrokePath(context);
		
		if (x0 != w/2.0 - 20 && i % 5 == 0) { // Only label major tick lines (and not the center)
			CGContextSetTextDrawingMode(context, kCGTextFill);
			const char *str = [[NSString stringWithFormat: @"%d", i] UTF8String];
			
			// Left side label
			CGContextShowTextAtPoint(context, 17 + x0, y + 35, str, strlen(str));
			
			// Right side label
			CGContextShowTextAtPoint(context, w - 23 - x0, y + 35, str, strlen(str));
		}
	}
	
	// Draw the center line
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	CGContextSetLineWidth(context, 4.0);
	CGContextSetLineDash(context, 0, NULL, 0);
	CGContextMoveToPoint(context, x + w/2.0, y + 40);
	CGContextAddLineToPoint(context, x + w/2.0, y + h);
	CGContextStrokePath(context);
	
	const char *leftStr = [[NSString stringWithFormat: @"<--- %@ (Red) Winning", p1Name] UTF8String];
	const char *rightStr = [[NSString stringWithFormat: @"%@ (Blue) Winning --->", p2Name] UTF8String];
	CGContextShowTextAtPoint(context, 10, y + 15, leftStr, strlen(leftStr));
	CGContextShowTextAtPoint(context, w - 10 - 5 * strlen(rightStr), y + 15, rightStr, strlen(rightStr));
	
	float step = (w/2.0 - 20) / (maxRemote + 5); // Number of points per one step in remoteness
	int y1 = 60;
	
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	
	for (int i = 0; i < [data count]; i += 1) {
		NSDictionary *entry = (NSDictionary *) [data objectAtIndex: i];
		int remoteness = [[entry objectForKey: @"remoteness"] integerValue];
		NSString *value = [[entry objectForKey: @"value"] uppercaseString];
		BOOL left = [[entry objectForKey: @"player"] isEqual: @"1"];
	
		float leftX  = remoteness * step + 20;
		float rightX = w - 20 - remoteness * step;
		float r = 7; // radius
		
		if ([value isEqual: @"WIN"]) {
			CGContextSetRGBFillColor(context, 0, 1, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake((left ? leftX : rightX) - r, y1 - r, 2*r, 2*r));
			CGContextStrokeEllipseInRect(context, CGRectMake((left ? leftX : rightX) - r, y1 - r, 2*r, 2*r));
		} else if ([value isEqual: @"LOSE"]) {
			CGContextSetRGBFillColor(context, 139.0/255.0, 0, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake((left ? rightX : leftX) - r, y1 - r, 2*r, 2*r));
			CGContextStrokeEllipseInRect(context, CGRectMake((left ? rightX : leftX) - r, y1 - r, 2*r, 2*r));
		} else if ([value isEqual: @"DRAW"]) {
			CGContextSetRGBFillColor(context, 1, 1, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake(w/2.0 - 2*r, y1 - r, 2*r, 2*r));
			CGContextFillEllipseInRect(context, CGRectMake(w/2.0, y1 - r, 2*r, 2*r));
			CGContextStrokeEllipseInRect(context, CGRectMake(w/2.0 - 2*r, y1 - r, 2*r, 2*r));
			CGContextStrokeEllipseInRect(context, CGRectMake(w/2.0, y1 - r, 2*r, 2*r));
		} else if ([value isEqual: @"TIE"]) {
			CGContextSetRGBFillColor(context, 1, 1, 0, 1);
			CGContextFillEllipseInRect(context, CGRectMake(leftX - r, y1 - r, 2*r, 2*r));
			CGContextFillEllipseInRect(context, CGRectMake(rightX - r, y1 - r, 2*r, 2*r));
			CGContextStrokeEllipseInRect(context, CGRectMake(leftX - r, y1 - r, 2*r, 2*r));
			CGContextStrokeEllipseInRect(context, CGRectMake(rightX - r, y1 - r, 2*r, 2*r));
		}
		
		y1 += 5 + 2 * r;
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
