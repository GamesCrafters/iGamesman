//
//  GCVVHView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCVVHView.h"

#import <QuartzCore/QuartzCore.h>

@implementation GCVVHView

+ (Class) layerClass
{
    return [CATiledLayer class];
}

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.opaque = NO;
        self.clearsContextBeforeDrawing = YES;
        
        CATiledLayer *tiledLayer = (CATiledLayer *) self.layer;
        tiledLayer.levelsOfDetail = 5;
        tiledLayer.levelsOfDetailBias = 2;
    }
    
    return self;
}


- (void) drawLayer: (CALayer *) layer inContext: (CGContextRef) ctx
{    
    CGFloat x = self.bounds.origin.x;
    CGFloat y = self.bounds.origin.y;
	CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    NSInteger maxRemote = 20;
    
    NSInteger slots = (NSInteger) ceil(maxRemote / 5.0f) * 5;
    NSInteger scale = 1;
    CGFloat step = (w / 2.0f - 20) / (slots + 1);
    
    while ((w/2.0 - 20) / (slots / 5) < 20)
    {
		scale *= 2;
		slots /= 2;
	}
    
    
//    CGContextSetRGBFillColor(ctx, 0, 0, 84.0f / 255.0f, 1);
//    CGContextFillRect(ctx, [self bounds]);
    
	// Flip drawing direction because of inverted coordinate system
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSelectFont(ctx, "Helvetica", 11, kCGEncodingMacRoman);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextShowTextAtPoint(ctx, x + w/2.0 - 4, y + 35, "D", 1);
    
    
    for (int i = 0 ; i <= slots * scale; i += scale)
    {
		float x0 = step * i;
		
		float dash[] = {5.0, 5.0};
		if (i % 5 == 0)
        {
			// Major tick line
			CGContextSetLineDash(ctx, 0, NULL, 0);
			CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
		}
        else
        {
			// Minor tick line
			CGContextSetLineDash(ctx, 0, dash, 2);
			CGContextSetRGBStrokeColor(ctx, 0.7f, 0.7f, 0.7f, 1);
		}
		
		// Left side line
		CGContextMoveToPoint(ctx, 20 + x0, y + 40);
		CGContextAddLineToPoint(ctx, 20 + x0, y + h);
		CGContextStrokePath(ctx);
		
		// Right side line
		CGContextMoveToPoint(ctx, w - 20 - x0, y + 40);
		CGContextAddLineToPoint(ctx, w - 20 - x0, y + h);
		CGContextStrokePath(ctx);
		
		// Only label major tick lines (and not the center line)
		if (i % 5 == 0 && i != slots * scale)
        {
			CGContextSetTextDrawingMode(ctx, kCGTextFill);
            CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
			const char *str = [[NSString stringWithFormat: @"%d", i] UTF8String];
			
			CGSize textSize = [[NSString stringWithCString: str encoding: NSUTF8StringEncoding] sizeWithFont: [UIFont systemFontOfSize: 11]];
			
			// Left side label
			CGContextShowTextAtPoint(ctx, 20 - textSize.width/2.0 + x0, y + 35, str, strlen(str));
			
			// Right side label
			CGContextShowTextAtPoint(ctx, w - 20 - textSize.width/2.0 - x0, y + 35, str, strlen(str));
		}
	}
    
    // Draw the center line
	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
	CGContextSetLineWidth(ctx, 4.0);
	CGContextSetLineDash(ctx, 0, NULL, 0);
	CGContextMoveToPoint(ctx, x + w/2.0, y + 40);
	CGContextAddLineToPoint(ctx, x + w/2.0, y + h);
	CGContextStrokePath(ctx);
}


@end
