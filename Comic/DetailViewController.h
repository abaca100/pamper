//
//  DetailViewController.h
//  Comic
//
//  Created by Jack Lee on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Tale.h"
#import "Recreation.h"


//@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
@interface DetailViewController : Tale
{
    IBOutlet UIImageView *imgView;
    
	// for HTML
    NSString *base;
    NSString *i_pageNo, *i_comicCode, *i_sortCode;
	CGFloat	 pos;
	
	NSString *kReceivedDataNotif;
    
    Recreation  *fun;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) NSString *i_comicCode;
@property (strong, nonatomic) NSString *i_sortCode;
@property (strong, nonatomic) NSString *i_pageNo;


-(void) link_Server;

@end
