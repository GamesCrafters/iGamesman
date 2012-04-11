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

#import "GCMetaSettingsPanelController.h"
#import "GCPlayerPanelController.h"
#import "GCValuesPanelController.h"
#import "GCVariantsPanelController.h"
#import "GCVVHPanelController.h"


@interface GCGameViewController ()
{
    GCMetaSettingsPanelController *metaPanel;
}
@end



@implementation GCGameViewController

#pragma mark - Memory lifecycle

- (id) initWithGame: (id<GCGame>) game
{
    self = [super init];
    
    if (self)
    {
        _game = [game retain];
        
        _showingPredictions = NO;
        _showingVVH = NO;
    }
    
    return self;
}


- (void) dealloc
{
    [_game release];
    
    [super dealloc];
}


#pragma mark - GCVVHViewDataSource

- (NSEnumerator *) historyItemEnumerator
{
    return [_gameController historyItemEnumerator];
}


#pragma mark - GCGameControllerDelegate

- (void) setUndoButtonEnabled: (BOOL) enabled
{
    UIButton *undoButton = (UIButton *) [[self view] viewWithTag: 1000];
    [undoButton setEnabled: enabled];
}


- (void) setRedoButtonEnabled: (BOOL) enabled
{
    UIButton *undoButton = (UIButton *) [[self view] viewWithTag: 1001];
    [undoButton setEnabled: enabled];
}


- (void) updateVVH
{
    [_vvh reloadData];
}


- (void) updateStatusLabel
{
    GCPlayerSide side = [_game currentPlayerSide];
    
    NSString *playerName, *otherPlayerName;
    NSString *playerEpithet, *otherPlayerEpithet;
    
    if (side == GC_PLAYER_LEFT)
    {
        playerName = [[_game leftPlayer] name];
        playerEpithet = [[_game leftPlayer] epithet];
        
        otherPlayerName = [[_game rightPlayer] name];
        otherPlayerEpithet = [[_game rightPlayer] epithet];
    }
    else if (side == GC_PLAYER_RIGHT)
    {
        playerName = [[_game rightPlayer] name];
        playerEpithet = [[_game rightPlayer] epithet];
        
        otherPlayerName = [[_game leftPlayer] name];
        otherPlayerEpithet = [[_game leftPlayer] epithet];
    }
    else
    {
        playerName = playerEpithet = otherPlayerName = otherPlayerEpithet = nil;
    }
    
    
    GCGameValue *primitive = [_game primitive];
    
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
        
        
        GCGameHistoryItem *historyItem = [_gameController currentItem];
        
        if ([[historyItem value] isEqualToString: GCGameValueUnknown] || !_showingPredictions)
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
    
    [_messageLabel setText: message];
    
    
    if ([_game respondsToSelector: @selector(isMisere)] && [_game isMisere])
        [_gameNameLabel setText: [NSString stringWithFormat: @"%@ (Misère)", [_game name]]];
    else
        [_gameNameLabel setText: [_game name]];
}


#pragma mark - GCDrawerViewDelegate

- (void) drawerDidDisappear: (GCModalDrawerView *) drawer
{
    [self updateStatusLabel];
}


- (void) addView: (UIView *) view behindDrawer: (GCModalDrawerView *) drawer
{
    [[self view] insertSubview: view belowSubview: drawer];
}


#pragma mark - GCValuesPanelDelegate

- (BOOL) isShowingPredictions
{
    return _showingPredictions;
}


- (void) setShowingPredictions: (BOOL) predictions
{
    _showingPredictions = predictions;
    
    [self updateStatusLabel];
}


- (void) presentViewController: (UIViewController *) viewController
{
    [self presentModalViewController: viewController animated: YES];
}


#pragma mark - GCVariantsPanelDelegate

- (void) closeDrawer: (GCVariantsPanelController *) sender
{
    GCModalDrawerView *drawer = (GCModalDrawerView *) [[self view] viewWithTag: 2004];
    [drawer slideOut];
}


- (void) startNewGameWithOptions: (NSDictionary *) options
{
    GCPlayer *left = [[_game leftPlayer] retain];
    GCPlayer *right = [[_game rightPlayer] retain];
    
    [_game startGameWithLeft: left 
                       right: right
                     options: options];
    
    [left release];
    [right release];
    
    
    /* Release the old controller */
    [_gameController release];
    
    _gameController = [[GCGameController alloc] initWithGame: _game andDelegate: self];
    
    [metaPanel setDelegate: _gameController];
    
    [self updateStatusLabel];
    
    [_gameController start];
}


#pragma mark -

