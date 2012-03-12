//
//  GCGamesScrollView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 12/29/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCGamesScrollView.h"


CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh);
CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh);


@interface GCGamesScrollView ()
{
    CGFloat imageSize;
    CGFloat cellWidth;
}

- (void) tileGamesFromMinimumX: (CGFloat) minimumVisibleX toMaximumX: (CGFloat) maximumVisibleX;
- (UIImage *) reflectedImage: (UIImageView *) fromImage withHeight: (NSUInteger) height;

@end



@implementation GCGamesScrollView

- (NSDictionary *) centerGame
{
    UIView *centerView = nil;
    CGFloat nearestDistance = 2 << 10;
    for (UIView *cellView in [self subviews])
    {
        CGPoint center = [cellView center];
        CGFloat distance = fabs(([self frame].size.width / 2.0f) + [self contentOffset].x - center.x);
        
        if (distance < nearestDistance)
        {
            nearestDistance = distance;
            centerView = cellView;
        }
    }
    
    NSDictionary *result = nil;
    if (centerView)
    {
        NSUInteger index = [_visibleGames indexOfObject: centerView];
        result = [_visibleGameInfos objectAtIndex: index];
    }
    
    return result;
}


#pragma mark - Memory lifecycle

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *gameInfoPath = [mainBundle pathForResource: @"Games" ofType: @"plist"];
        
        _gameInfos = [[NSArray arrayWithContentsOfFile: gameInfoPath] mutableCopy];
        _visibleGameInfos = [[NSMutableArray alloc] init];
        
        _visibleGames = [[NSMutableArray alloc] init];
        
        
        [self setContentSize: CGSizeMake(frame.size.width * 5, frame.size.height)];
        
        [self setShowsHorizontalScrollIndicator: NO];
        [self setShowsVerticalScrollIndicator: NO];
        
        imageSize = frame.size.height * (2.0f / 3.0f);
        cellWidth = frame.size.height;
    }
    
    return self;
}


- (void) dealloc
{
    [_gameInfos release];
    [_visibleGames release];
    
    [super dealloc];
}


#pragma mark - Layout

- (void) recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth  = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0f;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0f))
    {
        [self setContentOffset: CGPointMake(centerOffsetX, currentOffset.y)];
        
        for (UIView *subview in [self subviews])
        {
            CGPoint center = [subview center];
            center.x += (centerOffsetX - currentOffset.x);
            [subview setCenter: center];
        }
    }
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    
    CGRect visibleBounds = [self bounds];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileGamesFromMinimumX: minimumVisibleX toMaximumX: maximumVisibleX];
    
    
    for (UIView *cellView in _visibleGames)
    {
        CGPoint center = cellView.center;
        CGFloat offsetFromCenter = fabs((center.x - [self contentOffset].x) - [self bounds].size.width / 2.0f);
        CGFloat alpha = 1 - (offsetFromCenter / ([self bounds].size.width * 0.75f));
        [cellView setAlpha: alpha];
    }
}


#pragma mark - Tiling

- (CGFloat) placeGameOnRight: (CGFloat) rightEdge
{
    NSDictionary *entry = [_gameInfos objectAtIndex: 0];
    NSString *imageName = [entry objectForKey: @"image"];
    NSString *gameName  = [entry objectForKey: @"name"];
    
    [_visibleGameInfos addObject: entry];
    [_gameInfos removeObjectAtIndex: 0];
    
    UIView *cellView = [[UIView alloc] initWithFrame: CGRectMake(rightEdge, 0, cellWidth, cellWidth)];
    
    UIImageView *gameView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: imageName]];
    
    CGRect frame = CGRectMake((cellWidth - imageSize) / 2.0f, 0, imageSize, imageSize);
    [gameView setFrame: frame];
    
    [cellView addSubview: gameView];
    
    UIImage *reflectedImage = [self reflectedImage: gameView withHeight: cellWidth - imageSize - 25];
    [gameView release];
    
    UIImageView *reflectedView = [[UIImageView alloc] initWithImage: reflectedImage];
    [reflectedView setFrame: CGRectMake((cellWidth - imageSize) / 2.0f, imageSize + 25, imageSize, cellWidth - imageSize - 25)];
    [reflectedView setAlpha: 0.5f];
    
    [cellView addSubview: reflectedView];
    [reflectedView release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake((cellWidth - imageSize) / 2.0f, imageSize, imageSize, cellWidth - imageSize)];
    [nameLabel setBackgroundColor: [UIColor clearColor]];
    [nameLabel setTextColor: [UIColor whiteColor]];
    [nameLabel setTextAlignment: UITextAlignmentCenter];
    [nameLabel setText: gameName];
    UIFont *font;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        font = [UIFont boldSystemFontOfSize: 30.0f];
    else
        font = [UIFont boldSystemFontOfSize: 16.0f];
    [nameLabel setFont: font];
    [nameLabel setShadowColor: [UIColor blackColor]];
    [nameLabel setShadowOffset: CGSizeMake(2, 2)];
    
    [cellView addSubview: nameLabel];
    [nameLabel release];
    
    [_visibleGames addObject: cellView];
    
    [self addSubview: cellView];
    [cellView release];
    
    return (rightEdge + cellWidth);
}


