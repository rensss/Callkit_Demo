//
//  FMDataBaseManager.h
//  CallerID
//
//  Created by Rzk on 2019/11/20.
//  Copyright © 2019 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"
#import <FMDB/FMDB.h>

#define kUserBlockTabel @"USERBLOCKTABLE"
#define kUserIdentifyTabel @"USERIDENTIFYTABLE"
#define kGroupName @"group.callerid.demoooo"

NS_ASSUME_NONNULL_BEGIN

@interface FMDataBaseManager : NSObject

+ (FMDataBaseManager *)shareInstance;

- (void)closeDBForDisconnect;

- (void)updateContact:(ContactModel *)contact toTable:(NSString *)table with:(void(^)(BOOL result))handler;

- (void)removeContact:(ContactModel *)contact inTable:(NSString *)table with:(void(^)(BOOL result))handler;

- (NSArray *)getAllContacts:(NSString *)table;

@end

NS_ASSUME_NONNULL_END
