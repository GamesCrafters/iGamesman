//
//  GCCarouselViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/5/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCCarouselViewController.h"

#import "GCGame.h"
#import "GCGameViewController.h"


@implementation GCCarouselViewController

#pragma mark - Memory lifecycle

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        views = [[NSMutableArray alloc] init];
        labels = [[NSMutableArray alloc] init];
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *gameInfoPath = [mainBundle pathForResource: @"Games" ofType: @"plist"];
        
        gameData = [[NSArray alloc] initWithContentsOfFile: gameInfoPath];
        NSLog(@"%@", gameData);
    }
    return self;
}


- (void) dealloc
{
    [views release];
    [labels release];
    
    [super dealloc];
}


#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
    CGFloat width = self.view.bounds.size.width;
    
    for (int i = 0; i < 5; i += 1)
    {
        UIImageView *imageView = [views objectAtIndex: i];
        CGRect frame = imageView.frame;
        
        CGFloat offset = CGRectGetMidX(frame) - width / 2.0f - scrollView.contentOffset.x;
        
        
        UILabel *label = [labels objectAtIndex: i];
        
        CGFloat alpha = 1 - fabs(1.5f * offset / width);
        label.alpha = alpha;
        imageView.alpha = alpha;
    }
}


- (void) scrollViewWillEndDragging: (UIScrollView *) scrollView withVelocity: (CGPoint) velocity targetContentOffset: (inout CGPoint *) targetContentOffset
{
    CGFloat width = self.view.bounds.size.width;
    CGFloat centeredOffset = scrollView.contentSize.width / 3.0f;
    CGFloat offsetFromCenter = targetContentOffset->x - centeredOffset;
    
    int slot = (int) round(offsetFromCenter / (1.25f * (width / 3.0f)));
    
    targetContentOffset->x = centeredOffset + (1.25f * slot * (width / 3.0f));
}


- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView willDecelerate: (BOOL) decelerate
{
    if (!decelerate)
    {
        CGFloat width = self.view.bounds.size.width;
        CGFloat centeredOffset = scrollView.contentSize.width / 3.0f;
        CGFloat offsetFromCenter = scrollView.contentOffset.x - centeredOffset;

        int slot = (int) round(offsetFromCenter / (1.25f * (width / 3.0f)));
        
        [UIView animateWithDuration: 0.25f
                              delay: 0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations: ^(void)
         {
             [scrollView setContentOffset: CGPointMake(centeredOffset + (1.25f * slot * (width / 3.0f)), 0) animated: NO];
         }
                         completion: nil];
    }
}


#pragma mark - Button action

- (void) buttonTapped: (UIButton *) sender
{
    int index = sender.tag - 1000;
    
    NSString *className = [[gameData objectAtIndex: index] objectForKey: @"class"];
    Class class = NSClassFromString(className);
    
    id<GCGame> game = [[class alloc] init];
    
    GCGameViewController *gameViewController = [[GCGameViewController alloc] initWithGame: game];
    
    [gameViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController: gameViewController animated: YES];
    
    [gameViewController release];
    
    //[game release];
}


#pragma mark - View lifecycle

- (void) loadView
{
    UIView *mainView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 320)];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        mainView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)];
    else
        mainView = nil;
    
    self.view = mainView;
    [mainView release];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame: self.view.bounds];
    scroller.decelerationRate = -0.5;
    scroller.contentSize = CGSizeMake(3 * scroller.bounds.size.width, scroller.bounds.size.height);
    scroller.contentOffset = CGPointMake(scroller.bounds.size.width, 0);
    scroller.delegate = self;
    
    for (int i = 0; i < 5; i += 1)
    {
        CGRect frame = CGRectMake(scroller.bounds.size.width + width / 3.0f + 1.25f * (i - 2) * (width / 3.0f), height - (height / 4.0f) - (width / 3.0f), width / 3.0f, width / 3.0f);
        
        UIButton *imageView = [[UIButton alloc] initWithFrame: frame];
        NSString *imageName = [[gameData objectAtIndex: i] objectForKey: @"image"];
        [imageView setBackgroundImage: [UIImage imageNamed: imageName] forState: UIControlStateNormal];
        [imageView addTarget: self action: @selector(buttonTapped:) forControlEvents: UIControlEventTouchUpInside];
        imageView.tag = 1000 + i;
        
        CGFloat offset = CGRectGetMidX(frame) - width / 2.0f - scroller.contentOffset.x;
        CGFloat alpha = 1 - fabs(1.5f * offset / width);
        
        imageView.alpha = alpha;
        
        [scroller addSubview: imageView];
        [views addObject: imageView];
        
        [imageView release];
        
        
        CGRect labelFrame = CGRectMake(scroller.bounds.size.width + width / 3.0f + 1.25f * (i - 2) * (width / 3.0f), height - (height / 4.0f), width / 3.0f, height / 6.0f);
        
        UILabel *label = [[UILabel alloc] initWithFrame: labelFrame];
        label.text = [[gameData objectAtIndex: i] objectForKey: @"name"];
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.alpha = alpha;
        
        [scroller addSubview: label];
        [labels addObject: label];
        
        [label release];
    }
    
    [self.view addSubview: scroller];
    
    [scroller release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
