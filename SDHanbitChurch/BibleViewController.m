//
//  BibleViewController.m
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 6/13/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import "BibleViewController.h"
#import "SWRevealViewController.h"
#import "SlideMenuViewController.h"
#import "BibleContextsTable.h"

@interface BibleViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIWebView *viewControl;
- (IBAction)prevPage:(id)sender;
- (IBAction)nextPage:(id)sender;
- (IBAction)hintToggle:(id)sender;

@end

@implementation BibleViewController

#define MAX_BIBLE_PAGE 60

NSInteger base2014ChVerse = 12*3 + 4; // based on 1st week of 2014
NSString *backBibleImageList[5] = {@"bird.jpg", @"yellowtree2.jpg", @"cross.jpg", @"getty.jpg", @"brightsky.jpg"};

+ (NSInteger) getThisWeekInfo
{
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger thisWeekOfYear = [[calender components: NSWeekOfYearCalendarUnit fromDate:now] weekOfYear] - 1;
    NSInteger thisWeekDay = [[calender components: NSWeekdayCalendarUnit fromDate:now] weekday];
    NSInteger thisTimeHour = [[calender components: NSHourCalendarUnit fromDate:now] hour];
    NSInteger thisWeekBiblePageIndex;
    
    if( thisWeekOfYear != 0 && thisWeekDay == 1 && thisTimeHour < 12) // sunday morning, still need to display the previous week
        thisWeekOfYear = thisWeekOfYear - 1;
    
    thisWeekBiblePageIndex = (base2014ChVerse + thisWeekOfYear) % 60;
    
    return thisWeekBiblePageIndex;
}

- (void) displayBibleVerse
{
    NSInteger bibleIndex = _biblePageIndex % 5;
    NSInteger thisWeekCh = _biblePageIndex / 12;
    NSInteger thisWeekVerse = _biblePageIndex % 12;

    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *korText, *engText;
    
    switch (_pageMode)
    {
        case 0:
            korText = korTextString[thisWeekCh][thisWeekVerse];
            engText = engTextString[thisWeekCh][thisWeekVerse];
            break;
        case 1:
            korText = korHintTextString[thisWeekCh][thisWeekVerse];
            engText = engHintTextString[thisWeekCh][thisWeekVerse];
            break;
        case 2:
            korText = korHideTextString[thisWeekCh][thisWeekVerse];
            engText = engHideTextString[thisWeekCh][thisWeekVerse];
            break;
    }

    // this week's bible verse
    NSString *html = [NSString stringWithFormat:
                      @"<html><body background=\"%@\" style=\"margin:15px\"><P><big>%@</big></P>%@<br><br> \
                      <P><big>%@</big></P>%@<br></body></html>",
                      backBibleImageList[bibleIndex],
                      korTitleString[thisWeekCh][thisWeekVerse], korText,
                      engTitleString[thisWeekCh][thisWeekVerse], engText];

    [_viewControl loadHTMLString:html baseURL:baseURL];
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
    // Do any additional setup after loading the view.
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    if (_category == MENU_ID_BIBLE_AMSONG) // 성경 암송
    {
        [self displayBibleVerse];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)prevPage:(id)sender
{
    _pageMode = 0;
    if (_biblePageIndex != 0 )
        _biblePageIndex--;

    [self displayBibleVerse];
}

- (IBAction)nextPage:(id)sender
{
    _pageMode = 0;
    if (_biblePageIndex < MAX_BIBLE_PAGE-1 )
        _biblePageIndex++;

    [self displayBibleVerse];
}

- (IBAction)hintToggle:(id)sender
{
    _pageMode++;
    if (_pageMode == 3)
        _pageMode = 0;
    
    [self displayBibleVerse];
}
@end
