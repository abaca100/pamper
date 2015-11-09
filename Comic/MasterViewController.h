//
//  MasterViewController.h
//  Comic
//
//  Created by Jack Lee on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
	NSMutableArray      *division;
	NSMutableArray      *spots;
    NSMutableArray      *scene;
    NSMutableDictionary *scape;
    
	NSMutableArray      *theData;
    NSMutableDictionary *theComics;
    
    UIPickerView        *picker;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

- (IBAction)choosePressed:(id)sender;

@end
