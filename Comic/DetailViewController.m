//
//  DetailViewController.m
//  Comic
//
//  Created by Jack Lee on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "TFHpple.h"
#import "Tutorial.h"
#import "Contributor.h"


@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize i_pageNo, i_comicCode, i_sortCode;


#pragma mark - Touch Event

-(void) reform_Image
{
    double w, h, rate, gap = 0.0;
    
    bool trans = NO;
    CGAffineTransform transform;
    if (imgView.image.size.width > imgView.image.size.height) {
        transform = CGAffineTransformMakeRotation(90.0 / 180.0 * 3.14);
        trans = YES;
    } else {
        transform = CGAffineTransformMakeRotation(0);
    }
    imgView.transform = transform;
    
    if (trans==YES) {
        rate = self.view.frame.size.height / imgView.image.size.width;
        h = imgView.image.size.width*rate;
        w = imgView.image.size.height*rate;
    } else {
        rate = self.view.frame.size.height / imgView.image.size.height;
        w = imgView.image.size.width*rate;
        h = imgView.image.size.height*rate;
    }
    gap = (int)(abs(self.view.frame.size.width - w) / 2);
    imgView.frame = CGRectMake(gap, 0, w, h);
}

-(void) link_Server
{
	if ([self online] == YES) {
		[SVProgressHUD showWithStatus:@"下載中 。。"];
		@try {
            NSString *fn = [NSString stringWithFormat:@"%@.htm", i_pageNo];
            NSLog(@"fn=%@", base);
            NSString *str = [NSString stringWithFormat:base, i_comicCode, i_sortCode, fn];
            self.title = str;
            NSLog(@"url=%@", str);
            
            NSURL *url = [NSURL URLWithString:str];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString* newStr = [[NSString alloc] initWithData:data encoding:enc];
            NSLog(@"%@", newStr);
            
            NSString *key = @"\"+server+\"";
            NSString *text = nil;
            NSScanner *theScanner = [NSScanner scannerWithString:newStr];
            [theScanner scanUpToString:key intoString:NULL] ; 
            [theScanner scanUpToString:@".jpg" intoString:&text];    
            
            if (text == nil) {
                text = nil;
                key = @"\"+kukudm+\"";
                theScanner = [NSScanner scannerWithString:newStr];
                [theScanner scanUpToString:key intoString:NULL] ; 
                [theScanner scanUpToString:@".jpg" intoString:&text];    
            }

            if (text == nil) {
                text = nil;
                key = @"\"+k0910k+\"";
                theScanner = [NSScanner scannerWithString:newStr];
                [theScanner scanUpToString:key intoString:NULL] ; 
                [theScanner scanUpToString:@".jpg" intoString:&text];    
            }
            
            if (text == nil) {
                text = nil;
                key = @"\"+m200911d+\"";
                theScanner = [NSScanner scannerWithString:newStr];
                [theScanner scanUpToString:key intoString:NULL] ; 
                [theScanner scanUpToString:@".jpg" intoString:&text];    
            }

            if (text == nil) {
                text = nil;
                key = @"\"+m201001d+\"";
                theScanner = [NSScanner scannerWithString:newStr];
                [theScanner scanUpToString:key intoString:NULL] ; 
                [theScanner scanUpToString:@".jpg" intoString:&text];    
            }
            
            if (text == nil) {
                text = nil;
                key = @"\"+m201304d+\"";
                theScanner = [NSScanner scannerWithString:newStr];
                [theScanner scanUpToString:key intoString:NULL] ;
                [theScanner scanUpToString:@".jpg" intoString:&text];
            }
            NSLog(@"text=%@", text);
            if (text == nil) {
                return;
            }
            
            text = [text stringByReplacingOccurrencesOfString:key withString:@""];
            
            if (([@"\"+m201304d+\"" isEqualToString:key]) && ([@"3" isEqualToString:i_comicCode] || [@"6" isEqualToString:i_comicCode]                                                                                                                                                                                                                                                                                                                                                                                                                        )) {
                str = [NSString stringWithFormat:@"http://i.socomic.com/%@.jpg", text];
            } else {
                str = [NSString stringWithFormat:@"http://cc.kukudm.com/%@.jpg", text];
            }
            NSLog(@"imageUrl=%@", str);
            
            str = [str stringByAddingPercentEscapesUsingEncoding:enc];
            str = [str stringByReplacingOccurrencesOfString:@"%5B" withString:@"["];
            str = [str stringByReplacingOccurrencesOfString:@"%5D" withString:@"]"];
            NSLog(@"url=%@", str);

            /*
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:str]
														cachePolicy:NSURLRequestUseProtocolCachePolicy
													timeoutInterval:30.0];
            [self.urlConnection cancel];
            self.urlConnection = nil;
			self.urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
			NSAssert(self.urlConnection != nil, @"Failure to create URL connection.");
            */
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSURL *imageURL = [NSURL URLWithString:str];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imgView.image = image;
                    [self reform_Image];
                });
                imgView.image = image;
                
                /*
                if (self.masterPopoverController != nil) {
                    [self.masterPopoverController dismissPopoverAnimated:YES];
                }
                */
            });
            [self.masterPopoverController dismissPopoverAnimated:YES];
		}
		@catch (NSException * e) {
			[self handleError:nil];
		}
		@finally {
		}
	} else {
		[self noneNet];
	}
	
}

-(void)orientationChanged 
{
	[self reform_Image];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	pos = [[touches anyObject] locationInView:self.view].x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	pos = [[touches anyObject] locationInView:self.view].x - pos;
	
    i_pageNo = [fun nextPage:[NSString stringWithFormat:@"%f", pos] pos:i_pageNo];

	if ([self online] == YES) {
		//[SVProgressHUD showWithStatus:@"下載中 。。"];
        [self link_Server];
    }
}


#pragma mark - KVO support

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    UIImage *image = [UIImage imageWithData:self.urlData];
    imgView.image = image;
    
    [self reform_Image];
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
   
    fun = [[Recreation alloc] init];
    fun.i_comicCode = i_comicCode;
    base = fun.serverURL;
	
	[AppDelegate loadPage];
    i_pageNo = [pageNO copy];
	if ((i_pageNo == nil) || ([i_pageNo  isEqualToString:@"0"])) {
		i_pageNo = @"1";
	}
    i_sortCode = [sortCode copy];
    if ((i_sortCode == nil) || ([i_sortCode isEqualToString:@"0"])) {
        i_sortCode = @"15206";
    }
    i_comicCode = [comicCode copy];
    if ((i_comicCode == nil) || ([i_comicCode  isEqualToString:@"0"])) {
        i_comicCode = @"283";
    }
    
	kReceivedDataNotif = @"commited";
	NSLog(@"%@-%@-%@", i_pageNo, i_sortCode, i_comicCode);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];

	[self addObserver:self forKeyPath:kReceivedDataNotif options:NSKeyValueObservingOptionNew context:nil];
	
	pageNO = [NSString stringWithFormat:@"%@", i_pageNo];
	[AppDelegate loadPage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	[self link_Server];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self removeObserver:self forKeyPath:kReceivedDataNotif]; 
    
    pageNO = [i_pageNo copy];
    sortCode = [i_sortCode copy];
    comicCode = [i_comicCode copy];
    [AppDelegate savePage];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    //barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    barButtonItem.title = @"選 單";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
