//
//  main.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 12/29/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([GCAppDelegate class]));
    
    [pool drain];
    
    return retVal;
}