- (void) sidebarButtonTapped: (UIButton *) sender
{
    if ([sender tag] == 1007)
    {
        [self dismissModalViewControllerAnimated: YES];
    }
    else if (([sender tag] == 1002) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        if (!_showingVVH)
        {
            CGFloat width  = [[self view] bounds].size.width;
            CGFloat height = [[self view] bounds].size.height;
            
            CGFloat vvhWidth = width / 3.5f;
            
            _vvh = [[GCVVHView alloc] initWithFrame: CGRectMake(-(vvhWidth), 0, vvhWidth, height)];
            [_vvh setDataSource: self];
            
            [[self view] addSubview: _vvh];
            
            
            CGFloat labelHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80 : 50;
            CGRect sideBarRect = [_sideBar frame];
            
            CGFloat newGameWidth = width - sideBarRect.size.width - vvhWidth;
            
            CGRect gameRect = CGRectMake(vvhWidth + sideBarRect.size.width, labelHeight, newGameWidth, height - 2 * labelHeight);
            
            CGRect labelRect = CGRectMake(vvhWidth + sideBarRect.size.width, height - labelHeight, width - (vvhWidth + sideBarRect.size.width) - 30, labelHeight);
            CGRect gameLabelRect = CGRectMake(vvhWidth + sideBarRect.size.width, 0, width - (vvhWidth + sideBarRect.size.width) - 30, labelHeight);
            
            void (^animateBlock) (void) = ^(void)
            {
                [_vvh setFrame: CGRectOffset([_vvh frame], vvhWidth, 0)];
                [_sideBar setFrame: CGRectOffset([_sideBar frame], vvhWidth, 0)];
                [_messageLabel setFrame: labelRect];
                [_gameNameLabel setFrame: gameLabelRect];
                
                [_gameView setFrame: gameRect];
                [_gameView setNeedsDisplay];
            };
            
            [UIView animateWithDuration: 0.25f animations: animateBlock];
        }
        else
        {
            
            CGFloat width = [[self view] bounds].size.width;
            CGFloat height = [[self view] bounds].size.height;
            
            CGRect sideBarRect = CGRectZero;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                sideBarRect = CGRectMake(0, 20, 44, height - 40);
            else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                sideBarRect = CGRectMake(0, (height - 480) / 2.0f, 44, 480);
            
            CGFloat labelHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80 : 50;
            
            CGRect gameRect = CGRectInset([[self view] bounds], sideBarRect.size.width, labelHeight);
            
            CGRect labelRect = CGRectMake(sideBarRect.size.width, height - labelHeight, width - 2 * sideBarRect.size.width, labelHeight);
            CGRect gameLabelRect = CGRectMake(sideBarRect.size.width, 0, width - 2 * sideBarRect.size.width, labelHeight);
            
            
            void (^animateBlock) (void) = ^(void)
            {
                [_vvh setFrame: CGRectOffset([_vvh frame], -[_vvh frame].size.width, 0)];
                [_sideBar setFrame: sideBarRect];
                [_messageLabel setFrame: labelRect];
                [_gameNameLabel setFrame: gameLabelRect];
                
                [_gameView setFrame: gameRect];
                [_gameView setNeedsDisplay];
            };
            
            void (^completion) (BOOL) = ^(BOOL done)
            {
                [_vvh removeFromSuperview];
                [_vvh release];
                _vvh = nil;
            };
            
            [UIView animateWithDuration: 0.25f animations: animateBlock completion: completion];
        }
        
        _showingVVH = !_showingVVH;
    }
    else if (1002 <= [sender tag] && [sender tag] <= 1006)
    {
        GCModalDrawerView *drawer = (GCModalDrawerView *) [[self view] viewWithTag: [sender tag] + 1000];
        [[self view] bringSubviewToFront: drawer];
        [drawer slideIn];
    }
    else if ([sender tag] == 1000)
    {
        [_gameController undo];
    }
    else if ([sender tag] == 1001)
    {
        [_gameController redo];
    }
}


- (void) addSidebarInRect: (CGRect) sideBarRect;
{
    _sideBar = [[GCSidebarView alloc] initWithFrame: sideBarRect];
    
    
    CGFloat buttonHeight = (sideBarRect.size.height - 9 * 4) / 8;
    
    NSArray *imageNames = [NSArray arrayWithObjects: @"undo", @"redo", @"vvh", @"players", @"variants", @"values", @"settings", @"home", nil];
    
    for (int i = 0; i < 8; i += 1)
    {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setImage: [UIImage imageNamed: [imageNames objectAtIndex: i]] forState: UIControlStateNormal];
        [button setFrame: CGRectMake(0, 4 + (4 + buttonHeight) * i, 44, buttonHeight)];
        [button addTarget: self action: @selector(sidebarButtonTapped:) forControlEvents: UIControlEventTouchUpInside];
        [button setTag: 1000 + i];
        
        [_sideBar addSubview: button];
        
        if ((i == 0) || (i == 1))
            [button setEnabled: NO];
    }
    
    [[self view] addSubview: _sideBar];
    
