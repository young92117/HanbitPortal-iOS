//
//  DBManager.h
//  SDHanbitChurch
//
//  Created by Jaehong Chon on 5/25/14.
//  Copyright (c) 2014 San Diego Hanbit Church. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject {
    NSInteger _category;
    NSString *_title;
    NSString *_pubdate;
    NSString *_content;
    
}

- (id)initWithContents:(NSInteger)category title:(NSString *)title pubdate:(NSString *)pubdate content:(NSString *)content;

+ (BOOL) prepareDatabase;
+ (BOOL) addItemsToDatabase:(NSInteger)identifier Category:(NSInteger)cat UpdateDate:(NSString*)updatedate Title:(NSString *)title PubDate:(NSString *)pubdate permLink:(NSString *)link Content:(NSString *)content;
+ (NSArray*) findItemsByCategory:(NSInteger)category;
+ (NSString*) getLatestUpdateDate;

@end