//
//  WebRequestController.h
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 01/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

// Custom protocol for handling the web request and updating the UI
@protocol updateUI;
@protocol updateUI <NSObject>
- (void) updateHTTPResponseToUI:(NSError*)error response:(NSArray *)theResponse;
@end

@interface WebRequestController : NSObject <NSURLConnectionDelegate> {
    NSMutableData* mWebData;
    LoadingView *mLoadingView_;
    AppDelegate *mAppDelegate_;
}

@property (nonatomic, retain) id <updateUI> mNetworkUIDelegate_;
@property (nonatomic,retain) LoadingView *mLoadingView_;

+ (WebRequestController*)instance;
-(void)startDownloadFromURLWithBody:(id)delegateToResponsd;

@end
