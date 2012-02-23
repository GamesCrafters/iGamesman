//
//  GCGameViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCGameViewController.h"

#import "GCGame.h"

#import "GCGameHistoryItem.h"
#import "GCPlayer.h"
#import "GCSidebarView.h"
#import "GCVVHView.h"

#import "GCMetaSettingsPanelController.h"
#import "GCPlayerPanelController.h"
#import "GCValuesPanelController.h"
#import "GCVVHPanelController.h"

@implementation GCGameViewController


- (id) initWithGame: (id<GCGame>) _game
{
    self = [super init];
    
    if (self)
    {
        game = [_game retain];
        
        showingPredictions = NO;
        showingVVH = NO;
    }
    
    return self;
}


- (void) dealloc
{
    [game release];
    
    [super dealloc];
}


#pragma mark - GCGameControllerDelegate

- (void) setUndoButtonEnabled: (BOOL) enabled
{
    UIButton *undoButton = (UIButton *) [self.view viewWithTag: 1000];
    undoButton.enabled = enabled;
}


- (void) setRedoButtonEnabled: (BOOL) enabled
{
    UIButton *undoButton = (UIButton *) [self.view viewWithTag: 1001];
    undoButton.enabled = enabled;
}


- (void) updateStatusLabel
{
    GCPlayerSide side = [game currentPlayerSide];
    
    NSString *playerName, *otherPlayerName;
    NSString *playerEpithet, *otherPlayerEpithet;
    
    if (side == GC_PLAYER_LEFT)
    {
        playerName = [[game leftPlayer] name];
        playerEpithet = [[game leftPlayer] epithet];
        
        otherPlayerName = [[game rightPlayer] name];
        otherPlayerEpithet = [[game rightPlayer] epithet];
    }
    else if (side == GC_PLAYER_RIGHT)
    {
        playerName = [[game rightPlayer] name];
        playerEpithet = [[game rightPlayer] epithet];
        
        otherPlayerName = [[game leftPlayer] name];
        otherPlayerEpithet = [[game leftPlayer] epithet];
    }
    else
    {
        playerName = playerEpithet = otherPlayerName = otherPlayerEpithet = nil;
    }
    
    
    GCGameValue *primitive = [game primitive];
    
    NSString *message = @"";
    
    if (primitive != nil)
    {
        NSString *winner, *winnerEpithet;
        if ([primitive isEqualToString: GCGameValueWin])
        {
            winner = playerName;
            winnerEpithet = playerEpithet;
        }
        else if ([primitive isEqualToString: GCGameValueLose])
        {
            winner = otherPlayerName;
            winnerEpithet = otherPlayerEpithet;
        }
        else
        {
            winner = winnerEpithet = nil;
        }
        
        NSString *epithetString;
        if (winnerEpithet)
            epithetString = [NSString stringWithFormat: @" (%@)", winnerEpithet];
        else
            epithetString = @"";
        
        if ([primitive isEqualToString: GCGameValueTie])
            message = @"It's a tie!";
        else
            message = [NSString stringWithFormat: @"%@%@ wins!", winner, epithetString];
    }
    else
    {
        NSString *epithetString = @"";
        if (playerEpithet)
            epithetString = [NSString stringWithFormat: @" (%@)", playerEpithet];
        
        
        GCGameHistoryItem *historyItem = [gameController currentItem];
        
        if ([[historyItem value] isEqualToString: GCGameValueUnknown] || !showingPredictions)
        {
            message = [NSString stringWithFormat: @"%@%@'s turn", playerName, epithetString];
        }
        else if ([[historyItem value] isEqualToString: GCGameValueDraw])
        {
            message = [NSString stringWithFormat: @"%@%@ should DRAW", playerName, epithetString];
        }
        else
        {
            NSDictionary *valueMap = [NSDictionary dictionaryWithObjectsAndKeys: @"WIN", GCGameValueWin, @"LOSE", GCGameValueLose, @"TIE", GCGameValueTie, nil];
            NSString *value = [valueMap objectForKey: [historyItem value]];
            
            message = [NSString stringWithFormat: @"%@%@ should %@ in %d.", playerName, epithetString, value, [historyItem remoteness]];
        }
        
    }
    
    [messageLabel setText: message];
}


#pragma mark - GCDrawerViewDelegate

- (void) drawerDidDisappear: (GCModalDrawerView *) drawer
{
    [self updateStatusLabel];
}


- (void) addView: (UIView *) view behindDrawer: (GCModalDrawerView *) drawer
{
    [self.view insertSubview: view belowSubview: drawer];
}


#pragma mark - GCValuesPanelDelegate

- (BOOL) isShowingPredictions
{
    return showingPredictions;
}


