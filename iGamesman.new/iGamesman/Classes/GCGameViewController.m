//
//  GCGameViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCGameViewController.h"

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
    
    CGRect sideBarRect = CGRectMake(width - 44, 20, 44, height - 40);
    
    GCSidebarView *sideBar = [[GCSidebarView alloc] initWithFrame: sideBarRect];
    
    
    CGFloat buttonHeight = (sideBarRect.size.height - 9 * 4) / 8;
    
    NSArray *imageNames = [NSArray arrayWithObjects: @"undo", @"redo", @"vvh", @"players", @"variants", @"values", @"settings", @"home", nil];
    
    for (int i = 0; i < 8; i += 1)
    {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        //[button setTitle: [NSString stringWithFormat: @"%d", i] forState: UIControlStateNormal];
        [button setImage: [UIImage imageNamed: [imageNames objectAtIndex: i]] forState: UIControlStateNormal];
        [button setFrame: CGRectMake(0, 4 + (4 + buttonHeight) * i, 44, buttonHeight)];
        [button addTarget: self action: @selector(sidebarButtonTapped:) forControlEvents: UIControlEventTouchUpInside];
        [button setTag: 1000 + i];
        
        [sideBar addSubview: button];
    }
    
    [self.view addSubview: sideBar];
    
    [sideBar release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
