//
//  FMDataBaseManager.m
//  CallerID
//
//  Created by Rzk on 2019/11/20.
//  Copyright © 2019 Rzk. All rights reserved.
//

#import "FMDataBaseManager.h"

@interface FMDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation FMDataBaseManager

+ (FMDataBaseManager *)shareInstance {
    static FMDataBaseManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        [instance dbQueue];
    });
    return instance;
}

- (FMDatabaseQueue *)dbQueue {
    if (!_dbQueue) {
        
        NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupName];
        containerURL = [containerURL URLByAppendingPathComponent:@"Library/"];
        NSString * dbPath = [NSString stringWithFormat:@"%@/%@",containerURL.absoluteString, @"LocalNumberDB.sqlite"];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if (_dbQueue) {
            [self createTableIfNotExists:kUserBlockTabel];
            [self createTableIfNotExists:kUserIdentifyTabel];
        }
    }
    return _dbQueue;
}

- (void)createTableIfNotExists:(NSString *)table {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (phoneNumber integer PRIMARY KEY, identification text)", table];
        BOOL finish = [db executeUpdate:createTableSQL];
        NSLog(@"[Table >> %@ << creat %@]", table, finish ? @"Succeed" : @"Failed");
    }];
}

- (void)closeDBForDisconnect; {
    self.dbQueue = nil;
}

- (NSArray *)getAllContacts:(NSString *)table {
    NSMutableArray *allUsers = [NSMutableArray new];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY phoneNumber ASC", table];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            ContactModel *model = [[ContactModel alloc] init];
            model.phoneNumber = [rs stringForColumn:@"phoneNumber"];
            model.identification = [rs stringForColumn:@"identification"];
            [allUsers addObject:model];
        }
        [rs close];
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    return allUsers;
}

- (void)updateContact:(ContactModel *)contact toTable:(NSString *)table with:(void(^)(BOOL result))handler {
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (phoneNumber, identification) VALUES (?, ?)", table];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL reslut = [db executeUpdate:sql, contact.phoneNumber, contact.identification];
        if (handler) {
            handler(reslut);
        }
    }];
}

- (void)removeContact:(ContactModel *)contact inTable:(NSString *)table with:(void(^)(BOOL result))handler {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE phoneNumber = %@", table, contact.phoneNumber];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL reslut = [db executeUpdate:sql];
        if (handler) {
            handler(reslut);
        }
    }];
}

@end
