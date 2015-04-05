//
//  ViewController.h
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 01/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <updateUI>
@property (nonatomic, weak)IBOutlet UICollectionView *mCollectionView;
@property (nonatomic, retain) NSMutableArray* eventsDataArr;
@property (nonatomic, retain) UIPopoverController *eventShowPopController;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventsDatePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *datePickerToolBar;

@property (weak, nonatomic) IBOutlet UIView *eventsShowSubview;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentSwitch:(id)sender;
- (IBAction)searchDateBtnPressed:(id)sender;

@end

