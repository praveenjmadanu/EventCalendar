//
//  EventsCollectionViewCell.m
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 03/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import "EventsCollectionViewCell.h"

@implementation EventsCollectionViewCell
@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"EventsCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
    
}

@end
