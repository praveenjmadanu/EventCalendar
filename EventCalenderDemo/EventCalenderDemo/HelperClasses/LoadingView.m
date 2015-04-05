//
//  LoadingView.m
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 01/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import "LoadingView.h"
#import "Constants.h"

@implementation LoadingView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mAppDelegate_=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

// Draw the view.
- (void)drawRect:(CGRect)rect {
    // Adding Activity Indicator to Load View
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    [self setBackgroundColor:CLEAR_COLOR];
    activityIndicatorView.center = [mAppDelegate_.window center];
}



@end
