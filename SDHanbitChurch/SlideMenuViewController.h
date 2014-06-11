//
//  SlideMenuViewController.h
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 3/1/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import <UIKit/UIKit.h>

// dynamic information
#define MENU_ID_SERMON_COLUMN 14 // 목회칼럼
#define MENU_ID_CHURCH_NEWS   15 // 교회소식/광고
#define MENU_ID_SERMON_VIDEO  30 // 설교동영상
#define MENU_ID_SERMON_SHARE  61 // 설교나눔
#define MENU_ID_BIBLE_SEED    87 // 말씀의 씨앗

// static information
#define MENU_ID_CHURCH_INTRO   201 // 교회소개
#define MENU_ID_BIBLE_AMSONG   202 // 성경암송
#define MENU_ID_HOPE_SEED      203 // 소망의 씨앗
#define MENU_ID_WEEKLY_ASSIGN  204 // 금주사역
#define MENU_ID_MAINPASTOR     301 // 담임목사 소개/인사말
#define MENU_ID_CHURCH_STAFF   302 // 섬기는 이들
#define MENU_ID_WORSHIP_INFO   304 // 예배 안내
#define MENU_ID_CULTURE_SCHOOL 305 // 문화 학교

#define MENU_ID_NULL           0 


@interface SlideMenuViewController : UITableViewController

@end