- (CGFloat) placeGameOnLeft: (CGFloat) leftEdge
{
    NSDictionary *entry = [_gameInfos lastObject];
    NSString *imageName = [entry objectForKey: @"image"];
    NSString *gameName  = [entry objectForKey: @"name"];
    
    [_visibleGameInfos insertObject: entry atIndex: 0];
    [_gameInfos removeLastObject];
    
    UIView *cellView = [[UIView alloc] initWithFrame: CGRectMake(leftEdge - cellWidth, 0, cellWidth, cellWidth)];
    
    UIImageView *gameView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: imageName]];
    
    CGRect frame = CGRectMake((cellWidth - imageSize) / 2.0f, 0, imageSize, imageSize);
    [gameView setFrame: frame];
    
    [cellView addSubview: gameView];
    
    UIImage *reflectedImage = [self reflectedImage: gameView withHeight: cellWidth - imageSize - 25];
    [gameView release];
    
    UIImageView *reflectedView = [[UIImageView alloc] initWithImage: reflectedImage];
    [reflectedView setFrame: CGRectMake((cellWidth - imageSize) / 2.0f, imageSize + 25, imageSize, cellWidth - imageSize - 25)];
    [reflectedView setAlpha: 0.5f];
    
    [cellView addSubview: reflectedView];
    [reflectedView release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake((cellWidth - imageSize) / 2.0f, imageSize, imageSize, cellWidth - imageSize)];
    [nameLabel setBackgroundColor: [UIColor clearColor]];
    [nameLabel setTextColor: [UIColor whiteColor]];
    [nameLabel setTextAlignment: UITextAlignmentCenter];
    [nameLabel setText: gameName];
    UIFont *font;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        font = [UIFont boldSystemFontOfSize: 30.0f];
    else
        font = [UIFont boldSystemFontOfSize: 16.0f];
    [nameLabel setFont: font];
    [nameLabel setShadowColor: [UIColor blackColor]];
    [nameLabel setShadowOffset: CGSizeMake(2, 2)];
    
    [cellView addSubview: nameLabel];
    [nameLabel release];
    
    [_visibleGames insertObject: cellView atIndex: 0];
    
    [self addSubview: cellView];
    [cellView release];
    
    return (leftEdge - cellWidth);
}


- (void) tileGamesFromMinimumX: (CGFloat) minimumVisibleX toMaximumX: (CGFloat) maximumVisibleX
{
    /* Make sure there's at least one game */
    if ([_visibleGames count] == 0)
        [self placeGameOnRight: (minimumVisibleX + maximumVisibleX) / 2.0f - cellWidth / 2.0f];
    
    /* Add games that are missing on the right side */
    UIView *lastGame = [_visibleGames lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastGame frame]);
    while (rightEdge < maximumVisibleX)
    {
        rightEdge = [self placeGameOnRight: rightEdge];
    }
    
    /* Add games that are missing on the left side */
    UIView *firstGame = [_visibleGames objectAtIndex: 0];
    CGFloat leftEdge = CGRectGetMinX([firstGame frame]);
    while (leftEdge > minimumVisibleX)
    {
        leftEdge = [self placeGameOnLeft: leftEdge];
    }
    
    /* Remove games that have fallen off the right side */
    lastGame = [_visibleGames lastObject];
    while (CGRectGetMinX([lastGame frame]) > maximumVisibleX)
    {
        [lastGame removeFromSuperview];
        [_visibleGames removeLastObject];
        lastGame = [_visibleGames lastObject];
        
        NSDictionary *lastInfo = [_visibleGameInfos lastObject];
        [_gameInfos insertObject: lastInfo atIndex: 0];
        [_visibleGameInfos removeLastObject];
    }
    
    /* Remove games that have fallen off the left side */
    firstGame = [_visibleGames objectAtIndex: 0];
    while (CGRectGetMaxX([firstGame frame]) < minimumVisibleX)
    {
        [firstGame removeFromSuperview];
        [_visibleGames removeObjectAtIndex: 0];
        firstGame = [_visibleGames objectAtIndex: 0];
        
        NSDictionary *firstInfo = [_visibleGameInfos objectAtIndex: 0];
        [_gameInfos addObject: firstInfo];
        [_visibleGameInfos removeObjectAtIndex: 0];
    }
}


#pragma mark - Image Reflection

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
	CGImageRef theCGImage = NULL;
    
	// gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
															   8, 0, colorSpace, kCGImageAlphaNone);
	
	// define the start and end grayscale values (with the alpha, even though
	// our bitmap context doesn't support alpha the gradient requires it)
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	// create the CGGradient and then release the gray color space
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	// create the start and end points for the gradient vector (straight down)
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
	
	// draw the gradient into the gray bitmap context
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// convert the context into a CGImageRef and release the context
	theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
	// return the imageref containing the gradient
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
														0, colorSpace,
														// this will give us an optimal BGRA format for the device:
														(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}

- (UIImage *) reflectedImage: (UIImageView *) fromImage withHeight: (NSUInteger) height
{
    if (height == 0)
		return nil;
    
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = MyCreateBitmapContext([fromImage bounds].size.width, height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, [fromImage bounds].size.width, height), gradientMaskImage);
	CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, 0.0, height);
	CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, [fromImage bounds], [[fromImage image] CGImage]);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage 
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}


@end
