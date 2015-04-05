//
//  ViewController.m
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 01/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Controller Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // hide the UI components
    [self.eventsDatePicker setHidden:YES];
    [self.datePickerToolBar setHidden:YES];
    [self.eventsShowSubview setHidden:YES];
    [self.errorLabel setHidden:YES];
    // set font for UISegment Controll
    UIFont *font = [UIFont fontWithName:FONT_AVENIRNEXT_FONT size:18];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    // Refresh Button on Navigation bar
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    // set home screen title
    self.navigationController.navigationBar.topItem.title = HOME_SCREEN_TITLE;
    // webservice call for fetching the data
    [[WebRequestController instance] startDownloadFromURLWithBody:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Protocol Methods
// custom protocol method for updating the UI once after webservice is called
- (void) updateHTTPResponseToUI:(NSError*)error response:(NSArray *)theResponseArray {
    self.eventsDataArr = [[NSMutableArray alloc]init];
    [self.eventsDataArr addObjectsFromArray:theResponseArray];
    [self loadAllEvents];
}

#pragma mark - Collection View Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.eventsDataArr valueForKey:DATE] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"EventsCollectionViewCell";
    EventsCollectionViewCell *cell = (EventsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *dateString= [[self.eventsDataArr valueForKey:DATE] objectAtIndex:indexPath.row];
    // set month label
    UILabel *monthLabel = (UILabel*)[cell viewWithTag:MONTH_LABEL_TAG];
    [monthLabel setFont:[UIFont fontWithName:FONT_BASKERVILLE size:15]];
    //setting date format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT_ddMMyyyy];
    NSDate   *aDate = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateSt = [dateFormatter stringFromDate:aDate];
    NSString *monthName = [[dateSt componentsSeparatedByString:@" "] firstObject];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:aDate];
    // set day label
    UILabel *dayLabel = (UILabel*)[cell viewWithTag:DAY_LABEL_TAG];
    dayLabel.text = [NSString stringWithFormat:@"%ld",(long)[components day] ];
    NSString* yearStr = [NSString stringWithFormat:@"%ld",(long)[components year] ];
    monthLabel.text = [NSString stringWithFormat:@"%@ %@", monthName,yearStr];//monthName;
    // set tiitle label
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:1];
    titleLabel.text = [[[self.eventsDataArr valueForKey:DETAILS] valueForKey:TITLE]objectAtIndex:indexPath.row];
    [titleLabel setFont:[UIFont fontWithName:FONT_BASKERVILLE size:13]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // show pop controller when selecting the events on collection view
   EventsDisplayViewController *popViewController = [[EventsDisplayViewController alloc]initWithNibName:@"EventsDisplayViewController" bundle:nil withDataArray:[[[self.eventsDataArr valueForKey:DETAILS] valueForKey:DESCRIPTION] objectAtIndex:indexPath.row]];
    self.eventShowPopController = [[UIPopoverController alloc] initWithContentViewController:popViewController];
    self.eventShowPopController.popoverContentSize = CGSizeMake(350.0, 250.0);
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.eventShowPopController presentPopoverFromRect:cell.frame inView:collectionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    // set title and date label
    popViewController.titleLabel.text = [[[self.eventsDataArr valueForKey:DETAILS] valueForKey:TITLE] objectAtIndex:indexPath.row];
    popViewController.dateLabel.text = [[self.eventsDataArr valueForKey:DATE] objectAtIndex:indexPath.row];
}


#pragma mark - Button Action methods
// Segment controll method for loading the data when segments are pressed
- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    // populate data when segments are selected
    if (selectedSegment == 0){
        [self.eventsShowSubview setHidden:YES];
        [self.errorLabel setHidden:YES];
        [self.datePickerToolBar setHidden:YES];
        [self.mCollectionView setHidden:NO];
        [self.eventsDatePicker setHidden:YES];
        [self loadAllEvents];
    }
    else if (selectedSegment == 1)
        [self loadEventsByDates];
}

// Button action when search Button is pressed
- (IBAction)searchDateBtnPressed:(id)sender {
    NSDate* searchDate =  self.eventsDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT_ddMMyyyy];
    NSString *dateString = [dateFormatter stringFromDate:searchDate];
    
    for (int i=0; i < [self.eventsDataArr count]; i++) {
        if ([dateString isEqualToString:[[self.eventsDataArr valueForKey:DATE]objectAtIndex:i]]) {
            [self.eventsShowSubview setHidden:NO];
            [self.errorLabel setHidden:YES];
            
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];// date in long style
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];  
            NSString *dateSt = [dateFormatter stringFromDate:searchDate];
            NSString *monthName = [[dateSt componentsSeparatedByString:@" "] firstObject];//get month name from the date
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:searchDate];
            // set title, month, day and description information to the labels
            self.titleLabel.text = [[[self.eventsDataArr valueForKey:DETAILS] valueForKey:TITLE] objectAtIndex:i];
            self.monthLabel.text = monthName;
            [self.monthLabel setFont:[UIFont fontWithName:FONT_MARKERFELT size:22]];
            self.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)[components day] ];//get day from the date
            self.yearLabel.text = [NSString stringWithFormat:@"%ld",(long)[components year] ];// get year from the date
            NSArray *descriptionArr = [[[self.eventsDataArr valueForKey:DETAILS] valueForKey:DESCRIPTION] objectAtIndex:i];
            // remove dynamically created labels in EventsBtDates
            int tagIncrement = 0;
            for (UIView *view in [self.eventsShowSubview subviews]){
                if([view isKindOfClass:[UILabel class]]){
                    UILabel *newLbl = (UILabel *)view;
                    if(newLbl.tag == tagIncrement+DESCRIPTION_LABEL_TAG){
                        [newLbl removeFromSuperview];
                        tagIncrement++;
                    }
                }
            }
            // create label dynamically for description in EventsByDates
            for (int j=0; j< [descriptionArr count]; j++) {
                UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(431, 108 + j*30, 300, 21)];
                descriptionLabel.text = [descriptionArr objectAtIndex:j];
                descriptionLabel.tag = j+DESCRIPTION_LABEL_TAG;
                [self.eventsShowSubview addSubview:descriptionLabel];
            }
            return;
        }
        else {
            // hide events subview
            [self.eventsShowSubview setHidden:YES];
            // show error if no available events
            [self.errorLabel setHidden:NO];
        }
    }
}

// refreshing the data from the webservices
-(void)refreshButtonPressed:(id)sender{
    [[WebRequestController instance] startDownloadFromURLWithBody:self];
}

#pragma mark - Methods implementation
// Loading all the events
- (void)loadAllEvents {
    [self.mCollectionView registerClass:[EventsCollectionViewCell class] forCellWithReuseIdentifier:@"EventsCollectionViewCell"];
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 50, 50, 50);
    collectionViewLayout.itemSize = CGSizeMake(150, 150);
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.mCollectionView setCollectionViewLayout:collectionViewLayout];
    [self.mCollectionView reloadData];
}
// load events based on search
- (void)loadEventsByDates {
    [self.mCollectionView setHidden:YES];
    [self.eventsDatePicker setHidden:NO];
    [self.datePickerToolBar setHidden:NO];
}


@end
