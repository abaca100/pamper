//
//  Tale.m
//  AOA
//
//  Created by abaca on 2010/12/13.
//  Copyright 2012 Q93DD8Y2L9.co.aoa All rights reserved.
//

#import "Tale.h"


@implementation Tale

@synthesize urlConnection, urlData;

@synthesize commited;

#pragma mark -
#pragma mark NSURLConnection delegate methods

// Handle errors in the download by showing an alert to the user. This is a very
// simple way of handling the error, partly because this application does not have any offline
// functionality for the user. Most real applications should handle the error in a less obtrusive
// way and provide offline functionality to the user.
//
- (void)handleError:(NSError *)error 
{
    [SVProgressHUD dismiss];
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:
     NSLocalizedString(@"連線時間過長或網路連線發生錯誤",
                       @"Title for alert displayed when download or parse error occurs.")
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
}

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is
// how the connection object, which is working in the background, can asynchronously communicate back
// to its delegate on the thread from which it was started - in this case, the main thread.
//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;  
    // check for HTTP status code for proxy authentication failures
    // anything in the 200 to 299 range is considered successful,
    // also make sure the MIMEType is correct:
    //
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //if ((([httpResponse statusCode]/100) == 2) && [[response MIMEType] isEqual:@"application/atom+xml"]) {
	if (([httpResponse statusCode]/100) == 2) {
        self.urlData = [NSMutableData data];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        [self handleError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [urlData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;  
	[SVProgressHUD dismissWithError:@"連線時發生錯誤"];
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:
         NSLocalizedString(@"No Connection Error",
                           @"Error message displayed when not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        [self handleError:error];
    }

    self.urlConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    self.urlConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    [SVProgressHUD dismiss];
	[self setCommited:YES];
    // Spawn an NSOperation to parse the earthquake data so that the UI is not blocked while the
    // application parses the XML data.
    //
    // IMPORTANT! - Don't access or affect UIKit objects on secondary threads.
    //
	
}

// for SSL Connection
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace 
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

// for SSL Connection
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		//if ([trustedHosts containsObject:challenge.protectionSpace.host])
			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] 
				 forAuthenticationChallenge:challenge];

	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


#pragma mark -
#pragma mark Initialization

- (BOOL)online
{
	return [UIDevice isConnected];
}

- (void)noneNet 
{
	UIAlertView *alert;
	alert = [[UIAlertView alloc] 
			 initWithTitle:@"錯誤訊息" 
			 message: @"目前無法連接網路或網路發生錯誤"
			 delegate:self 
			 cancelButtonTitle:@"確定" 
			 otherButtonTitles:nil, 
			 nil];
	[alert show];
}




#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];

	[urlConnection cancel];
	self.urlData		= nil;
	self.urlConnection	= nil;
}

@end

