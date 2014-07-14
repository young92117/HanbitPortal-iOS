//
//  SlideMenuViewController.m
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 3/1/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "SWRevealViewController.h"
#import "PageTableViewController.h"
#import "PageViewController.h"
#import "BibleViewController.h"

@interface SlideMenuViewController ()

@property (nonatomic, strong) NSArray   *menuItems;
@property (nonatomic, strong) NSArray   *slideMenuIdentifier;
@property (nonatomic, strong) NSArray   *slideMenuIcons;

@end

@implementation SlideMenuViewController

NSInteger slideMenuIndex[14] = {0, 2, 2, 2, 4,
                                2, 3, 3, 5, 3,
                                3, 3, 2, 2};

// dynamic information: 목회칼럼 (14), 교회소식/광고 (15), 설교동영상 (30), 설교나눔 (61), 말씀의 씨앗 (87)
// static  information: 교회소개 (201), 성경암송 (202), 소망의 씨앗 (203), 금주사역 (204)
//                      담임목사 소개 (301), 섬기는 이들 (302), 예배 안내 (304), 문화 학교 (305)
NSInteger slideMenuCategory[14] = { MENU_ID_NULL,
                                    MENU_ID_CHURCH_INTRO,
                                    MENU_ID_MAINPASTOR,
                                    MENU_ID_CHURCH_STAFF,
                                    MENU_ID_NULL,
    
                                    MENU_ID_WORSHIP_INFO,
                                    MENU_ID_SERMON_VIDEO,
                                    MENU_ID_SERMON_SHARE,
                                    MENU_ID_BIBLE_AMSONG,
                                    MENU_ID_SERMON_COLUMN,

                                    MENU_ID_BIBLE_SEED,
                                    MENU_ID_CHURCH_NEWS,
                                    MENU_ID_WEEKLY_ASSIGN,
                                    MENU_ID_CULTURE_SCHOOL};

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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    self.menuItems = @[@"Hanbit Church",
                       @"교회 소개",
                       @"인사말",
                       @"섬기는 이들",
                       @"오시는 길",
                       @"예배 안내",
                       @"설교 동영상",
                       @"설교 나눔",
                       @"성경 암송",
                       @"목회 칼럼",
                       @"말씀의 씨앗",
                       @"교회 소식",
                       @"금주 사역",
                       @"문화 학교"];
    
    self.slideMenuIdentifier = @[@"title",
                                 @"inlineHandler",
                                 @"viewHandler",
                                 @"tableHandler",
                                 @"mapHandler",
                                 @"bibleHandler"];
    
    self.slideMenuIcons = @[@"",
                            @"main_sdhanbit_icon.png",
                            @"main_pastor_icon.png",
                            @"main_staff_icon.png",
                            @"main_map_icon.png",
                            @"main_worship_icon.png",
                            @"main_sermon_icon.png",
                            @"main_share_icon.png",
                            @"main_recitation_icon.png",
                            @"main_ministry_icon.png",
                            @"main_words_icon.png",
                            @"main_news_icon.png",
                            @"main_actions_icon.png",
                            @"main_school_icon.png",];
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
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    NSString *imageName = nil;

    CellIdentifier = self.slideMenuIdentifier[slideMenuIndex[indexPath.row]];
    imageName = self.slideMenuIcons[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if( slideMenuIndex[indexPath.row] > 1 )
    {
        UIImageView *menuImageView = (UIImageView *)[cell viewWithTag:100];
        menuImageView.image = [UIImage imageNamed:imageName];
        
        UILabel *menuNameLabel = (UILabel *)[cell viewWithTag:101];
        menuNameLabel.text = self.menuItems[indexPath.row]; 
    }
    else if( slideMenuIndex[indexPath.row] == 0 )
    {
        UILabel *menuNameLabel = (UILabel *)[cell viewWithTag:101];
        menuNameLabel.text = @"하나님이 기뻐하시는 교회, 따뜻한 교회, 섬기는 교회";
    }
    else
    {
        UILabel *menuNameLabel = (UILabel *)[cell viewWithTag:200];
        menuNameLabel.text = self.menuItems[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( slideMenuIndex[indexPath.row] == 0 )
        return 60;
    else if( slideMenuIndex[indexPath.row] == 1 )
        return 24;
    else
        return 48;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[self.menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the category if it navigates the menu
    if( indexPath.row > 0 && [segue.identifier isEqualToString:@"showTableView"] )
    {
        PageTableViewController *tableViewController = (PageTableViewController*)segue.destinationViewController;
        tableViewController.category = slideMenuCategory[indexPath.row];
    }
    else if( [segue.identifier isEqualToString:@"showView"] )
    {
        PageViewController *viewController = (PageViewController*)segue.destinationViewController;
        viewController.category = slideMenuCategory[indexPath.row];
    }
    else if( [segue.identifier isEqualToString:@"showBible"] )
    {
        NSInteger thisWeekBiblePageIndex = [BibleViewController getThisWeekInfo];

        BibleViewController *bibleViewController = (BibleViewController*)segue.destinationViewController;
        bibleViewController.category = slideMenuCategory[indexPath.row];
        bibleViewController.biblePageIndex = thisWeekBiblePageIndex;
        bibleViewController.pageMode = 0;
    }
    else if( [segue.identifier isEqualToString:@"showMap"] )
    {
    
    }
    
    if( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
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
