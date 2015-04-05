//
//  EventsDisplayViewController.m
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 03/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import "EventsDisplayViewController.h"

@interface EventsDisplayViewController ()

@end

@implementation EventsDisplayViewController
@synthesize titleLabel, dateLabel, descriptionLabel;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDataArray:(NSMutableArray *)data{
    [self setDataArray:data];
    return self;
}

#pragma mark - View Controller Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Handling the pop controller description dynamically
    UILabel *descriptionLabel1;
    for (int i=0; i< [self.dataArray count]; i++) {
        descriptionLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(139, 160 + i*30, 300, 21)];
        descriptionLabel1.text = [self.dataArray objectAtIndex:i];
        [self.view addSubview:descriptionLabel1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
