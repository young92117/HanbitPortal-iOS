//
//  PageTableViewController.m
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 3/2/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import "PageTableViewController.h"
#import "SWRevealViewController.h"
#import "ItemViewController.h"
#import "DBManager.h"
#import "SlideMenuViewController.h"

@interface PageTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation PageTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ItemViewController *itemViewController = (ItemViewController *)segue.destinationViewController;
    itemViewController.category = _category;
    itemViewController.index    = [self.tableView indexPathForSelectedRow].row;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [DBManager numberOfItemsAtCategory:_category];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_category == MENU_ID_SERMON_VIDEO)
        return 88;
    else if(_category == MENU_ID_BIBLE_SEED)
        return 62;
    else
        return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    
    // dynamic information: 목회칼럼 (14), 교회소식/광고 (15), 설교동영상 (30), 설교나눔 (61), 말씀의 씨앗 (87)
    // static  information: 교회소개 (201), 성경암송 (202), 소망의 씨앗 (203), 금주사역 (204)
   switch (_category)
    {
        case MENU_ID_SERMON_COLUMN:
        case MENU_ID_CHURCH_NEWS:
        case MENU_ID_SERMON_SHARE:
            CellIdentifier = @"titleOnlyCell";
            break;
        case MENU_ID_SERMON_VIDEO:
            CellIdentifier = @"sermonCell";
            break;
        case MENU_ID_BIBLE_SEED:
            CellIdentifier = @"titleDateCell";
            break;
        default:
            NSLog(@"undefinded category");
            break;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *listOfItems = [DBManager getItemDetailInfo:_category Index:indexPath.row];
    
    if (cell == nil || listOfItems == nil)
        return cell;
    
    DBManager *data = [listOfItems objectAtIndex:0];
    
    UILabel *tableLabelTitle = (UILabel *)[cell viewWithTag:100];
    [tableLabelTitle setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16]];
    tableLabelTitle.text = data->_title;

    if (_category == MENU_ID_SERMON_VIDEO || _category == MENU_ID_BIBLE_SEED)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        NSDate *pubDate = [dateFormatter dateFromString:data->_pubdate];
        NSCalendar *calender = [NSCalendar currentCalendar];
        NSInteger thisWeekDay = [[calender components: NSWeekdayCalendarUnit fromDate:pubDate] weekday];
        
        NSRange strYearRange = {0,4}, strMonthRange = {4,2}, strDayRange = {6,2};
        NSInteger day = [data->_pubdate substringWithRange:strDayRange].intValue;
        if (_category == MENU_ID_SERMON_VIDEO)
            day = day - thisWeekDay + 1;
        
        UILabel *tableLabelDate = (UILabel *)[cell viewWithTag:101];
        [tableLabelDate setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:13]];
        tableLabelDate.text = [NSString stringWithFormat:@"%@-%@-%02ld",
                               [data->_pubdate substringWithRange:strYearRange],
                               [data->_pubdate substringWithRange:strMonthRange],
                               (long)day];
    }
    
    if (_category == MENU_ID_SERMON_VIDEO)
    {
        UIWebView *videoView = (UIWebView *)[cell viewWithTag:102];
        videoView.scrollView.scrollEnabled = NO;
        videoView.scrollView.bounces = NO;
        NSString *youtubeId = [self extractYoutubeID:data->_content];
        if (youtubeId != nil)
        {
            NSString *embedCode = [NSString stringWithFormat:@"<iframe width=\"144\" height=\"80\" src=\"http://www.youtube.com/embed/%@?modestbranding=1&autohide=1&showinfo=0&controls=0\" frameborder=\"0\" allowfullscreen></iframe>", youtubeId];
            [videoView loadHTMLString:embedCode baseURL:nil];
        }
    }
    
    return cell;
}

- (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    NSError *error = NULL;
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL
                                                         options:0
                                                           range:NSMakeRange(0, [youtubeURL length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        return substringForFirstMatch;
    }
    
    return nil;
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
