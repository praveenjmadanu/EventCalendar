//
//  WebRequestController.m
//  EventCalenderDemo
//
//  Created by Joshua Praveen on 01/04/15.
//  Copyright (c) 2015 Valuelabs. All rights reserved.
//

#import "WebRequestController.h"

@implementation WebRequestController
@synthesize mNetworkUIDelegate_,mLoadingView_;

static WebRequestController *requestControllerInstance = nil ;
//comment 
+ (WebRequestController*)instance {
    @synchronized (self){
        if (nil==requestControllerInstance) {
            requestControllerInstance=[[WebRequestController alloc]init];
        }
        return requestControllerInstance;
    }
    return nil;
}

- (id)init {
    
    mAppDelegate_ = [AppDelegate appDelegateInstance];
    CGRect loadingViewFrame = loadingViewFrame = CGRectMake(0, 0, 1024, 780);
    // Adding Loading View
    LoadingView *lLoadingView=[[LoadingView alloc]initWithFrame:loadingViewFrame];
    [self setMLoadingView_:lLoadingView];
    [[mAppDelegate_ window] addSubview:[self mLoadingView_]];
    [self.mLoadingView_ setHidden:YES];
    [self.mLoadingView_ setBackgroundColor:RGB(0, 0, 0, 0.5)];
    [mAppDelegate_.window bringSubviewToFront:self.mLoadingView_];
    return self;
}

#pragma mark - Web Service Methods

-(void)startDownloadFromURLWithBody:(id)delegateToResponsd {
    // Show Loading View
    [self showLoading];
    // Webservice URL
    NSString* URLString = WEBSERVICE_URL;
    // Check for Internet Connection
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *internetAlert = [[UIAlertView alloc] initWithTitle:INTERNET_ALLERT message:NETWORK_ERROR_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [internetAlert show];
        return;
    }     
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *theConnection =[NSURLConnection connectionWithRequest:theRequest delegate:self];
    
    if(theConnection)
        mWebData = [NSMutableData data] ;
    
    [self setMNetworkUIDelegate_:delegateToResponsd];
}

#pragma mark - NSURL Delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [mWebData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mWebData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"in %s",__PRETTY_FUNCTION__);
    NSLog(@"error: %@",[error description]);
    if (nil!=error) {
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self hideLoading];

    //-- JSON Parsing
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:mWebData options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray=[responseDict valueForKey:@"dates"];
    
    [self navigateBaseOnWebServiceTypeWithResponse:dataArray];
}

#pragma mark - Custom protocol call
-(void)navigateBaseOnWebServiceTypeWithResponse:(NSArray*)responseDataArr{
    if ([[self mNetworkUIDelegate_]conformsToProtocol:@protocol(updateUI)])
        [[self mNetworkUIDelegate_] updateHTTPResponseToUI:nil response:responseDataArr];
}

#pragma mark - Loadview Methods
-(void)showLoading{
    [self.mLoadingView_ setHidden:NO];
}

-(void)hideLoading{
    [self.mLoadingView_ setHidden:YES];
}

@end