- (void) setShowingPredictions: (BOOL) predictions
{
    showingPredictions = predictions;
    
    [self updateStatusLabel];
}


- (void) presentViewController: (UIViewController *) viewController
{
    [self presentModalViewController: viewController animated: YES];
}


#pragma mark -

- (void) sidebarButtonTapped: (UIButton *) sender
{
    if (sender.tag == 1007)
    {
        [self dismissModalViewControllerAnimated: YES];
    }
    else if ((sender.tag == 1002) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        if (!showingVVH)
        {
            CGFloat width  = [[self view] bounds].size.width;
            CGFloat height = [[self view] bounds].size.height;
            
            CGFloat vvhWidth = width / 4.0f;
            
            vvh = [[GCVVHView alloc] initWithFrame: CGRectMake(-(vvhWidth), 0, vvhWidth, height)];
            
            [self.view addSubview: vvh];
            
            
            CGFloat labelHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80 : 50;
            CGRect sideBarRect = [sideBar frame];
            
            CGFloat newGameWidth = width - sideBarRect.size.width - vvhWidth;
            
            CGRect gameRect = CGRectMake(vvhWidth + sideBarRect.size.width, labelHeight, newGameWidth, height - 2 * labelHeight);
            
            CGRect labelRect = CGRectMake(vvhWidth + sideBarRect.size.width, height - labelHeight, width - (vvhWidth + sideBarRect.size.width) - 30, labelHeight);
            CGRect gameLabelRect = CGRectMake(vvhWidth + sideBarRect.size.width, 0, width - (vvhWidth + sideBarRect.size.width) - 30, labelHeight);
            
            void (^animateBlock) (void) = ^(void)
            {
                [vvh setFrame: CGRectOffset([vvh frame], vvhWidth, 0)];
                [sideBar setFrame: CGRectOffset([sideBar frame], vvhWidth, 0)];
                [messageLabel setFrame: labelRect];
                [gameNameLabel setFrame: gameLabelRect];
                
                [gameView setFrame: gameRect];
                [gameView setNeedsDisplay];
            };
            
            [UIView animateWithDuration: 0.25f animations: animateBlock];
        }
        else
        {
            
            CGFloat width = self.view.bounds.size.width;
            CGFloat height = self.view.bounds.size.height;
            
            CGRect sideBarRect = CGRectZero;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                sideBarRect = CGRectMake(0, 20, 44, height - 40);
            else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sideBarRect = CGRectMake(0, (height - 480) / 2.0f, 44, 480);
            
            CGFloat labelHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80 : 50;
            
            CGRect gameRect = CGRectInset([self.view bounds], sideBarRect.size.width, labelHeight);
            
            CGRect labelRect = CGRectMake(sideBarRect.size.width, height - labelHeight, width - 2 * sideBarRect.size.width, labelHeight);
            CGRect gameLabelRect = CGRectMake(sideBarRect.size.width, 0, width - 2 * sideBarRect.size.width, labelHeight);
            
            
            void (^animateBlock) (void) = ^(void)
            {
                [vvh setFrame: CGRectOffset([vvh frame], -[vvh frame].size.width, 0)];
                [sideBar setFrame: sideBarRect];
                [messageLabel setFrame: labelRect];
                [gameNameLabel setFrame: gameLabelRect];
                
                [gameView setFrame: gameRect];
                [gameView setNeedsDisplay];
            };
            
            void (^completion) (BOOL) = ^(BOOL done)
            {
                [vvh removeFromSuperview];
                [vvh release];
            };
            
            [UIView animateWithDuration: 0.25f animations: animateBlock completion: completion];
        }
        
        showingVVH = !showingVVH;
    }
    else if (1002 <= sender.tag && sender.tag <= 1006)
    {
        GCModalDrawerView *drawer = (GCModalDrawerView *) [self.view viewWithTag: sender.tag + 1000];
        [self.view bringSubviewToFront: drawer];
        [drawer slideIn];
    }
    else if (sender.tag == 1000)
    {
        [gameController undo];
    }
    else if (sender.tag == 1001)
    {
        [gameController redo];
    }
}