#warning TODO: Find a better way to do this, once I've defined all of the panels.
    CGFloat drawerWidths[]  = { 0, 0, 0, 0, 0 };
    CGFloat drawerHeights[] = { 0, 0, 0, 0, 0 };
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        drawerWidths[0] = 460;  drawerHeights[0] = sideBarRect.size.height;
        drawerWidths[1] = 460;  drawerHeights[1] = sideBarRect.size.height; 
        drawerWidths[2] = 460;  drawerHeights[2] = sideBarRect.size.height;
        drawerWidths[3] = 360;  drawerHeights[3] = sideBarRect.size.height;
        drawerWidths[4] = 360;  drawerHeights[4] = sideBarRect.size.height;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        drawerWidths[0] = 460;  drawerHeights[0] = sideBarRect.size.height;
        drawerWidths[1] = 460;  drawerHeights[1] = 300;
        drawerWidths[2] = 460;  drawerHeights[2] = sideBarRect.size.height;
        drawerWidths[3] = 360;  drawerHeights[3] = 250;
        drawerWidths[4] = 360;  drawerHeights[4] = 240;
    }
    
    for (int i = 2; i <= 6; i += 1)
    {
        CGRect drawerRect = CGRectMake(0, sideBarRect.origin.y + (sideBarRect.size.height - drawerHeights[i - 2]) / 2.0f, drawerWidths[i - 2], drawerHeights[i - 2]);
        GCModalDrawerView *drawer = [[GCModalDrawerView alloc] initWithFrame: drawerRect startOffscreen: YES];
        [drawer setTag: 2000 + i];
        [drawer setDelegate: self];
        [[self view] addSubview: drawer];
        
        if ((i == 2) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone))
        {
            GCVVHPanelController *vvhPanel = [[GCVVHPanelController alloc] initWithDataSource: self];
            [drawer setPanelController: vvhPanel];
            [vvhPanel release];
        }
        else if (i == 3)
        {
            GCPlayerPanelController *playerPanel = [[GCPlayerPanelController alloc] initWithGame: _game];
            [drawer setPanelController: playerPanel];
            [playerPanel release];
        }
        else if (i == 4)
        {
            GCVariantsPanelController *variantsPanel = [[GCVariantsPanelController alloc] initWithGame: _game];
            [variantsPanel setDelegate: self];
            [drawer setPanelController: variantsPanel];
            [variantsPanel release];
        }
        else if (i == 5)
        {
            GCValuesPanelController *valuesPanel = [[GCValuesPanelController alloc] initWithGame: _game];
            [drawer setPanelController: valuesPanel];
            [valuesPanel setDelegate: self];
            [valuesPanel release];
        }
        else if (i == 6)
        {
            metaPanel = [[GCMetaSettingsPanelController alloc] init];
            [drawer setPanelController: metaPanel];
        }
        
        [drawer release];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 320)] autorelease]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)] autorelease]];
    
    CGFloat width = [[self view] bounds].size.width;
    CGFloat height = [[self view] bounds].size.height;
    
    CGRect sideBarRect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        sideBarRect = CGRectMake(0, 20, 44, height - 40);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        sideBarRect = CGRectMake(0, (height - 480) / 2.0f, 44, 480);
    else
        sideBarRect = CGRectZero;
    
    [self addSidebarInRect: sideBarRect];
    
    CGFloat labelHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80 : 50;
    
    CGRect gameRect = CGRectInset([[self view] bounds], sideBarRect.size.width, labelHeight);
    
    _gameView = [_game viewWithFrame: gameRect];
    [_gameView setClipsToBounds: NO];
    
    [[self view] addSubview: _gameView];
    
    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeInfoLight];
    [infoButton setCenter: CGPointMake(width - 15, height - 15)];
    [[self view] addSubview: infoButton];
    
    
    _messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(sideBarRect.size.width, height - labelHeight, width - 2 * sideBarRect.size.width, labelHeight)];
    [_messageLabel setBackgroundColor: [UIColor clearColor]];
    [_messageLabel setNumberOfLines: 2];
    [_messageLabel setLineBreakMode: UILineBreakModeWordWrap];
    UIFont *font = [UIFont boldSystemFontOfSize: (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 24 : 17];
    [_messageLabel setFont: font];
    [_messageLabel setTextAlignment: UITextAlignmentCenter];
    [_messageLabel setTextColor: [UIColor whiteColor]];
    [_messageLabel setText: @""];
    
    [[self view] addSubview: _messageLabel];
    
    
    _gameNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(sideBarRect.size.width, 0, width - 2 * sideBarRect.size.width, labelHeight)];
    [_gameNameLabel setBackgroundColor: [UIColor clearColor]];
    font = [UIFont boldSystemFontOfSize: (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 40 : 24];
    [_gameNameLabel setFont: font];
    [_gameNameLabel setTextAlignment: UITextAlignmentCenter];
    [_gameNameLabel setTextColor: [UIColor whiteColor]];
    
    [[self view] addSubview: _gameNameLabel];
    
    [[self view] sendSubviewToBack: _gameNameLabel];
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
    
    [_game startGameWithLeft: left
                       right: right
                     options: [NSDictionary dictionaryWithObject: [NSNumber numberWithBool: NO] forKey: GCMisereOptionKey]];
    
    [left release];
    [right release];
    
    _gameController = [[GCGameController alloc] initWithGame: _game andDelegate: self];
    
    [metaPanel setDelegate: _gameController];
    
    [self updateStatusLabel];
    
    [_gameController start];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_messageLabel release];
    [_gameNameLabel release];
    
    [_gameController release];
    
    [_sideBar release];
    
    [metaPanel release];
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
