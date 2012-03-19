//
//  GCVariantsPanelController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCVariantsPanelController.h"

@implementation GCVariantsPanelController

#pragma mark - GCModalDrawerPanelDelegate

- (BOOL) wantsSaveButton
{
    return YES;
}


- (BOOL) wantsDoneButton
{
    return NO;
}


- (BOOL) wantsCancelButton
{
    return YES;
}


- (NSString *) title
{
    return @"Game Variants";
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460, 280 - 32)] autorelease]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460, 480 - 44)] autorelease]];
    
    
    CGFloat width  = self.view.bounds.size.width;
    
    UILabel *misereLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, width - 40, 25)];
    [misereLabel setBackgroundColor: [UIColor clearColor]];
    [misereLabel setTextColor: [UIColor whiteColor]];
    [misereLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [misereLabel setText: @"Misère"];
    
    [self.view addSubview: misereLabel];
    [misereLabel release];
    
    
    UISwitch *misereSwitch = [[UISwitch alloc] init];
    [misereSwitch setCenter: CGPointMake(width - 20 - misereSwitch.frame.size.width / 2.0f, 20 + (25 / 2.0f))];
    
    [self.view addSubview: misereSwitch];
    [misereSwitch release];
}

@end
