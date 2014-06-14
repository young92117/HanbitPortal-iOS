//
//  BibleViewController.h
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 6/13/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BibleViewController : UIViewController

@property NSInteger category;
@property NSInteger biblePageIndex;
@property NSInteger pageMode;

+ (NSInteger) getThisWeekInfo;

@end
