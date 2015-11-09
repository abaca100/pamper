//
//  MasterViewController.m
//  Comic
//
//  Created by Jack Lee on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"


@interface MasterViewController ()
@property (strong, nonatomic) UIPopoverController *menu;
- (void)configureView;
@end


@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize menu;

- (void)configureView {

}

- (void)initialize
{
    division = [[NSMutableArray alloc] initWithCapacity:1];
    [division addObject:@"漫晝"];
    
    spots = [[NSMutableArray alloc] initWithCapacity:5];
    [spots addObject:@"死神"];
    [spots addObject:@"東方真龍"];
    [spots addObject:@"妖精的尾巴"];
    [spots addObject:@"獵人"];
    [spots addObject:@"JoJo"];
    [spots addObject:@"四大名捕"];
    [spots addObject:@"七原罪"];

    scene = [[NSMutableArray alloc] init];
    scape = [[NSMutableDictionary alloc] init];
    [scape setObject:@"6"    forKey:[spots objectAtIndex:0]];
    [scape setObject:@"2027"    forKey:[spots objectAtIndex:1]];
    [scape setObject:@"346"  forKey:[spots objectAtIndex:2]];
    [scape setObject:@"146"  forKey:[spots objectAtIndex:3]];
    [scape setObject:@"1312" forKey:[spots objectAtIndex:4]];
    [scape setObject:@"283"  forKey:[spots objectAtIndex:5]];
    [scape setObject:@"1733" forKey:[spots objectAtIndex:6]];
}

- (void)make_list:(NSString *)target
{
    //NSString *str = @"http://comic.kukudm.com/comiclist/6/index.htm";
    NSString *str;
    str = [NSString stringWithFormat:@"http://comic.kukudm.com/comiclist/%@/index.htm", target];
//    if ([target isEqualToString:@"6"]) {
//        str = @"http://hot.socomic.com/sishen.htm";
//    } else if ([target isEqualToString:@"3"]) {
//        str = @"http://hot.socomic.com/huoying.htm";
//    } else {
//        str = [NSString stringWithFormat:@"http://comic.kukudm.com/comiclist/%@/index.htm", target];
//    }
    //NSLog(@"%@", str);
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* newStr = [[NSString alloc] initWithData:data encoding:enc];
    
    NSLog(@"%@", newStr);
    NSString *key;
    if ([target isEqualToString:@"6"]) {
        key = @"<div id=\"oDIV5\"> <ol>";
    } else if ([target isEqualToString:@"3"]) {
        key = @"<div id=\"oDIV5\"> <ol>";
    } else {
        key = @"<dl id='comiclistn'> <dd>";
    }
    NSString *text = nil;
    NSScanner *theScanner = [NSScanner scannerWithString:newStr];
    [theScanner scanUpToString:key intoString:NULL] ; 
    [theScanner scanUpToString:@"</dd></dl>" intoString:&text];
    
    theComics = [[NSMutableDictionary alloc] init];
    theData  = [[NSMutableArray alloc] init];    
    key = @"href='";
    NSArray *array = [text componentsSeparatedByString:@"<dd><A"];
    
    for (int x=0; x<[array count]; x++) {
        text = nil;
        newStr = [array objectAtIndex:x];
        NSLog(@"");
        NSLog(@"");
        NSLog(@"");
        NSLog(@"newStr=%@", newStr);
        theScanner = [NSScanner scannerWithString:newStr];
        [theScanner scanUpToString:key intoString:NULL] ; 
        [theScanner scanUpToString:@"</A>" intoString:&text];
        
        if ([text length] > 0) {
            NSString *str = nil;
            NSString *ss = nil;
            NSScanner *scan = [NSScanner scannerWithString:text];
            [scan scanUpToString:@"'>" intoString:&str] ; 
            text = [text stringByReplacingOccurrencesOfString:str withString:@""];
            NSLog(@"%@", str);
            
            ss = [str stringByReplacingOccurrencesOfString:@"href='/comiclist/" withString:@""];
            ss = [ss stringByReplacingOccurrencesOfString:@".htm' target='_blank" withString:@""];
            NSLog(@"%@", ss);
            
            text = [text stringByReplacingOccurrencesOfString:@"'>" withString:@""];
            [theData addObject:text];
            NSLog(@"%@", text);
            
            [theComics setObject:ss forKey:text];
        }
    }
}

- (void)fetchDB_Info:(int)param1 second:(int)param2
{
    if (param1==0) {
        
        NSString *ss = [scape objectForKey:[spots objectAtIndex:[picker selectedRowInComponent:1]]];
        self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", 
                                     [division objectAtIndex:[picker selectedRowInComponent:0]],
                                     [spots objectAtIndex:[picker selectedRowInComponent:1]]];
        
        NSLog(@"ss=%@", ss);
        [self make_list:ss];
    }
}

- (IBAction)choosePressed:(id)sender 
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"選擇類型"
                                                             delegate:self 
                                                    cancelButtonTitle:@"取消" 
                                               destructiveButtonTitle:@"Okay" 
                                                    otherButtonTitles:@"", @"", @"", @"確定", nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    picker.showsSelectionIndicator = YES;
    [actionSheet addSubview:picker];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic; 
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    //[actionSheet setBounds:CGRectMake(0, 0, 400, 400)];
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 500.0);
    [super awakeFromNib];
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
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    //[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    //[self initialize];
    //picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 36, 320, 210)];
    picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    [self initialize];

    [self make_list:@"1733"];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [theData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
	cell.textLabel.text = [theData objectAtIndex:indexPath.row];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    self.detailViewController.title = [theData objectAtIndex:indexPath.row];
 
    NSString *str = [theComics objectForKey:[theData objectAtIndex:indexPath.row]];
    NSLog(@"%@", str);
    NSArray *array = [str componentsSeparatedByString:@"/"];
    
    if ([[str substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"href"]) {
        str = [str substringFromIndex:38];
        NSLog(@"%@", str);
        array = [str componentsSeparatedByString:@"/"];
    }
    
    self.detailViewController.i_comicCode = [array objectAtIndex:0];
    self.detailViewController.i_sortCode = [array objectAtIndex:1];
    self.detailViewController.i_pageNo = [array objectAtIndex:2];
    [self.detailViewController link_Server];

    //[self dismissPopoverAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - UIPickerViewDelegate

// 資料源與 UIPickerView 在這個 function combine
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component==0) {
        return [division objectAtIndex:row];
    }
    
    return [spots objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if (component==0) {
		return 100;		
	} else {
		return 200;
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
	if (component == 0) {
		return [division count];
	}
    
	return [spots count];
}


#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex=%d", buttonIndex);
    if (buttonIndex==4) {
        
        NSInteger param1 = [picker selectedRowInComponent:0];
        NSInteger param2 = [picker selectedRowInComponent:1];
        
        [self fetchDB_Info:param1 second:param2];
        
        [self.tableView reloadData];
    }
}

@end
