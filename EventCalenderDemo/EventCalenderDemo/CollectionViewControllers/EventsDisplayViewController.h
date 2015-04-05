//
//  EventsDisplayViewController.h
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 03/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsDisplayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSMutableArray *dataArray;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDataArray:(NSMutableArray *)data;
@end
