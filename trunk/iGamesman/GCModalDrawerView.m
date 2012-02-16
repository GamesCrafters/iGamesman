//
//  GCDrawerView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCModalDrawerView.h"

#import <QuartzCore/QuartzCore.h>

#define OUTER_RADIUS (10)


#pragma mark -

@implementation GCModalDrawerView

@synthesize delegate;

#pragma mark -
#pragma mark Memory lifecycle

- (id) initWithFrame: (CGRect) frame startOffscreen: (BOOL) offscreen;
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat width = self.frame.size.width;
        if (offscreen)
        {
            self.frame = CGRectOffset(self.frame, -width, 0);
        }
        
        self.opaque = NO;
        
        panelController = nil;
        
        CGFloat toolbarHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 44 : 32;
        toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, width, toolbarHeight)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancel)];
        
        [toolbar setItems: [NSArray arrayWithObject: cancelButton]];
        
        [cancelButton release];
        
        [self addSubview: toolbar];
    }
    return self;
}


- (void) dealloc
{
    [closeButton release];
    [toolbar release];
    [panelController release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Sliding animations

- (void) slideIn
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        backgroundView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 320)];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        backgroundView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)];
    else
        backgroundView = nil;
    [backgroundView setBackgroundColor: [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1]];
    [backgroundView setAlpha: 0];
    
    [delegate addView: backgroundView behindDrawer: self];
    
    void (^slideBlock) (void) = ^(void)
    {
        self.frame = CGRectOffset(self.frame, +self.frame.size.width, 0);
        closeButton.alpha = 1;
        
        [backgroundView setAlpha: 0.5f];
    };
    
    if ([panelController respondsToSelector: @selector(drawerWillAppear)])
        [panelController drawerWillAppear];
    
    [UIView animateWithDuration: 0.25f
                     animations: slideBlock];
}


- (void) slideOut
{
    void (^slideBlock) (void) = ^(void)
    {
        self.frame = CGRectOffset(self.frame, -self.frame.size.width, 0);
        closeButton.alpha = 0;
        
        [backgroundView setAlpha: 0];
    };
    
    void (^completionBlock) (BOOL) = ^(BOOL done)
    {
        if (done)
        {
            [backgroundView removeFromSuperview];
            [backgroundView release];
            
            if ([delegate respondsToSelector: @selector(drawerDidDisappear:)])
                [delegate drawerDidDisappear: self];
        }
    };
    
    [UIView animateWithDuration: 0.25f
                     animations: slideBlock 
                     completion: completionBlock];
}


#pragma mark -

- (void) save
{
    if ([panelController respondsToSelector: @selector(drawerWillDisappear)])
        [panelController drawerWillDisappear];
    
    if ([panelController respondsToSelector: @selector(saveButtonTapped)])
        [panelController saveButtonTapped];
    
    [self slideOut];
}


- (void) cancel
{
    if ([panelController respondsToSelector: @selector(drawerWillDisappear)])
        [panelController drawerWillDisappear];
    
    if ([panelController respondsToSelector: @selector(cancelButtonTapped)])
        [panelController cancelButtonTapped];
    
    [self slideOut];
}


- (void) done
{
    if ([panelController respondsToSelector: @selector(drawerWillDisappear)])
        [panelController drawerWillDisappear];
    
    if ([panelController respondsToSelector: @selector(doneButtonTapped)])
        [panelController doneButtonTapped];
    
    [self slideOut];
}


- (void) setPanelController: (UIViewController<GCModalDrawerPanelDelegate> *) controller
{
    if (panelController)
        [panelController release];
    
    panelController = [controller retain];
    
    [panelController.view setFrame: CGRectOffset(panelController.view.frame, 0, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 32 : 44)];
    
    [self addSubview: panelController.view];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(save)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancel)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: [toolbar frame]];
    [titleLabel setBackgroundColor: [UIColor clearColor]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [titleLabel setFont: [UIFont boldSystemFontOfSize: 16]];
        [titleLabel setTextColor: [UIColor whiteColor]];
        [titleLabel setShadowColor: [UIColor darkGrayColor]];
        [titleLabel setShadowOffset: CGSizeMake(-1, -1)];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [titleLabel setFont: [UIFont boldSystemFontOfSize: 20]];
        [titleLabel setTextColor: [UIColor grayColor]];
    }
    [titleLabel setTextAlignment: UITextAlignmentCenter];
    [titleLabel setText: [panelController title]];
    
    [self addSubview: titleLabel];
    
    [titleLabel release];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity: 3];
    
    [items addObject: flexibleSpace];
    
    if ([panelController wantsCancelButton])
        [items insertObject: cancelButton atIndex: 0];
    
    if ([panelController wantsSaveButton])
        [items addObject: saveButton];
    else if ([panelController wantsDoneButton])
        [items addObject: doneButton];
    
    [doneButton release];
    [saveButton release];
    [cancelButton release];
    [flexibleSpace release];
    
    [toolbar setItems: items];
    
    [items release];
}


#pragma mark -
#pragma mark Drawing

- (void) drawRect: (CGRect) rect
{
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /* Draw the background rectangle */
    CGContextMoveToPoint(ctx, minX, minY);
    CGContextAddLineToPoint(ctx, minX, maxY);
    CGContextAddArcToPoint(ctx, maxX, maxY, maxX, maxY - OUTER_RADIUS, OUTER_RADIUS);
    CGContextAddArcToPoint(ctx, maxX, minY, maxX - OUTER_RADIUS, minY, OUTER_RADIUS);
    CGContextAddLineToPoint(ctx, minX, minY);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.9f);
    
    CGContextFillPath(ctx);
}


@end
