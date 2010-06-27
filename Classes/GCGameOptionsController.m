//
//  GCGameOptionsController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/30/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCGameOptionsController.h"


@implementation GCGameOptionsController

@synthesize delegate;
@synthesize mode;
@synthesize delay, sliderOn;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (id) initWithOrientation: (UIInterfaceOrientation) _orientation {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		orientation = _orientation;
		self.tableView.allowsSelection = NO;
	}
	return self;
}

/**
 Message delegate that the user tapped DONE, and
 pass along the new values for showing predictions and
 showing move values.
 */
- (void) done {
	UISwitch *s1 = (UISwitch *) [self.tableView viewWithTag: 1];
	UISwitch *s2 = (UISwitch *) [self.tableView viewWithTag: 2];
	UILabel *valueLabel = (UILabel *) [self.tableView viewWithTag: 1234];
	[delegate optionPanelDidFinish: self predictions: s1.on	moveValues: s2.on computerDelay: [valueLabel.text floatValue]];
}


/**
 Message delegate that the user tapped CANCEL.
 */
- (void) cancel {
	[delegate optionPanelDidCancel: self];
}


- (void) sliderChanged: (UISlider *) sender {
	delay = round(5.0 * sender.value) / 5.0;
	[sender setValue: delay];
	
	UILabel *valueLabel = (UILabel *) [self.tableView viewWithTag: 1234];
	[valueLabel setText: [NSString stringWithFormat: @"%.1f", sender.value]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Options";
	self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel 
																						   target: self 
																						   action: @selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone 
																						   target: self 
																						   action: @selector(done)];
}

/*
- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated]; }
- (void)viewDidAppear:(BOOL)animated { [super viewDidAppear:animated]; }
- (void)viewWillDisappear:(BOOL)animated { [super viewWillDisappear:animated]; }
- (void)viewDidDisappear:(BOOL)animated { [super viewDidDisappear:animated]; }
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
	return orientation == interfaceOrientation;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
	if (orientation == UIInterfaceOrientationPortrait) {
		if (indexPath.row != 2) return 44.0;
		return 88.0;
	} else {
		return 44.0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.backgroundColor = [UIColor colorWithRed: 234.0/255 green: 234.0/255 blue: 255.0/255 alpha: 1];
    }
    
    // Set up the cell
	if (indexPath.row == 0 || indexPath.row == 1) {
		BOOL switchOn;
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Show Predictions";
			switchOn = [delegate showingPredictions];
		}
		if (indexPath.row == 1) {
			cell.textLabel.text = @"Show Move Values";
			switchOn = [delegate showingMoveValues];
		}
		CGRect switchFrame;
		if (orientation == UIInterfaceOrientationPortrait)
			switchFrame = CGRectMake(205.0, 10.0, 95.0, 20.0);
		else
			switchFrame = CGRectMake(365.0, 10.0, 95.0, 20.0);
		UISwitch *pSwitch = [[UISwitch alloc] initWithFrame: switchFrame];
		if (mode == OFFLINE_UNSOLVED) {
			pSwitch.on = NO;
			pSwitch.enabled = NO;
		} else
			pSwitch.on = switchOn;
		pSwitch.tag = indexPath.row + 1;
	
		[cell addSubview: pSwitch];
		[pSwitch release];
	} else if (indexPath.row == 2) {
		CGRect labelFrame;
		CGRect slideFrame;
		CGRect slideValFrame;
		if (orientation == UIInterfaceOrientationPortrait) {
			labelFrame = CGRectMake(20.0, 5.0, 270.0, 34.0);
			slideFrame = CGRectMake(175.0, 54.0, 125.0, 20.0);
			slideValFrame = CGRectMake(175.0, 5.0, 125.0, 34.0);
		} else {
			labelFrame = CGRectMake(20.0, 5.0, 430.0, 34.0);
			slideFrame = CGRectMake(335.0, 12.0, 125.0, 20.0);
			slideValFrame = CGRectMake(285.0, 5.0, 50.0, 34.0);
		}
		UILabel *label = [[UILabel alloc] initWithFrame: labelFrame];
		label.text = @"Computer Move Delay";
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize: 16.0];
			
		UISlider *slide = [[UISlider alloc] initWithFrame: slideFrame];
		slide.continuous = YES;
		[slide addTarget: self action: @selector(sliderChanged:) forControlEvents: UIControlEventValueChanged];
		[cell addSubview: label];
		[cell addSubview: slide];
		slide.minimumValue = 0;
		slide.maximumValue = 2;
		slide.value = delay;
		slide.enabled = sliderOn ? YES : NO;
		
		UILabel *valLabel = [[UILabel alloc] initWithFrame: slideValFrame];
		valLabel.text = [NSString stringWithFormat: @"%.1f", slide.value];
		valLabel.backgroundColor = [UIColor clearColor];
		valLabel.textAlignment = UITextAlignmentCenter;
		valLabel.tag = 1234;
		[cell addSubview: valLabel];
	} else {
		cell.textLabel.text = @"Show Visual Value History";
		if (mode == ONLINE_SOLVED) {
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			cell.textLabel.textColor = [UIColor blackColor];
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIColor grayColor];
		}
	}
	
    return cell;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	[tableView deselectRowAtIndexPath: indexPath animated: NO];
}


- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath {
	if (indexPath.row == 3) {
		NSLog(@"Whee!");
	}
}


- (void)dealloc {
    [super dealloc];
}


@end

