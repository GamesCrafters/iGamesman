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

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Memory lifecycle

- (id) initWithFrame: (CGRect) frame startOffscreen: (BOOL) offscreen;
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat width = [self frame].size.width;
        if (offscreen)
        {
            [self setFrame: CGRectOffset([self frame], -width, 0)];
        }
        
        [self setOpaque: NO];
        
        _panelController = nil;
        
        CGFloat toolbarHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 44 : 32;
        _toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, width, toolbarHeight)];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancel)];
        
        [_toolbar setItems: [NSArray arrayWithObject: cancelButton]];
        
        [cancelButton release];
        
        [self addSubview: _toolbar];
    }
    return self;
}


- (void) dealloc
{
    [_closeButton release];
    [_toolbar release];
    [_panelController release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Sliding animations

- (void) slideIn
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        _backgroundView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 320)];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        _backgroundView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)];
    else
        _backgroundView = nil;
    [_backgroundView setBackgroundColor: [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1]];
    [_backgroundView setAlpha: 0];
    
    [_delegate addView: _backgroundView behindDrawer: self];
    
    void (^slideBlock) (void) = ^(void)
    {
        [self setFrame: CGRectOffset([self frame], [self frame].size.width, 0)];
        [_closeButton setAlpha: 1];
        
        [_backgroundView setAlpha: 0.5f];
    };
    
    if ([_panelController respondsToSelector: @selector(drawerWillAppear)])
        [_panelController drawerWillAppear];
    
    [UIView animateWithDuration: 0.25f
                     animations: slideBlock];
}


- (void) slideOut
{
    void (^slideBlock) (void) = ^(void)
    {
        [self setFrame: CGRectOffset(self.frame, -self.frame.size.width, 0)];
        [_closeButton setAlpha: 0];
        
        [_backgroundView setAlpha: 0];
    };
    
    void (^completionBlock) (BOOL) = ^(BOOL done)
    {
        if (done)
        {
            [_backgroundView removeFromSuperview];
            [_backgroundView release];
            
            if ([_delegate respondsToSelector: @selector(drawerDidDisappear:)])
                [_delegate drawerDidDisappear: self];
        }
    };
    
    [UIView animateWithDuration: 0.25f
                     animations: slideBlock 
                     completion: completionBlock];
}


#pragma mark -

- (void) save
{
    if ([_panelController respondsToSelector: @selector(drawerWillDisappear)])
        [_panelController drawerWillDisappear];
    
    if ([_panelController respondsToSelector: @selector(saveButtonTapped)])
        [_panelController saveButtonTapped];
    
    [self slideOut];
}


- (void) cancel
{
    if ([_panelController respondsToSelector: @selector(drawerWillDisappear)])
        [_panelController drawerWillDisappear];
    
    if ([_panelController respondsToSelector: @selector(cancelButtonTapped)])
        [_panelController cancelButtonTapped];
    
    [self slideOut];
}


- (void) done
{
    if ([_panelController respondsToSelector: @selector(drawerWillDisappear)])
        [_panelController drawerWillDisappear];
    
    if ([_panelController respondsToSelector: @selector(doneButtonTapped)])
        [_panelController doneButtonTapped];
    
    [self slideOut];
}


- (void) setPanelController: (UIViewController<GCModalDrawerPanelDelegate> *) controller
{
    if (_panelController)
        [_panelController release];
    
    _panelController = [controller retain];
    
    [[_panelController view] setFrame: CGRectOffset([[_panelController view] frame], 0, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 32 : 44)];
    
    [self addSubview: [_panelController view]];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(save)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancel)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: [_toolbar frame]];
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
    [titleLabel setText: [_panelController title]];
    
    [self addSubview: titleLabel];
    
    [titleLabel release];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity: 3];
    
    [items addObject: flexibleSpace];
    
    if ([_panelController wantsCancelButton])
        [items insertObject: cancelButton atIndex: 0];
    
    if ([_panelController wantsSaveButton])
        [items addObject: saveButton];
    else if ([_panelController wantsDoneButton])
        [items addObject: doneButton];
    
    [doneButton release];
    [saveButton release];
    [cancelButton release];
    [flexibleSpace release];
    
    [_toolbar setItems: items];
    
    [items release];
}


#pragma mark -
#pragma mark Drawing

- (void) drawRect: (CGRect) rect
{
    CGFloat minX = CGRectGetMinX([self bounds]);
    CGFloat maxX = CGRectGetMaxX([self bounds]);
    CGFloat minY = CGRectGetMinY([self bounds]);
    CGFloat maxY = CGRectGetMaxY([self bounds]);
    
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
