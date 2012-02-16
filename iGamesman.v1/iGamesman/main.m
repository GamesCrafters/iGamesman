//
//  main.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/7/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iGamesmanAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([iGamesmanAppDelegate class]));
    
    [pool drain];
    
    return retVal;
}
