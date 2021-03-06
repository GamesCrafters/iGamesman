//
//  GCVVHView.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 6/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCVVHView.h"
#import <QuartzCore/QuartzCore.h>


@implementation GCVVHView

@synthesize data;
@synthesize p1Name, p2Name;


+ (Class) layerClass {
    return [CATiledLayer class];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
		
		CATiledLayer *tempTiledLayer = (CATiledLayer*)self.layer;
        tempTiledLayer.levelsOfDetail = 5;
        tempTiledLayer.levelsOfDetailBias = 2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	// Real drawing code in -drawLayer:inContext:
}

- (void) drawLayer: (CALayer*) layer inContext: (CGContextRef) context {
	int maxRemote = -1;
	for (NSDictionary *entry in data)
		maxRemote = MAX(maxRemote, [[entry objectForKey: @"remoteness"] integerValue]);
	
	CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	CGContextFillRect(context, self.bounds);
	
	float x = self.bounds.origin.x, y = self.bounds.origin.y;
	float w = self.bounds.size.width, h = self.bounds.size.height;
	
	CGContextSelectFont(context, "Helvetica", 11, kCGEncodingMacRoman);
	// Flip drawing direction because of inverted coordinate system
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	
	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextShowTextAtPoint(context, x + w/2.0 - 4, y + 35, "D", 1);
	
	CGContextSetLineWidth(context, 2.0);
	
	int slots = (int) ceil(maxRemote / 5.0) * 5;
	int scale = 1;
	float step = (w/2.0 - 20) / (slots + 1); // Number of points (x) per one step in remoteness
	
	while ((w/2.0 - 20) / (slots / 5) < 20) {
		scale *= 2;
		slots /= 2;
	}
	
	for (int i = 0 ; i <= slots * scale; i += scale) {
		float x0 = step * i;
		
		float dash[] = {5.0, 5.0};
		if (i % 5 == 0) {
			// Major tick line
			CGContextSetLineDash(context, 0, NULL, 0);
			CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
		} else {
			// Minor tick line
			CGContextSetLineDash(context, 0, dash, 2);
			CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1);
		}
		
		// Left side line
		CGContextMoveToPoint(context, 20 + x0, y + 40);
		CGContextAddLineToPoint(context, 20 + x0, y + h);
		CGContextStrokePath(context);
		
		// Right side line
		CGContextMoveToPoint(context, w - 20 - x0, y + 40);
		CGContextAddLineToPoint(context, w - 20 - x0, y + h);
		CGContextStrokePath(context);
		
		// Only label major tick lines (and not the center line)
		if (i % 5 == 0 && i != slots * scale) {
			CGContextSetTextDrawingMode(context, kCGTextFill);
			const char *str = [[NSString stringWithFormat: @"%d", i] UTF8String];
			
			CGSize textSize = [[NSString stringWithCString: str encoding: NSUTF8StringEncoding] sizeWithFont: [UIFont systemFontOfSize: 11]];
			
			// Left side label
			CGContextShowTextAtPoint(context, 20 - textSize.width/2.0 + x0, y + 35, str, strlen(str));
			
			// Right side label
			CGContextShowTextAtPoint(context, w - 20 - textSize.width/2.0 - x0, y + 35, str, strlen(str));
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
	
	int y1 = 60;
	
	CGPoint previous[2] = {};
	int prevCount = 0;
	NSString *prevValue = nil;
	
	int WIDTH = 3;
	float r = 7; // radius
	
	for (int i = 0; i < [data count]; i += 1) {
		NSDictionary *entry = (NSDictionary *) [data objectAtIndex: i];
		int remoteness = [[entry objectForKey: @"remoteness"] integerValue];
		NSString *value = [[entry objectForKey: @"value"] uppercaseString];
		BOOL left = [[entry objectForKey: @"player"] isEqual: @"1"];
		
		float leftX  = remoteness * step + 20;
		float rightX = w - 20 - remoteness * step;
		
		// First draw the connecting line
		if ([value isEqual: @"WIN"]) {
			// Choose points for the connecting line
			CGPoint start, end;
			if (prevCount == 1)
				start = previous[0];
			else if (prevCount == 2)
				start = left ? previous[0] : previous[1];
			end   = CGPointMake(left ? leftX : rightX, y1);
			
			// Draw the connecting line
			if (prevCount) {
				CGContextSetRGBStrokeColor(context, 139.0/255.0, 0, 0, 1);
				CGContextSetLineWidth(context, WIDTH);
				CGContextMoveToPoint(context, start.x, start.y);
				CGContextAddLineToPoint(context, end.x, end.y);
				CGContextStrokePath(context);
			}
			
			// Draw the previous circle(s)
			if (prevCount) {
				CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
				if ([prevValue isEqual: @"WIN"])
					CGContextSetRGBFillColor(context, 0, 1, 0, 1);
				else if ([prevValue isEqual: @"LOSE"])
					CGContextSetRGBFillColor(context, 139.0/255.0, 0, 0, 1);
				else
					CGContextSetRGBFillColor(context, 1, 1, 0, 1);
				
				CGContextSetLineWidth(context, 1);
				CGContextFillEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				CGContextStrokeEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				
				if (prevCount == 2) {
					CGContextFillEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
					CGContextStrokeEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
				}
			}
			
			// Update "previous" data
			previous[0] = CGPointMake(left ? leftX : rightX, y1);
			prevCount = 1;
			prevValue = @"WIN";
		} else if ([value isEqual: @"LOSE"]) {
			// Choose points for the connecting line
			CGPoint start, end;
			if (prevCount == 1)
				start = previous[0];
			else if (prevCount == 2)
				start = left ? previous[1] : previous[0];
			end = CGPointMake(left ? rightX : leftX, y1);
			
			if (prevCount) {
				CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
				CGContextSetLineWidth(context, WIDTH);
				CGContextMoveToPoint(context, start.x, start.y);
				CGContextAddLineToPoint(context, end.x, end.y);
				CGContextStrokePath(context);
			}
			
			// Draw the previous circle(s)
			if (prevCount) {
				CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
				if ([prevValue isEqual: @"WIN"])
					CGContextSetRGBFillColor(context, 0, 1, 0, 1);
				else if ([prevValue isEqual: @"LOSE"])
					CGContextSetRGBFillColor(context, 139.0/255.0, 0, 0, 1);
				else
					CGContextSetRGBFillColor(context, 1, 1, 0, 1);
				
				CGContextSetLineWidth(context, 1);
				CGContextFillEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				CGContextStrokeEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				
				if (prevCount == 2) {
					CGContextFillEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
					CGContextStrokeEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
				}
			}
			
			// Update "previous" data
			previous[0] = CGPointMake(left ? rightX : leftX, y1);
			prevCount = 1;
			prevValue = @"LOSE";
		} else if ([value isEqual: @"DRAW"]) {
			// Choose points for the connections lines
			CGPoint start0, start1, end0, end1;
			if (prevCount == 1) {
				start0 = previous[0];
				end0 = left ? CGPointMake(w/2.0 + r, y1) : CGPointMake(w/2.0 - r, y1);
			} else if (prevCount == 2) {
				start0 = previous[0];
				start1 = previous[1];
				end0   = CGPointMake(w/2.0 - r, y1);
				end1   = CGPointMake(w/2.0 + r, y1);
			}
			
			// Draw the previous circle(s)
			if (prevCount) {
				CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
				if ([prevValue isEqual: @"WIN"])
					CGContextSetRGBFillColor(context, 0, 1, 0, 1);
				else if ([prevValue isEqual: @"LOSE"])
					CGContextSetRGBFillColor(context, 139.0/255.0, 0, 0, 1);
				else
					CGContextSetRGBFillColor(context, 1, 1, 0, 1);
				
				CGContextSetLineWidth(context, 1);
				CGContextFillEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				CGContextStrokeEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				
				if (prevCount == 2) {
					CGContextFillEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
					CGContextStrokeEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
				}
			}
			
			// Update "previous" data
			previous[0] = CGPointMake(w/2.0 - r, y1);
			previous[1] = CGPointMake(w/2.0 + r, y1);
			prevCount = 2;
			prevValue = @"TIE";
		} else if ([value isEqual: @"TIE"]) {
			// Choose points for the connecting lines
			CGPoint start0, start1, end0, end1;
			if (prevCount == 1) {
				start0 = previous[0];
				end0 = left ? CGPointMake(rightX, y1) : CGPointMake(leftX, y1);
			} else if (prevCount == 2) {
				start0 = previous[0];
				start1 = previous[1];
				end0   = CGPointMake(leftX, y1);
				end1   = CGPointMake(rightX, y1);
			}
			
			if (prevCount) {
				CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
				CGContextSetLineWidth(context, WIDTH);
				CGContextMoveToPoint(context, start0.x, start0.y);
				CGContextAddLineToPoint(context, end0.x, end0.y);
				if (prevCount == 2) {
					CGContextMoveToPoint(context, start1.x, start1.y);
					CGContextAddLineToPoint(context, end1.x, end1.y);
				}
				CGContextStrokePath(context);
			}
			
			// Draw the previous circle(s)
			if (prevCount) {
				CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
				if ([prevValue isEqual: @"WIN"])
					CGContextSetRGBFillColor(context, 0, 1, 0, 1);
				else if ([prevValue isEqual: @"LOSE"])
					CGContextSetRGBFillColor(context, 139.0/255.0, 0, 0, 1);
				else
					CGContextSetRGBFillColor(context, 1, 1, 0, 1);
				
				CGContextSetLineWidth(context, 1);
				CGContextFillEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				CGContextStrokeEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
				
				if (prevCount == 2) {
					CGContextFillEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
					CGContextStrokeEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
				}
			}
			
			// Update "previous" data
			previous[0] = CGPointMake(leftX, y1);
			previous[1] = CGPointMake(rightX, y1);
			prevCount = 2;
			prevValue = @"TIE";
		}
		
		y1 += 5 + 2 * r;
	}
	
	// Draw the last circle(s)
	if (prevCount) {
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
		if ([prevValue isEqual: @"WIN"])
			CGContextSetRGBFillColor(context, 0, 1, 0, 1);
		else if ([prevValue isEqual: @"LOSE"])
			CGContextSetRGBFillColor(context, 139.0/255.0, 0, 0, 1);
		else
			CGContextSetRGBFillColor(context, 1, 1, 0, 1);
		
		CGContextSetLineWidth(context, 1);
		CGContextFillEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
		CGContextStrokeEllipseInRect(context, CGRectMake(previous[0].x - r, previous[0].y - r, 2*r, 2*r));
		
		if (prevCount == 2) {
			CGContextFillEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
			CGContextStrokeEllipseInRect(context, CGRectMake(previous[1].x - r, previous[1].y - r, 2*r, 2*r));
		}
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
