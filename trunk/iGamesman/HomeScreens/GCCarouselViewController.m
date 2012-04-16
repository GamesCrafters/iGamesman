//
//  GCCarouselViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 12/29/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCCarouselViewController.h"

#import "GCGame.h"

#import "GCAboutGameViewController.h"
#import "GCAboutGamesCraftersViewController.h"
#import "GCGameViewController.h"
#import "GCGamesScrollView.h"

@implementation GCCarouselViewController

#pragma mark - Button actions

- (void) aboutGameTapped
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *xmlTitle = [_currentEntry objectForKey: @"xml"];
    
    if (xmlTitle)
    {
        NSString *path = [mainBundle pathForResource: xmlTitle ofType: @"xml"];
        
        CGRect frame = CGRectZero;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            frame = CGRectMake(0, 0, 480, 288);
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            frame = CGRectMake(0, 0, 1024, 724);
        GCAboutGameViewController *aboutGameController = [[GCAboutGameViewController alloc] initWithXMLPath: path viewFrame: frame];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: aboutGameController];
        [navController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
        
        [self presentModalViewController: navController animated: YES];
        
        [aboutGameController release];
        [navController release];
    }
}


- (void) aboutGCTapped
{
    GCAboutGamesCraftersViewController *aboutGCController = [[GCAboutGamesCraftersViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: aboutGCController];
    [navController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController: navController animated: YES];
    
    [aboutGCController release];
    [navController release];
}


- (void) startGameTapped
{
    NSString *className  = [_currentEntry objectForKey: @"class"];
    
    if (!className)
    {
        NSLog(@"No class name specified for game \"%@\"", [_currentEntry objectForKey: @"name"]);
        return;
    }
    
    Class class = NSClassFromString(className);
    
    if (!class)
    {
        NSLog(@"Could not find class named \"%@\"", className);
        return;
    }
    
    id<GCGame> game = [[class alloc] init];
    
    if (!game)
    {
        NSLog(@"Initialization of class \"%@\" failed", className);
        return;
    }
    
    
    /* Create the game controller and present it */
    GCGameViewController *gameViewController = [[GCGameViewController alloc] initWithGame: game];
    [gameViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    [gameViewController setGameInfoDictionary: _currentEntry];
    
    [self presentModalViewController: gameViewController animated: YES];
    
    [gameViewController release];
    
    
    [game release];
}


#pragma mark - Memory lifecycle

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        _currentEntry = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [_currentEntry release];
    
    [super dealloc];
}


#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
    GCGamesScrollView *gamesScroller = (GCGamesScrollView *) scrollView;
    
    NSDictionary *entry = [gamesScroller centerGame];
    
    if (_currentEntry)
        [_currentEntry release];
    
    _currentEntry = [entry retain];
    
    NSString *aboutTitle = [NSString stringWithFormat: @"About\n%@", [entry objectForKey: @"name"]];
    NSString *playTitle  = [NSString stringWithFormat: @"Play\n%@", [entry objectForKey: @"name"]];
    
    [_aboutGameButton setTitle: aboutTitle forState: UIControlStateNormal];
    [playGame setTitle: playTitle forState: UIControlStateNormal];
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 320)] autorelease]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)] autorelease]];
    else
        [self setView: nil];
    
    
    CGFloat width  = [[self view] bounds].size.width;
    CGFloat height = [[self view] bounds].size.height;
    
    
    CGRect scrollFrame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        scrollFrame = CGRectMake(0, height / 3.0f, width, height * (2.0f / 3.0f));
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        scrollFrame = CGRectMake(0, height / 4.0f, width, height * 0.75f);
    else
        scrollFrame = CGRectZero;
    _scroller = [[GCGamesScrollView alloc] initWithFrame: scrollFrame];
    [_scroller setDelegate: self];
    
    [[self view] addSubview: _scroller];
    [_scroller layoutIfNeeded];
    
    
    _aboutGameButton = [[UIButton buttonWithType: UIButtonTypeCustom] retain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [_aboutGameButton setFrame: CGRectMake(width - 140, 20, 120, 60)];
        [[_aboutGameButton titleLabel] setFont: [UIFont boldSystemFontOfSize: 14.0f]];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [_aboutGameButton setFrame: CGRectMake(width - 260, 20, 240, 120)];
        [[_aboutGameButton titleLabel] setFont: [UIFont boldSystemFontOfSize: 28.0f]];
    }
    
    [_aboutGameButton setBackgroundImage: [UIImage imageNamed: @"YellowButton.png"] forState: UIControlStateNormal];
    [_aboutGameButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [[_aboutGameButton titleLabel] setNumberOfLines: 2];
    [[_aboutGameButton titleLabel] setTextAlignment: UITextAlignmentCenter];
    [_aboutGameButton setTitle: @"About\nGame" forState: UIControlStateNormal];
    [_aboutGameButton addTarget: self action: @selector(aboutGameTapped) forControlEvents: UIControlEventTouchUpInside];
    
    [[self view] addSubview: _aboutGameButton];
    
    
    playGame = [[UIButton buttonWithType: UIButtonTypeCustom] retain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [playGame setFrame: CGRectMake(width / 2.0f - 60, 20, 120, 60)];
        [[playGame titleLabel] setFont: [UIFont boldSystemFontOfSize: 14.0f]];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [playGame setFrame: CGRectMake(width / 2.0f - 120, 20, 240, 120)];
        [[playGame titleLabel] setFont: [UIFont boldSystemFontOfSize: 28.0f]];
    }
    [playGame setBackgroundImage: [UIImage imageNamed: @"GreenButton.png"] forState: UIControlStateNormal];
    [playGame setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [[playGame titleLabel] setNumberOfLines: 2];
    [[playGame titleLabel] setTextAlignment: UITextAlignmentCenter];
    [playGame setTitle: @"Play\nGame" forState: UIControlStateNormal];
    [playGame addTarget: self action: @selector(startGameTapped) forControlEvents: UIControlEventTouchUpInside];
    
    [[self view] addSubview: playGame];
    
    
    UIButton *aboutGamesCrafters = [UIButton buttonWithType: UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [aboutGamesCrafters setFrame: CGRectMake(20, 20, 120, 60)];
        [aboutGamesCrafters setImageEdgeInsets: UIEdgeInsetsMake(5, 35, 5, 35)];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [aboutGamesCrafters setFrame: CGRectMake(20, 20, 240, 120)];
        [aboutGamesCrafters setImageEdgeInsets: UIEdgeInsetsMake(10, 70, 10, 70)];
    }
    [aboutGamesCrafters setBackgroundImage: [UIImage imageNamed: @"BlackButton.png"] forState: UIControlStateNormal];
    [aboutGamesCrafters setImage: [UIImage imageNamed: @"GamesCrafters"] forState: UIControlStateNormal];
    [aboutGamesCrafters addTarget: self action: @selector(aboutGCTapped) forControlEvents: UIControlEventTouchUpInside];

    [[self view] addSubview: aboutGamesCrafters];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *versionString = [NSString stringWithFormat: @"v%@, build %@", [infoDictionary objectForKey: @"GCVersionNumber"], [infoDictionary objectForKey: @"GCBuildNumber"]];
    CGSize textSize = [versionString sizeWithFont: [UIFont boldSystemFontOfSize: 14.0f]];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, height - 22, textSize.width, 22)];
    [versionLabel setText: versionString];
    [versionLabel setFont: [UIFont boldSystemFontOfSize: 14.0f]];
    [versionLabel setBackgroundColor: [UIColor clearColor]];
    [versionLabel setTextColor: [UIColor whiteColor]];
    
    [[self view] addSubview: versionLabel];
    
    [versionLabel release];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *entry = [_scroller centerGame];
    
    if (_currentEntry)
        [_currentEntry release];
    
    _currentEntry = [entry retain];
    
    NSString *aboutTitle = [NSString stringWithFormat: @"About\n%@", [entry objectForKey: @"name"]];
    NSString *playTitle  = [NSString stringWithFormat: @"Play\n%@", [entry objectForKey: @"name"]];
    
    [_aboutGameButton setTitle: aboutTitle forState: UIControlStateNormal];
    [playGame setTitle: playTitle forState: UIControlStateNormal];
}



- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_aboutGameButton release];
    [playGame release];
    [_scroller release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
