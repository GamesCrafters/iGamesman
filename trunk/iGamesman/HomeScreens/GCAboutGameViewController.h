//
//  GCAboutGameViewController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/4/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAboutGameViewController : UIViewController <NSXMLParserDelegate>
{
    NSDictionary *_gameData;
    
    UIScrollView *_scroller;
}

- (id) initWithXMLPath: (NSString *) pathToXML
             viewFrame: (CGRect) frame;
- (void) setShowsDoneButton: (BOOL) showsDone;

@end
