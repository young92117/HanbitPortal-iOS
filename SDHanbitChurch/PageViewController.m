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
                          @"<html><body style=\"margin:0\"><img src=hanbit_overview.png width=\"%d\"></body></html>",
                          (int)self.view.frame.size.width];
                          
        [_viewControl loadHTMLString:html baseURL:baseURL];
    }
    else if (_category == MENU_ID_WEEKLY_ASSIGN) // 금주 사역
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><body><iframe src=\"https://docs.google.com/spreadsheet/pub?key=0Ahw6lNCJGfZ6dDNJcm9IT0lqVWVZNU5Zc3B0ZklfSGc&#038;output=html\" width=\"100%%\" scrolling=\"no\" class=\"iframe-class\" frameborder=\"0\"></iframe></body></html>"];
        
        _viewControl.scalesPageToFit = YES;
        [_viewControl loadHTMLString:html baseURL:nil];
    }
    else if (_category == MENU_ID_MAINPASTOR) // 인사말
    {
        //NSLog(@"width=%f", self.view.frame.size.width);
        NSString *html = [NSString stringWithFormat:
                          @"<html><body style=\"margin:0\"><img src=hanbit_greeting.png width=\"%d\"></body></html>",
                          (int)self.view.frame.size.width];
    
        [_viewControl loadHTMLString:html baseURL:baseURL];
    }
    else if (_category == MENU_ID_CHURCH_STAFF) // 섬기는 이들
    {
        NSURL *url = [NSURL URLWithString:@"http://www.sdhanbit.org/wordpress/mobile/staff.html"];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //_viewControl.scalesPageToFit = YES;
        [_viewControl loadRequest:requestObj];
    }
    else if (_category == MENU_ID_WORSHIP_INFO) // 예배 안내
    {
        NSString *html = [NSString stringWithFormat:
                          @"<html><head> \
                          <style type=\"text/css\"> \
                          body { \
                          background: url('%@'); \
                          background-repeat: no-repeat; \
                          background-size: cover; \
                          font-family: \"AppleSDGothicNeo-Light\"; \
                          margin: 10px; } \
                          </style></head> \
                          <body> \
                          <p style=\"color:#642EFE;font-size:20px\">주일 예배 시간</p> \
                          <table border=1 frame=hsides rules=rows cellpadding=4 style=\"color:black;font-size:12px;\"> \
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
                          <p style=\"color:#642EFE;font-size:20px\">기타 모임 시간</p> \
                          <table border=1 frame=hsides rules=rows cellpadding=4 style=\"color:black;font-size:12px;\"> \
                          <tr><td width=80>목장 모임</td><td>(금) 오후 7시</td></tr> \
                          <tr><td width=80>대학부 모임</td><td>(금) 오후 6시</td></tr> \
                          <tr><td width=80>청년부 모임</td><td>(금) 오후 7시30분, (주) 오후 3시30분</td></tr> \
                          <tr><td width=80>새벽 기도회</td><td>(화)-(금) 오전 5시30분, (토) 오전 6시</td></tr> \
                          <tr><td width=80>수요 기도회</td><td>(수) 오후 8시</td></tr> \
                          <tr><td width=80>시니어부</td><td>(주) 2부 예배후</td></tr> \
                          </table> \
                          <br><br><br></body></html>",
                          backImageList[2] ];
        
        [_viewControl loadHTMLString:html baseURL:baseURL];
    }
    else if (_category == MENU_ID_CULTURE_SCHOOL) // 문화 학교
    {
        NSURL *url = [NSURL URLWithString:@"http://www.sdhanbit.org/wordpress/mobile/culture_school.html"];
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
