//
//  CallDirectoryHandler.m
//  CallerID
//
//  Created by Rzk on 2019/11/20.
//  Copyright © 2019 Rzk. All rights reserved.
//

#import "CallDirectoryHandler.h"
#import <CallKit/CallKit.h>
#define kExtensionIdentifier @"callerid.micsoft.CallerID.CallerID-Demo"

typedef enum : NSUInteger {
    IDNumberManageAdd = 0,
    IDNumberManageDelete,
    BlockNumberManageAdd,
    BlockNumberManageDelete,
} NumberManage;

@interface CallDirectoryHandler ()

@end

@implementation CallDirectoryHandler

+ (CallDirectoryHandler *)shared {
    static CallDirectoryHandler *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


#pragma mark - func
#pragma mark -- public func
/// 添加标记
/// @param ID 标记
/// @param number 号码
/// @param block 回调
- (void)addIdentification:(NSString *)ID toNumber:(NSString *)number complete:(void(^)(BOOL finish))block {
    [self permissionStatusConfirm:^(BOOL allow) {
        if (allow) {
            [self manage:IDNumberManageAdd toNumber:number withID:ID complete:block];
        }
    }];
}

/// 移除标记
/// @param number 号码
/// @param block 回调
- (void)removeIdentificationForNumber:(NSString *)number complete:(void(^)(BOOL finish))block {
    [self permissionStatusConfirm:^(BOOL allow) {
        if (allow) {
            [self manage:IDNumberManageDelete toNumber:number withID:@"" complete:block];
        }
    }];
}

/// 添加block
/// @param number 号码
/// @param block 回调
- (void)addBlockNumber:(NSString *)number complete:(void(^)(BOOL finish))block {
    [self permissionStatusConfirm:^(BOOL allow) {
        if (allow) {
            [self manage:BlockNumberManageAdd toNumber:number withID:@"" complete:block];
        }
    }];
}

/// 移除block
/// @param nubmer 号码
/// @param block 回调
- (void)removeBlockNumber:(NSString *)nubmer complete:(void(^)(BOOL finish))block {
    [self permissionStatusConfirm:^(BOOL allow) {
        if (allow) {
            [self manage:BlockNumberManageDelete toNumber:nubmer withID:@"" complete:block];
        }
    }];
}

#pragma mark -- private func

- (void)permissionStatusConfirm:(void(^)(BOOL allow))block {
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    [manager getEnabledStatusForExtensionWithIdentifier:kExtensionIdentifier completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (!error) {
            switch (enabledStatus) {
                case CXCallDirectoryEnabledStatusEnabled:
                    if (block) block(YES); break;
                case CXCallDirectoryEnabledStatusUnknown:
                    //                    [MBProgressHUD showInfoWithStatus:@"Unknown permission, please reinstall the app"]; break;
                case CXCallDirectoryEnabledStatusDisabled:
                    //                    [self openSetting]; break;
                default: break;
            }
        }
        if (block) block(NO);
    }];
}

- (void)manage:(NumberManage)manage toNumber:(NSString *)number withID:(NSString *)ID complete:(void(^)(BOOL finish))block{
    NSTimeInterval interval_begin = [[NSDate date] timeIntervalSince1970];
//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
//    ContactModel * model = [[ContactModel alloc] init];
//    model.phoneNumber = number;
//    model.identification = ID;
//
//    switch (manage) {
//        case IDNumberManageAdd:
//            [[FMDataBaseManager shareInstance] updateContact:model toTable:kNumberTable]; break;
//        case IDNumberManageDelete:
//            [[FMDataBaseManager shareInstance] removeContact:model inTable:kNumberTable]; break;
//        case BlockNumberManageAdd:
//            [[FMDataBaseManager shareInstance] updateContact:model toTable:kBlockNumberTable]; break;
//        case BlockNumberManageDelete:
//            [[FMDataBaseManager shareInstance] removeContact:model inTable:kBlockNumberTable]; break;
//        default: break;
//    }

    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    [manager reloadExtensionWithIdentifier:kExtensionIdentifier completionHandler:^(NSError * _Nullable error) {
        
        NSTimeInterval interval_end = [[NSDate date] timeIntervalSince1970];
        NSString * time = [NSString stringWithFormat:@"spend time: %.1f s", interval_end-interval_begin];
        NSString * title = !error ? @"Update Succeed √" : @"Update Failed X";
        NSString * message = (manage == IDNumberManageAdd || manage == IDNumberManageDelete) ? [NSString stringWithFormat:@"> %@ <\n%@", @"ID Contacts", time] : [NSString stringWithFormat:@"> %@ <\n%@", @"Block Contacts", time];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            if (!error && block) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUINotification object:nil];
                block(YES);
            } else {
                if (block) block(NO);
            }
        });
    }];
}

@end
