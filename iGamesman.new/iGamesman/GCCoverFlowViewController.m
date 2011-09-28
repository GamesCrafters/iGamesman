//
//  GCCoverFlowViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/23/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCCoverFlowViewController.h"

@interface UIColor (Random)

+ (UIColor *) randomColor;

@end


@implementation UIColor (Random)

+ (UIColor *) randomColor
{
    return [UIColor colorWithRed: (random() % 256) / 256.0f green: (random() % 256) / 256.0f blue: (random() % 256) / 256.0f alpha: 1];
}

@end



@implementation GCCoverFlowViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        offsetFromCenter = 0.0f;
        
        views = [[NSMutableArray alloc] init];
        
        srandom(time(NULL));
    }
    return self;
}


- (void) dealloc
{
    [views release];
    
    [super dealloc];
}


#pragma mark - Touch capture

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
    UITouch *theTouch = [touches anyObject];
    CGPoint position = [theTouch locationInView: self.view];
    CGPoint lastPosition = [theTouch previousLocationInView: self.view];
    
    CGFloat dX = position.x - lastPosition.x;
    
    offsetFromCenter += dX;
    
    CGFloat viewWidth = self.view.bounds.size.width;
    
    if (offsetFromCenter < -1.25f * (viewWidth / 3.0f))
    {
        offsetFromCenter += (1.25f * (viewWidth / 3.0f));
        
        UIView *firstView = [[views objectAtIndex: 0] retain];
        [views removeObjectAtIndex: 0];
        [views addObject: firstView];
        [firstView release];
    }
    else if (offsetFromCenter > 1.25f * (viewWidth / 3.0f))
    {
        offsetFromCenter -= (1.25f * (viewWidth / 3.0f));
        
        UIView *lastView = [[views lastObject] retain];
        [views removeLastObject];
        [views insertObject:lastView atIndex: 0];
        [lastView release];
    }
    
    for (int i = 0; i < 5; i += 1)
    {
        UIView *testView = (UIView *) [views objectAtIndex: i];
        
        CGFloat viewOffset = offsetFromCenter + 1.25f * (viewWidth / 3.0f) * (i - 2);
        
        CGAffineTransform newTransform = CGAffineTransformMake(1, viewOffset * 0.002f, 0, 1, viewOffset, -fabs(viewOffset / 2.0f));
        
        newTransform = CGAffineTransformScale(newTransform, 1 - (fabs(viewOffset / self.view.frame.size.width) / 2.0f), 1);
        
        testView.transform = newTransform;
    }
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: self.view];
    CGPoint previous = [touch previousLocationInView: self.view];
    
    CGFloat viewWidth = self.view.bounds.size.width;
    
    [UIView animateWithDuration: 0.25f * (fabs(location.x - previous.x) / (viewWidth / 2.0f))
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^(void)
     {
         offsetFromCenter += ((location.x - previous.x) / 2.0f);
         for (int i = 1; i < 4; i += 1)
         {
             UIView *testView = (UIView *) [views objectAtIndex: i];
             
             CGFloat viewOffset = offsetFromCenter + 1.25f * (viewWidth / 3.0f) * (i - 2);
             
             CGAffineTransform newTransform = CGAffineTransformMake(1, viewOffset * 0.002f, 0, 1, viewOffset, -fabs(viewOffset / 2.0f));
             
             newTransform = CGAffineTransformScale(newTransform, 1 - (fabs(viewOffset / self.view.frame.size.width) / 2.0f), 1);
             
             testView.transform = newTransform;
         }
     }
                     completion: ^(BOOL done)
     {
         
     }];
    
    float right = fabs(185 - offsetFromCenter);
    float center = fabs(0 - offsetFromCenter);
    float left = fabs(-185 - offsetFromCenter);
    
    float min = MIN(MIN(left, center), right);
    
    if (min == left)
    {
        UIView *firstView = [[views objectAtIndex: 0] retain];
        [views removeObjectAtIndex: 0];
        [views addObject: firstView];
        [firstView release];
    }
    else if (min == right)
    {
        UIView *lastView = [[views lastObject] retain];
        [views removeLastObject];
        [views insertObject:lastView atIndex: 0];
        [lastView release];
    }
    
    offsetFromCenter = 0;
    
    [UIView animateWithDuration: 0.25f
                          delay: 0.25f * (fabs(location.x - previous.x) / (viewWidth / 2.0f))
                        options: 0
                     animations: ^(void)
     {         
         for (int i = 1; i < 4; i += 1)
         {
             UIView *testView = (UIView *) [views objectAtIndex: i];
             
             CGFloat viewOffset = offsetFromCenter + 1.25f * (viewWidth / 3.0f) * (i - 2);
             
             CGAffineTransform newTransform = CGAffineTransformMake(1, viewOffset * 0.002f, 0, 1, viewOffset, -fabs(viewOffset / 2.0f));
             
             newTransform = CGAffineTransformScale(newTransform, 1 - (fabs(viewOffset / self.view.frame.size.width) / 2.0f), 1);
             
             testView.transform = newTransform;
         }
     }
                     completion: ^(BOOL done)
     {
         for (int i = 0; i < 5; i += 4)
         {
             UIView *testView = (UIView *) [views objectAtIndex: i];
             
             CGFloat viewOffset = offsetFromCenter + 1.25f * (viewWidth / 3.0f) * (i - 2);
             
             CGAffineTransform newTransform = CGAffineTransformMake(1, viewOffset * 0.002f, 0, 1, viewOffset, -fabs(viewOffset / 2.0f));
             
             newTransform = CGAffineTransformScale(newTransform, 1 - (fabs(viewOffset / self.view.frame.size.width) / 2.0f), 1);
             
             testView.transform = newTransform;
         }
     }];
}


#pragma mark - View lifecycle

- (void)loadView
{
    UIView *mainView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 300)];
    self.view = mainView;
    [mainView release];
    
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    
    for (int i = 0; i < 5; i += 1)
    {
        //UIView *colorView = [[UIView alloc] initWithFrame: CGRectMake(viewWidth / 3.0f, viewHeight - (viewHeight / 6.0f) - (viewWidth / 3.0f), viewWidth / 3.0f, viewWidth / 3.0f)];
        //colorView.backgroundColor = [UIColor randomColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: [NSString stringWithFormat: @"game%d.gif", i]]];
        imageView.frame = CGRectMake(viewWidth / 3.0f, viewHeight - (viewHeight / 6.0f) - (viewWidth / 3.0f), viewWidth / 3.0f, viewWidth / 3.0f);
        
        CGFloat viewOffset = offsetFromCenter + 1.25f * (i - 2) * (viewWidth / 3.0f);
        
        CGAffineTransform transform = CGAffineTransformMake(1, viewOffset * 0.002f, 0, 1, viewOffset, -fabs(viewOffset / 2.0f));
        
        transform = CGAffineTransformScale(transform, 1 - (fabs(viewOffset / viewWidth) / 2.0f), 1);
        
        imageView.transform = transform;
        
        [self.view addSubview: imageView];
        
        [views addObject: imageView];
        
        [imageView release];
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
