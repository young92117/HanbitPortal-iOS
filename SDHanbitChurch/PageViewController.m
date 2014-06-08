//
//  PageViewController.m
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 3/2/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import "PageViewController.h"
#import "SWRevealViewController.h"
#import "BibleContextsTable.h"

@interface PageViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIWebView *viewControl;

@end

@implementation PageViewController

NSInteger base2014ChVerse = 12*3 + 4; // based on 1st week of 2014
NSInteger thisWeekCh;
NSInteger thisWeekVerse;
NSInteger thisWeekDay;
NSInteger thisTimeHour;
NSString *backImageList[5] = {@"bird.jpg", @"yellowtree2.jpg", @"cross.jpg", @"getty.jpg", @"brightsky.jpg"};

- (void) getThisWeekInfo
{
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger thisWeekOfYear = [[calender components: NSWeekOfYearCalendarUnit fromDate:now] weekOfYear] - 1;
    thisWeekDay = [[calender components: NSWeekdayCalendarUnit fromDate:now] weekday];
    thisTimeHour = [[calender components: NSHourCalendarUnit fromDate:now] hour];
    
    if( thisWeekOfYear != 0 && thisWeekDay == 1 && thisTimeHour < 12) // sunday morning, still need to display the previous week
        thisWeekOfYear = thisWeekOfYear - 1;
    
    thisWeekCh = ((base2014ChVerse + thisWeekOfYear) / 12) % 5;
    thisWeekVerse = (base2014ChVerse + thisWeekOfYear) % 12;
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
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    if (_category == 201) // 교회 소개
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body bgcolor=#FBEFF2 style=\"font-family:arial;color:black;font-size:15px;margin:10px\"> \
                          <h3>교회 비전</h3> \
                          <blockquote><p>하나님이 기뻐하시는 교회, 따뜻한 교회, 섬기는 교회</p></blockquote> \
                          <h3>우리의 사명</h3> \
                          <blockquote><p>하나님의 잃어버린 영혼을 찾아 예수 그리스도의 가정 공동체를 이루는 것이다</p></blockquote> \
                          <h3>주제 성구</h3> \
                          <blockquote><p>예베소서 4:13-16</p> \
                          <p>우리가 다 하나님의 아들을 믿는 것과 아는 일에 하나가 되어 온전한 사람을 이루어 그리스도의 장성한 분량이 충만한 데까지 이르리니 이는 우리가 이제부터 어린아이가 되지 아니하여 사람의 궤술과 간사한 유혹에 빠져 모든 교훈의 풍조에 밀려 요동치 않게 하려 함이라 오직 사랑 안에서 참된 것을 하여 범사에 그에게까지 자랄찌라 그는 머리니 곧 그리스도라 그에게서 온 몸이 각 마디를 통하여 도움을 입음으로 연락하고 상합하여 각 지체의 분량대로 역사하여 그 몸을 자라게 하며 사랑 안에서 스스로 세우느니라</p> \
                          <p>Ephesians 4:13-16</p> \
                          <p>Until we all reach unity in the faith and in the knowledge of the Son of God and become mature, attaining to the whole measure of the fullness of Christ. Then we will no longer be infants, tossed back and forth by the waves, and blown here and there by every wind of teaching and by the cunning and craftiness of men in their deceitful scheming. Instead, speaking the truth in love, we will in all things grow up into him who is the Head, that is Christ. From him the whole body, joined and held together by every supporting ligament, grows and builds itself up in love, as each part does its work.</p></blockquote> \
                          <h3>주제 찬송</h3> \
                          <blockquote><p>찬송가 246장 (내 주의 나라와 / I love The Kingdom, Lord)</p></blockquote> \
                          <h3>하나님이 기뻐하시는 교회</h3> \
                          <blockquote><p>교회의 주인 되신 예수 그리스도의 말씀에 온전히 순종하고, 그 분만을 높이어 하나님께서 기뻐하시며, 하나님으로 충만한 교회를 목적한다. 기대감과 설레임의 예배 훈련으로 성장하는 제자 말씀에 지배받는 목회</p></blockquote> \
                          <h3>따뜻한 교회</h3> \
                          <blockquote><p>자신의 생명을 주심으로 우리를 사랑하신 예수님의 사랑으로 한 몸을 이룬 사랑이 넘치는 따뜻한 가족 공동체를 목적한다. 가정을 풍요롭게 하는 사역 가정같은 공동체 형성 치유함이 있는 성도의 교제</p></blockquote> \
                          <h3>섬기는 교회</h3> \
                          <blockquote><p>하나님의 명령에 따라 하나님 나라의 확장을 위하여 세상을 그리스도의 복음으로 변화시키는 섬기는 공동체가 됨을 목적한다.<br> \
                          가정교회를 통한 섬김의 실천 이웃을 돌아보는 커뮤니티 사역 학원과 해외선교의 사명 실천</p></blockquote> \
                          <p>&nbsp;</p></body></html>"];
                          
        [_viewControl loadHTMLString:html baseURL:nil];
    }
    else if (_category == 202) // 성경 암송
    {
        [self getThisWeekInfo];
        
        // background
        //NSInteger bibleIndex = (thisWeekCh*12 + thisWeekVerse) % 5;
        
        //UIGraphicsBeginImageContext(self.view.frame.size);
        //[[UIImage imageNamed:backImageList[bibleIndex]] drawInRect:self.view.bounds];
        //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //UIGraphicsEndImageContext();
        
        //self.view.backgroundColor = [UIColor colorWithPatternImage:image];

        // this week's bible verse
        NSString *html = [NSString stringWithFormat:
                          @"<html><body bgcolor=#B0E0E6 style=\"margin:15px\"><P><big>%@</big></P>%@<br><br>  \
                          <P><big>%@</big></P>%@<br></body></html>",
                          korTitleString[thisWeekCh][thisWeekVerse],
                          korTextString[thisWeekCh][thisWeekVerse],
                          engTitleString[thisWeekCh][thisWeekVerse],
                          engTextString[thisWeekCh][thisWeekVerse]];
        
        [_viewControl loadHTMLString:html baseURL:nil];
    }
    else if (_category == 204) // 금주 사역
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body><iframe src=\"https://docs.google.com/spreadsheet/pub?key=0Ahw6lNCJGfZ6dDNJcm9IT0lqVWVZNU5Zc3B0ZklfSGc&#038;output=html\" width=\"100%%\" scrolling=\"no\" class=\"iframe-class\" frameborder=\"0\"></iframe></body></html>"];
        
        [_viewControl loadHTMLString:html baseURL:nil];
    }
    else if (_category == 304) // 예배 안내
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body> \
                          <p><strong>주일 예배 시간</strong></p> \
                          <table border=1 frame=hsides rules=rows cellpadding=4 style=\"font-family:arial;color:black;font-size:12px;\"> \
                          <tr><td valign=top width=140>성인부 예배</td> \
                          <td>1부 오전 7시30분<br>2부 오전 9시 (동시통역)<br>3부 오전 11시 (동시통역)<br>4부 오후 1시15분 (동시통역) 청년, 대학부<br></tr> \
                          <tr><td valign=top width=140>영아부 예배 &#8211; 1세 이하</td><td>오전 9시<br>오전 11시</td></tr> \
                          <tr><td valign=top width=140>유아부 예배 &#8211; 2세 이하</td><td>오전 9시<br>오전 11시</td></tr> \
                          <tr><td valign=top width=140>유치부 예배 &#8211; 3~4세 이하</td><td>오전 9시<br>오전 11시</td></tr> \
                          <tr><td valign=top width=140>유년부 예배 &#8211; K~2학년</td><td>오전 9시<br>오전 11시</td></tr> \
                          <tr><td valign=top width=140>초등부 예배 &#8211; 3~5학년</td><td>오전 9시<br>오전 11시</td></tr> \
                          <tr><td valign=top width=140>중등부 예배</td><td>오전 9시</td></tr> \
                          <tr><td valign=top width=140>고등부 예배</td><td>오전 9시</td></tr> \
                          <tr><td valign=top width=140>천사부 예배</td><td>오전 9시</td></tr> \
                          </table> \
                          <p><strong>기타 모임 시간</strong></p> \
                          <table border=1 frame=hsides rules=rows cellpadding=4 style=\"font-family:arial;color:black;font-size:12px;\"> \
                          <tr><td width=80>목장 모임</td><td>(금) 오후 7시</td></tr> \
                          <tr><td width=80>대학부 모임</td><td>(금) 오후 6시</td></tr> \
                          <tr><td width=80>청년부 모임</td><td>(금) 오후 7시30분, (주) 오후 3시30분</td></tr> \
                          <tr><td width=80>새벽 기도회</td><td>(화)-(금) 오전 5시30분, (토) 오전 6시</td></tr> \
                          <tr><td width=80>수요 기도회</td><td>(수) 오후 8시</td></tr> \
                          <tr><td width=80>시니어부</td><td>(주) 2부 예배후</td></tr> \
                          </table></body></html>"];
        
        [_viewControl loadHTMLString:html baseURL:nil];
    }
    else if (_category == 305) // 문화 학교
    {
        NSURL *url = [NSURL URLWithString:@"http://www.sdhanbit.org/wordpress/wp-content/uploads/2013/09/"]; //2013년-가을-학기-한빛-문화-학교-강좌.jpg"];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [_viewControl loadRequest:requestObj];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
