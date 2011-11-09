//
//  GCGameViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCGameViewController.h"

#import "GCDrawerView.h"
#import "GCSidebarView.h"

@implementation GCGameViewController

- (id) initWithGame: (id<GCGame>) game
{
    self = [super init];
    
    if (self)
    {
        
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
        [drawer slideIn];
    }
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
    
    CGRect sideBarRect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        sideBarRect = CGRectMake(width - 44, 20, 44, height - 40);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        sideBarRect = CGRectMake(width - 44, (height - 480) / 2.0f, 44, 480);
    else
        sideBarRect = CGRectZero;
    
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
    }
    
    [self.view addSubview: sideBar];
    
    [sideBar release];
    
    CGFloat drawerWidths[] = { 460, 200, 300, 150, 300 };
    for (int i = 2; i <= 6; i += 1)
    {
        GCDrawerView *drawer = [[GCDrawerView alloc] initWithFrame: CGRectMake(width - drawerWidths[i-2], sideBarRect.origin.y, drawerWidths[i-2], sideBarRect.size.height) startOffscreen: YES];
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
