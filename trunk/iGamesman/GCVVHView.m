//
//  GCVVHView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCVVHView.h"

#import <QuartzCore/QuartzCore.h>

#import "GCUtilities.h"
#import "GCGameHistoryItem.h"


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
        [self setOpaque: YES];
        [self setClearsContextBeforeDrawing: YES];
        
        CATiledLayer *tiledLayer = (CATiledLayer *) [self layer];
        [tiledLayer setLevelsOfDetail: 5];
        [tiledLayer setLevelsOfDetailBias: 2];
    }
    
    return self;
}


- (void) setDataSource: (id<GCVVHViewDataSource>) dataSource
{
    _dataSource = dataSource;
}


- (void) reloadData
{
    [self setNeedsDisplay];
}


- (void) drawLayer: (CALayer *) layer inContext: (CGContextRef) ctx
{
    CGFloat x = [self bounds].origin.x;
    CGFloat y = [self bounds].origin.y;
    CGFloat width = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    NSInteger maxRemote = -1;
    NSEnumerator *enumerator = [_dataSource historyItemEnumerator];
    GCGameHistoryItem *historyItem;
    while (historyItem = [enumerator nextObject])
    {
        maxRemote = MAX(maxRemote, [historyItem remoteness]);
    }
    
    NSInteger slots = (NSInteger) ceil(maxRemote / 5.0f) * 5;
    NSInteger scale = 1;
    CGFloat step = (width / 2.0f - 20) / (slots + 1);
    
    while ((width/2.0 - 20) / (slots / 5) < 20)
    {
		scale *= 2;
		slots /= 2;
	}
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
        CGContextFillRect(ctx, [self bounds]);
        
        CGContextMoveToPoint(ctx, CGRectGetMaxX([self bounds]) - 1.5f, CGRectGetMinY([self bounds]));
        CGContextAddLineToPoint(ctx, CGRectGetMaxX([self bounds]) - 1.5f, 3 + (height - 480) / 2.0f);
        CGContextMoveToPoint(ctx, CGRectGetMaxX([self bounds]) - 1.5f, height - 3 - (height - 480) / 2.0f);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX([self bounds]) - 1.5f, CGRectGetMaxY([self bounds]));
        CGContextSetLineWidth(ctx, 3);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextStrokePath(ctx);
    }
    
	/* Flip drawing direction because of inverted coordinate system */
	CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSelectFont(ctx, "Helvetica", 11, kCGEncodingMacRoman);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextShowTextAtPoint(ctx, x + width/2.0 - 4, y + 35, "D", 1);
    
    
    for (int i = 0 ; i <= slots * scale; i += scale)
    {
		CGFloat x0 = step * i;
		
		if (i % 5 == 0)
        {
			// Major tick line
			CGContextSetRGBStrokeColor(ctx, 0.6f, 0.6f, 0.6f, 1);
		}
        else
        {
			// Minor tick line
			CGContextSetRGBStrokeColor(ctx, 0.25f, 0.25f, 0.25f, 1);
		}
        
        CGContextSetLineWidth(ctx, 1);
		
		// Left side line
		CGContextMoveToPoint(ctx, 20 + x0, y + 40);
		CGContextAddLineToPoint(ctx, 20 + x0, y + height);
		CGContextStrokePath(ctx);
		
		// Right side line
		CGContextMoveToPoint(ctx, width - 20 - x0, y + 40);
		CGContextAddLineToPoint(ctx, width - 20 - x0, y + height);
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
			CGContextShowTextAtPoint(ctx, width - 20 - textSize.width/2.0 - x0, y + 35, str, strlen(str));
		}
	}
    
    // Draw the center line
	CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
	CGContextSetLineWidth(ctx, 4.0);
	CGContextMoveToPoint(ctx, x + width/2.0, y + 40);
	CGContextAddLineToPoint(ctx, x + width/2.0, y + height);
	CGContextStrokePath(ctx);
    
    
    CGFloat currentRowY = 60.0f;
    CGFloat radius = 7;
    
    CGPoint previousCenters[2] = { CGPointZero, CGPointZero };
    NSUInteger previousCenterCount = 0;
    
    /* Loop through the history and draw the VVH */
    enumerator = [_dataSource historyItemEnumerator];
    GCGameHistoryItem *item;
    while (item = [enumerator nextObject])
    {
        NSInteger remoteness = [item remoteness];
        GCGameValue *value = [item value];
        BOOL left = ([item playerSide] == GC_PLAYER_LEFT);
        
        
        CGFloat leftX  = remoteness * step + 20;
        CGFloat rightX = width - (remoteness * step + 20);
        
        CGPoint centers[2] = { CGPointZero, CGPointZero };
        NSUInteger centerCount = 0;
        
        GCColor strokeColor = {0.0f, 0.0f, 0.0f};
        GCColor fillColor = {0.0f, 0.0f, 0.0f};
        CGFloat strokeAlpha = 0, fillAlpha = 0;
        if ([value isEqualToString: GCGameValueWin])
        {
            /* Win */
            centers[0] = CGPointMake(left ? leftX : rightX, currentRowY);
            centerCount = 1;
            
            strokeColor = [GCConstants loseColor];
            fillColor   = [GCConstants winColor];
            strokeAlpha = fillAlpha = 1;
        }
        else if ([value isEqualToString: GCGameValueLose])
        {
            /* Lose */
            centers[0] = CGPointMake(left ? rightX : leftX, currentRowY);
            centerCount = 1;

            strokeColor = [GCConstants winColor];
            fillColor   = [GCConstants loseColor];
            strokeAlpha = fillAlpha = 1;
        }
        else if ([value isEqualToString: GCGameValueDraw])
        {
            /* Draw */
            centers[0] = CGPointMake(width / 2.0f - radius, currentRowY);
            centers[1] = CGPointMake(width / 2.0f + radius, currentRowY);
            centerCount = 2;

            strokeColor = [GCConstants tieColor];
            fillColor   = [GCConstants tieColor];
            strokeAlpha = fillAlpha = 1;
        }
        else if ([value isEqualToString: GCGameValueTie])
        {
            /* Tie */
            centers[0] = CGPointMake(leftX, currentRowY);
            centers[1] = CGPointMake(rightX, currentRowY);
            centerCount = 2;
            
            strokeColor = [GCConstants tieColor];
            fillColor   = [GCConstants tieColor];
            strokeAlpha = fillAlpha = 1;
        }
        
        CGContextSetRGBStrokeColor(ctx, strokeColor.red, strokeColor.green, strokeColor.blue, strokeAlpha);
        CGContextSetRGBFillColor(ctx, fillColor.red, fillColor.green, fillColor.blue, fillAlpha);
        
        
        /* Draw the line(s) from the previous position to this position */
        if ((previousCenterCount == 1) && (centerCount == 1))
        {
            CGContextMoveToPoint(ctx, previousCenters[0].x, previousCenters[0].y);
            CGContextAddLineToPoint(ctx, centers[0].x, centers[0].y);
            
            CGContextStrokePath(ctx);
        }
        else if ((previousCenterCount == 1) && (centerCount == 2))
        {
            CGContextMoveToPoint(ctx, previousCenters[0].x, previousCenters[0].y);
            if (previousCenters[0].x < (width / 2.0f))
                CGContextAddLineToPoint(ctx, centers[0].x, centers[0].y);
            else
                CGContextAddLineToPoint(ctx, centers[1].x, centers[1].y);
            
            CGContextStrokePath(ctx);
        }
        else if ((previousCenterCount == 2) && (centerCount == 1))
        {
            if (left)
                CGContextMoveToPoint(ctx, previousCenters[0].x, previousCenters[0].y);
            else
                CGContextMoveToPoint(ctx, previousCenters[1].x, previousCenters[1].y);
            CGContextAddLineToPoint(ctx, centers[0].x, centers[0].y);
            
            CGContextStrokePath(ctx);
        }
        else if ((previousCenterCount == 2) && (centerCount == 2))
        {
            CGContextMoveToPoint(ctx, previousCenters[0].x, previousCenters[0].y);
            CGContextAddLineToPoint(ctx, centers[0].x, centers[0].y);
            CGContextMoveToPoint(ctx, previousCenters[1].x, previousCenters[1].y);
            CGContextAddLineToPoint(ctx, centers[1].x, centers[1].y);
            
            CGContextStrokePath(ctx);
        }
        
        
        /* Draw the circle(s) for this position */
        if (centerCount >= 1)
            CGContextFillEllipseInRect(ctx, CGRectMake(centers[0].x - radius, centers[0].y - radius, 2 * radius, 2 * radius));
        if (centerCount >= 2)
            CGContextFillEllipseInRect(ctx, CGRectMake(centers[1].x - radius, centers[1].y - radius, 2 * radius, 2 * radius));
        
        currentRowY += (10 + 2 * radius);
        
        /* Update the previous */
        previousCenters[0] = centers[0];
        previousCenters[1] = centers[1];
        previousCenterCount = centerCount;
    }
}


@end
