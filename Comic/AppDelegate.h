//
//  AppDelegate.h
//  Comic
//
//  Created by Jack Lee on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)loadPage;
+ (void)savePage;

@end