- (void) addSidebarInRect: (CGRect) sideBarRect;
{
    sideBar = [[GCSidebarView alloc] initWithFrame: sideBarRect];
    
    
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
    
#warning TODO: Find a better way to do this, once I've defined all of the panels.
    CGFloat drawerWidths[]  = { 0, 0, 0, 0, 0 };
    CGFloat drawerHeights[] = { 0, 0, 0, 0, 0 };
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        drawerWidths[0] = 460;  drawerHeights[0] = sideBarRect.size.height;
        drawerWidths[1] = 460;  drawerHeights[1] = sideBarRect.size.height; 
        drawerWidths[2] = 300;  drawerHeights[2] = sideBarRect.size.height;
        drawerWidths[3] = 360;  drawerHeights[3] = sideBarRect.size.height;
        drawerWidths[4] = 360;  drawerHeights[4] = sideBarRect.size.height;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        drawerWidths[0] = 460;  drawerHeights[0] = sideBarRect.size.height;
        drawerWidths[1] = 460;  drawerHeights[1] = 300;
        drawerWidths[2] = 300;  drawerHeights[2] = sideBarRect.size.height;
        drawerWidths[3] = 360;  drawerHeights[3] = 250;
        drawerWidths[4] = 360;  drawerHeights[4] = sideBarRect.size.height;
    }
    
    for (int i = 2; i <= 6; i += 1)
    {
        CGRect drawerRect = CGRectMake(0, sideBarRect.origin.y + (sideBarRect.size.height - drawerHeights[i - 2]) / 2.0f, drawerWidths[i - 2], drawerHeights[i - 2]);
        GCModalDrawerView *drawer = [[GCModalDrawerView alloc] initWithFrame: drawerRect startOffscreen: YES];
        drawer.tag = 2000 + i;
        drawer.delegate = self;
        [self.view addSubview: drawer];
        
        if ((i == 2) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone))
        {
            GCVVHPanelController *vvhPanel = [[GCVVHPanelController alloc] init];
            [drawer setPanelController: vvhPanel];
            [vvhPanel release];
        }
        if (i == 3)
        {
            GCPlayerPanelController *playerPanel = [[GCPlayerPanelController alloc] initWithGame: game];
            [drawer setPanelController: playerPanel];
            [playerPanel release];
        }
        else if (i == 5)
        {
            GCValuesPanelController *valuesPanel = [[GCValuesPanelController alloc] initWithGame: game];
            [drawer setPanelController: valuesPanel];
            [valuesPanel setDelegate: self];
            [valuesPanel release];
        }
        else if (i == 6)
        {
            GCMetaSettingsPanelController *metaPanel = [[GCMetaSettingsPanelController alloc] init];
            [drawer setPanelController: metaPanel];
            [metaPanel release];
        }
        
        [drawer release];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 320)] autorelease];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)] autorelease];
    
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
    
    CGFloat labelHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80 : 50;
    
    CGRect gameRect = CGRectInset([self.view bounds], sideBarRect.size.width, labelHeight);
    
    gameView = [game viewWithFrame: gameRect];
    gameView.clipsToBounds = NO;
    
    [self.view addSubview: gameView];
    
    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeInfoLight];
    infoButton.center = CGPointMake(width - 15, height - 15);
    [self.view addSubview: infoButton];
    
    
    messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(sideBarRect.size.width, height - labelHeight, width - 2 * sideBarRect.size.width, labelHeight)];
    [messageLabel setBackgroundColor: [UIColor clearColor]];
    [messageLabel setNumberOfLines: 2];
    [messageLabel setLineBreakMode: UILineBreakModeWordWrap];
    UIFont *font = [UIFont boldSystemFontOfSize: (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 24 : 17];
    [messageLabel setFont: font];
    [messageLabel setTextAlignment: UITextAlignmentCenter];
    [messageLabel setTextColor: [UIColor whiteColor]];
    [messageLabel setText: @""];
    
    [self.view addSubview: messageLabel];
    
    
    gameNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(sideBarRect.size.width, 0, width - 2 * sideBarRect.size.width, labelHeight)];
    [gameNameLabel setBackgroundColor: [UIColor clearColor]];
    font = [UIFont boldSystemFontOfSize: (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 40 : 24];
    [gameNameLabel setFont: font];
    [gameNameLabel setTextAlignment: UITextAlignmentCenter];
    [gameNameLabel setTextColor: [UIColor whiteColor]];
    [gameNameLabel setText: [game name]];
    
    [self.view addSubview: gameNameLabel];
}
 

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    GCPlayer *left = [[GCPlayer alloc] init];
    [left setName: @"Player 1"];
    [left setType: GC_HUMAN];
    [left setPercentPerfect: 0];
    
    GCPlayer *right = [[GCPlayer alloc] init];
    [right setName: @"Player 2"];
    [right setType: GC_HUMAN];
    [right setPercentPerfect: 0];
    
    [game startGameWithLeft: left right: right];
    
    [left release];
    [right release];
    
    gameController = [[GCGameController alloc] initWithGame: game andDelegate: self];
    
    [self updateStatusLabel];
    
    [gameController go];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [messageLabel release];
    [gameNameLabel release];
    
    [gameController release];
    
    [sideBar release];
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
