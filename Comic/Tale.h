//
//  Tale.h
//  Maq
//
//  Created by abaca on 2010/12/13.
//  Copyright 2010 Q93DD8Y2L9.com.maq.Franklin. All rights reserved.
//

#import "Connectivity.h"
#import "SVProgressHUD.h"


@interface Tale : UIViewController <UISplitViewControllerDelegate, UIAlertViewDelegate>
{
	NSURLConnection			*urlConnection;
	NSMutableData			*urlData;

	BOOL					commited;
}

@property (nonatomic, retain) NSURLConnection			*urlConnection;
@property (nonatomic, retain) NSMutableData				*urlData;   

@property (nonatomic)		  BOOL						commited;


- (void)handleError:(NSError *)error;
- (BOOL)online;
- (void)noneNet;

@end
