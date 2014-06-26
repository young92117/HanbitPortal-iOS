//
//  PageViewController.m
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 3/2/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import "PageViewController.h"
#import "SWRevealViewController.h"
#import "SlideMenuViewController.h"

@interface PageViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIWebView *viewControl;

@end

@implementation PageViewController

NSString *backImageList[5] = {@"bird.jpg", @"yellowtree2.jpg", @"cross.jpg", @"getty.jpg", @"brightsky.jpg"};

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
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    //[_viewControl addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //[_viewControl addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    if (_category == MENU_ID_CHURCH_INTRO) // 교회 소개
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body bgcolor=#CEF6F5 style=\"font-family:arial;color:black;font-size:15px;margin:10px\"> \
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
                          
        [_viewControl loadHTMLString:html baseURL:baseURL];
    }
    else if (_category == MENU_ID_WEEKLY_ASSIGN) // 금주 사역
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body><iframe src=\"https://docs.google.com/spreadsheet/pub?key=0Ahw6lNCJGfZ6dDNJcm9IT0lqVWVZNU5Zc3B0ZklfSGc&#038;output=html\" width=\"100%%\" scrolling=\"no\" class=\"iframe-class\" frameborder=\"0\"></iframe></body></html>"];
        
        _viewControl.scalesPageToFit = YES;
        [_viewControl loadHTMLString:html baseURL:nil];
    }
    else if (_category == MENU_ID_MAINPASTOR) // 담임목사 소개
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body bgcolor=#E0F8F7 style=\"font-family:arial;color:black;font-size:15px;margin:10px\"> \
                          <h3>정수일 목사</h3> \
                          <img src=\"Hanbit_PastorMain_400x600.jpg\" height=\"60%%\"> \
                          <blockquote>담임목사<br>가족: 정경자, 다연, 윤홍<br> \
                          <a href=\"scheong2@hotmail.com\">scheong2@hotmail.com</a> \
                          </body></html>"];
    
        [_viewControl loadHTMLString:html baseURL:baseURL];
    }
    else if (_category == MENU_ID_CHURCH_STAFF) // 섬기는 이들
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body bgcolor=#E0F8F7 style=\"font-family:arial;color:black;font-size:15px;margin:10px\"> \
                          <h3>김용환 목사</h3> \
                          <img src=\"Hanbit_KimYH.jpg\"> \
                          <blockquote>예배/청년부/성인교육<br>가족: 황혜정, 호중, 윤중<br> \
                          <a href=\"mailto:ydcfkim@hotmail.com\">ydcfkim@hotmail.com</a></blockquote> \
                          <h3>문인권 목사</h3> \
                          <img src=\"Hanbit_MoonIK.jpg\"> \
                          <blockquote>선교/대학부<br>가족: 양연주, 희연, 희민<br> \
                          <a href=\"joey.moons@gmail.com\">joey.moons@gmail.com</a></blockquote> \
                          <h3>임제성 목사</h3> \
                          <img src=\"Hanbit_LimYS.png\"> \
                          <blockquote>찬양/예배부<br>가족: 서윤주, 준혁, 주은<br> \
                          <a href=\"ljs7004@hotmai.com\">ljs7004@hotmai.com</a></blockquote> \
                          <h3>신인호 목사</h3> \
                          <img src=\"Hanbit_Shin.png\"> \
                          <blockquote>가족: 박선아, 신율<br> \
                          <a href=\"nationshin@gmail.com\">nationshin@gmail.com</a></blockquote> \
                          <h3>윤홍순 전도사</h3> \
                          <img src=\"Hanbit_YoonHS.jpg\"> \
                          <blockquote>목양/목장<br>가족: 윤창호, 재성, 혜인<br> \
                          <a href=\"sunk75@gmail.com\">sunk75@gmail.com</a></blockquote> \
                          <h3>한주리 전도사</h3> \
                          <img src=\"Hanbit_HanJL.jpg\"> \
                          <blockquote>유치부/아기학교<br>가족: 이우람<br> \
                          <a href=\"han_princess@hotmail.com\">han_princess@hotmail.com</a></blockquote> \
                          <h3>임강영 전도사</h3> \
                          <img src=\"Hanbit_ImKY.jpg\"> \
                          <blockquote>고등부<br>가족: 이한빛, 임 준<br> \
                          <a href=\"alabheng@msn.com\">alabheng@msn.com</a></blockquote> \
                          <h3>홍영락 전도사</h3> \
                          <img src=\"Hanbit_HongSteve.jpg\"> \
                          <blockquote>중등부/천사부<br> \
                          <a href=\"davyhong07@gmail.com\">davyhong07@gmail.com</a></blockquote> \
                          <h3>김동률 전도사</h3> \
                          <img src=\"Hanbit_KimDR.jpg\"> \
                          <blockquote>유년부<br> \
                          <br></blockquote> \
                          <h3>조원화 전도사</h3> \
                          <img src=\"Hanbit_ChoYH.jpg\"> \
                          <blockquote>유아부<br> \
                          <br></blockquote> \
                          </body></html>"];
        
        [_viewControl loadHTMLString:html baseURL:baseURL];
    }
    else if (_category == MENU_ID_WORSHIP_INFO) // 예배 안내
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body background=\"%@\"> \
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
                          </table></body></html>",
                          backImageList[2] ];
        
        [_viewControl loadHTMLString:html baseURL:baseURL];
    }
    else if (_category == MENU_ID_CULTURE_SCHOOL) // 문화 학교
    {
        NSURL *url = [NSURL URLWithString:@"http://www.sdhanbit.org/wordpress/wp-content/uploads/2014/01/HANBIT-_-SPRING-EDU-779x1024.jpg"];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        _viewControl.scalesPageToFit = YES;
        [_viewControl loadRequest:requestObj];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//You should enable simultaneous gesture recognition
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

@end
