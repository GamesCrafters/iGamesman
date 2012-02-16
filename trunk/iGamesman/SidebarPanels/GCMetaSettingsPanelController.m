//
//  GCMetaSettingsPanelController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCMetaSettingsPanelController.h"

@implementation GCMetaSettingsPanelController

#pragma mark - GCModalDrawerPanelDelegate

- (BOOL) wantsSaveButton
{
    return YES;
}


- (BOOL) wantsCancelButton
{
    return YES;
}


- (BOOL) wantsDoneButton
{
    return NO;
}


- (NSString *) title
{
    return @"Game Play Settings";
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360 - 20, 280 - 32)] autorelease];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360 - 20, 280 - 44)] autorelease];
}

@end
