//
//  GCGameViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCGameViewController.h"

#import "GCGame.h"

#import "GCDrawerView.h"
#import "GCGameController.h"
#import "GCPlayer.h"
#import "GCSidebarView.h"


@interface GCGameViewController ()

- (void) addSidebarInRect: (CGRect) sideBarRect;

@end


@implementation GCGameViewController

- (id) initWithGame: (id<GCGame>) game
{
    self = [super init];
    
    if (self)
    {
        _game = game;
        [(NSObject *) _game retain];
    }
    
    return self;
}


- (void) sidebarButtonTapped: (UIButton *) sender
{
    if (sender.tag == 1007)
    {
        [self dismissModalViewControllerAnimated: YES];
    }
    else if (1002 <= sender.tag && sender.tag <= 1006)
    {
        GCDrawerView *drawer = (GCDrawerView *) [self.view viewWithTag: sender.tag + 1000];
        [self.view bringSubviewToFront: drawer];
        [drawer slideIn];
    }
    else if (sender.tag == 1000)
        [gameController undo];
    else if (sender.tag == 1001)
        [gameController redo];
}


#pragma mark -
#pragma mark GCGameControllerDelegate

- (void) setUndoButtonEnabled: (BOOL) enabled
{
    UIButton *undoButton = (UIButton *) [self.view viewWithTag: 1000];
    undoButton.enabled = enabled;
}


- (void) setRedoButtonEnabled: (BOOL) enabled
{
    UIButton *redoButton = (UIButton *) [self.view viewWithTag: 1001];
    redoButton.enabled = enabled;
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    GCPlayer *left = [[GCPlayer alloc] init];
    [left setName: @"Player 1"];
    [left setType: HUMAN];
    [left setPercentPerfect: 0];
    
    GCPlayer *right = [[GCPlayer alloc] init];
    [right setName: @"Player 2"];
    [right setType: HUMAN];
    [right setPercentPerfect: 0];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys: GCGameModeOfflineUnsolved, GCGameModeKey, nil];
    
    [_game startGameWithLeft: left
                       right: right
             andPlaySettings: settings];
    
    [left release];
    [right release];
    
    gameController = [[GCGameController alloc] initWithGame: _game andDelegate: self];
    
    [gameController go];
}


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
    
    CGRect sideBarRect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        sideBarRect = CGRectMake(0, 20, 44, height - 40);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        sideBarRect = CGRectMake(0, (height - 480) / 2.0f, 44, 480);
    else
        sideBarRect = CGRectZero;
    
    [self addSidebarInRect: sideBarRect];
    
    
    CGRect gameRect = CGRectMake(sideBarRect.size.width + 20, 30, width - sideBarRect.size.width - 20 - 30, height - 60);
    
    UIView *gameView = [_game viewWithFrame: gameRect];
    
    [self.view addSubview: gameView];
    
    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeInfoLight];
    infoButton.center = CGPointMake(width - 15, height - 15);
    [self.view addSubview: infoButton];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [gameController release];
}


- (void) addSidebarInRect: (CGRect) sideBarRect;
{
    GCSidebarView *sideBar = [[GCSidebarView alloc] initWithFrame: sideBarRect];
    
    
    CGFloat buttonHeight = (sideBarRect.size.height - 9 * 4) / 8;
    
    NSArray *imageNames = [NSArray arrayWithObjects: @"undo", @"redo", @"vvh", @"players", @"variants", @"values", @"settings", @"home", nil];
    
    for (int i = 0; i < 8; i += 1)
    {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setImage: [UIImage imageNamed: [imageNames objectAtIndex: i]] forState: UIControlStateNormal];
        [button setFrame: CGRectMake(0, 4 + (4 + buttonHeight) * i, 44, buttonHeight)];
        [button addTarget: self action: @selector(sidebarButtonTapped:) forControlEvents: UIControlEventTouchUpInside];
        [button setTag: 1000 + i];
        
        [sideBar addSubview: button];
        
        if ((i == 0) || (i == 1))
            button.enabled = NO;
    }
    
    [self.view addSubview: sideBar];
    
    [sideBar release];
    
    CGFloat drawerWidths[] = { 460, 200, 300, 150, 300 };
    for (int i = 2; i <= 6; i += 1)
    {
        GCDrawerView *drawer = [[GCDrawerView alloc] initWithFrame: CGRectMake(0, sideBarRect.origin.y, drawerWidths[i-2], sideBarRect.size.height) startOffscreen: YES];
        drawer.tag = 2000 + i;
        [self.view addSubview: drawer];
        [drawer release];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
