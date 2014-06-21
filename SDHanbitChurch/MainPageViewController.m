//
//  MainPageViewController.m
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 3/1/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import "MainPageViewController.h"
#import "SWRevealViewController.h"
#import "PageTableViewController.h"
#import "PageViewController.h"
#import "HanbitManager.h"
#import "HanbitCommunicator.h"
#import "DBManager.h"
#import "SlideMenuViewController.h"
#import "BibleViewController.h"

@interface MainPageViewController () <HanbitManagerDelegate> {
    NSArray *_groups;
    HanbitManager *_manager;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)mainButton01:(id)sender;
- (IBAction)mainButton02:(id)sender;
- (IBAction)mainButton03:(id)sender;
- (IBAction)mainButton04:(id)sender;
- (IBAction)mainButton05:(id)sender;
- (IBAction)mainButton06:(id)sender;
- (IBAction)mainButton07:(id)sender;
- (IBAction)mainButton08:(id)sender;
- (IBAction)mainButton09:(id)sender;
- (IBAction)manualRequest:(id)sender;

@end

@implementation MainPageViewController

// 목회칼럼 (14), 교회소식/광고 (15), 설교동영상 (30), 설교나눔 (61), 말씀의 씨앗 (87)
NSInteger tableCategory[5] = {MENU_ID_SERMON_COLUMN,
                              MENU_ID_CHURCH_NEWS,
                              MENU_ID_SERMON_VIDEO,
                              MENU_ID_SERMON_SHARE,
                              MENU_ID_BIBLE_SEED};

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *titleString;
    switch (_selectedCategory)
    {
        case MENU_ID_SERMON_COLUMN:
            titleString = @"목회 칼럼";
            break;
        case MENU_ID_CHURCH_NEWS:
            titleString = @"교회 소식";
            break;
        case MENU_ID_SERMON_VIDEO:
            titleString = @"설교 동영상";
            break;
        case MENU_ID_SERMON_SHARE:
            titleString = @"설교 나눔";
            break;
        case MENU_ID_BIBLE_SEED:
            titleString = @"말씀의 씨앗";
            break;
        case MENU_ID_CHURCH_INTRO:
            titleString = @"교회 소개";
            break;
        case MENU_ID_BIBLE_AMSONG:
            titleString = @"성경 암송";
            break;
        case MENU_ID_HOPE_SEED:
            titleString = @"소망의 씨앗";
            break;
        case MENU_ID_WEEKLY_ASSIGN:
            titleString = @"금주 사역";
            break;
        case MENU_ID_CULTURE_SCHOOL:
            titleString = @"문화 학교";
            break;
        default:
            NSLog(@"undefinded category");
            break;
    }
    
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [titleString capitalizedString];
    
    if (_selectedCategory == MENU_ID_CHURCH_INTRO || _selectedCategory == MENU_ID_WEEKLY_ASSIGN)
    {
        PageViewController *pageViewController = (PageViewController *)segue.destinationViewController;
        pageViewController.category = _selectedCategory;
    }
    else if (_selectedCategory == MENU_ID_BIBLE_AMSONG)
    {
        NSInteger thisWeekBiblePageIndex = [BibleViewController getThisWeekInfo];

        BibleViewController *bibleViewController = (BibleViewController *)segue.destinationViewController;
        bibleViewController.category = _selectedCategory;
        bibleViewController.biblePageIndex = thisWeekBiblePageIndex;
        bibleViewController.pageMode = 0;
    }
    else
    {
        PageTableViewController *pageTableController = (PageTableViewController *)segue.destinationViewController;
        pageTableController.category = _selectedCategory;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"샌디에고 한빛교회";
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    _manager = [[HanbitManager alloc] init];
    _manager.communicator = [[HanbitCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    // get the current date and time info
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMddHHmm"];
    
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:now];
    long long dateStringInt = [dateString longLongValue];
    
    // read the database to get the latest updated date for each category
    [DBManager prepareDatabase];
    //[DBManager deleteAllItems];
    
    NSLog( @"[database] total:%ld, cat14:%ld, cat15:%ld, cat30:%ld, cat61:%ld, cat87:%ld",
          (long)[DBManager numberOfTotalItems],
          (long)[DBManager numberOfItemsAtCategory:MENU_ID_SERMON_COLUMN],
          (long)[DBManager numberOfItemsAtCategory:MENU_ID_CHURCH_NEWS],
          (long)[DBManager numberOfItemsAtCategory:MENU_ID_SERMON_VIDEO],
          (long)[DBManager numberOfItemsAtCategory:MENU_ID_SERMON_SHARE],
          (long)[DBManager numberOfItemsAtCategory:MENU_ID_BIBLE_SEED]);

    for (int i=0; i<5; i++)
    {
        NSInteger category = tableCategory[i];
        
        NSString *latestRequestDate = [DBManager getLatestRequestDate:category];
        if (latestRequestDate == nil)
        {
            latestRequestDate = @"201401010000";
            
            [DBManager addItemsToDatabase:category
                                 Category:9999
                               UpdateDate:latestRequestDate
                                    Title:@"N/A" PubDate:@"N/A" permLink:@"N/A" Content:@"NA"];
        }
        NSLog(@"cat:%ld, latestRequestDate:%@", (long)category, latestRequestDate);
        
        // access the web server when last update is more than an hour ago
        long long latestRequestInt = [latestRequestDate longLongValue];
        if (dateStringInt - latestRequestInt > 100)
        {
            [DBManager updateLatestRequestDate:category NewRequestDate:dateString];
            
            NSString *latestPubDate = [DBManager getLatestPubDate:category];
            if (latestPubDate == nil)
                latestPubDate = @"201401010000";

            [_manager fetchGroupsAtHanbit:category After:latestPubDate];
        }
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(startFetchingGroups:)
//                                                 name:@"HanbitDataReceived"
//                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 목회칼럼 (14), 교회소식/광고 (15), 설교동영상 (30), 설교나눔 (61), 말씀의 씨앗 (87)
// 교회소개 (201), 성경암송 (202), 소망의 씨앗 (203), 금주사역 (204)
- (IBAction)mainButton01:(id)sender
{
    _selectedCategory = MENU_ID_CHURCH_INTRO;
}

- (IBAction)mainButton02:(id)sender
{
    _selectedCategory = MENU_ID_SERMON_VIDEO;
}

- (IBAction)mainButton03:(id)sender
{
    _selectedCategory = MENU_ID_SERMON_SHARE;
}

- (IBAction)mainButton04:(id)sender
{
    _selectedCategory = MENU_ID_SERMON_COLUMN;
}

- (IBAction)mainButton05:(id)sender
{
    _selectedCategory = MENU_ID_BIBLE_SEED;
}

- (IBAction)mainButton06:(id)sender
{
    _selectedCategory = MENU_ID_BIBLE_AMSONG;
}

- (IBAction)mainButton07:(id)sender
{
    _selectedCategory = MENU_ID_CHURCH_NEWS;
}

- (IBAction)mainButton08:(id)sender
{
    _selectedCategory = MENU_ID_CULTURE_SCHOOL;
}

- (IBAction)mainButton09:(id)sender
{
    _selectedCategory = MENU_ID_WEEKLY_ASSIGN;
}

- (IBAction)manualRequest:(id)sender
{
    for (int i=0; i<5; i++)
    {
        NSInteger category = tableCategory[i];
    
        NSString *latestPubDate = [DBManager getLatestPubDate:category];
        if (latestPubDate == nil)
            latestPubDate = @"201401010000";
    
        [_manager fetchGroupsAtHanbit:category After:latestPubDate];
    }
}

#pragma mark - Notification Observer
- (void)startFetchingGroups:(NSInteger)category From:(NSString *)date //(NSNotification *)notification
{
    [_manager fetchGroupsAtHanbit:category After:date];
}

#pragma mark - MeetupManagerDelegate
- (void)didReceiveGroups:(NSArray *)groups
{
    _groups = groups;

    NSLog(@"finally got the info from the delegate\n");
    // update Badge information at Main View
    //[self.tableView reloadData];
}

- (void)fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

@end
