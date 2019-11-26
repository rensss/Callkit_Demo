//
//  CallDirectoryHandler.m
//  CallerID_Demo
//
//  Created by Rzk on 2019/11/20.
//  Copyright © 2019 Rzk. All rights reserved.
//

#import "CallDirectoryHandler.h"
#import "FMDataBaseManager.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
    // and identification entries which have been added or removed since the last time this extension's data was loaded.
    // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
    // and identification phone numbers if the request is not incremental.
    /*
     检查这是否是“增量”数据请求。
     如果是这样，请仅提供自上次加载此分机数据以来已添加或删除的电话号码阻止和标识条目集。
     但是扩展必须仍然准备随时提供完整的数据集，因此，如果请求不是递增的，则添加所有阻止和标识电话号码。
     */
    if (context.isIncremental) {
        [self addOrRemoveIncrementalBlockingPhoneNumbersToContext:context];

        [self addOrRemoveIncrementalIdentificationPhoneNumbersToContext:context];
    } else {
        [self addAllBlockingPhoneNumbersToContext:context];

        [self addAllIdentificationPhoneNumbersToContext:context];
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

- (void)addAllBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    /*
     检索电话号码以阻止其进入数据存储区。
     为了在有多个电话号码时获得最佳性能和内存使用，请考虑在给定时间仅加载数字子集，并使用自动释放池释放在加载的每一批号码期间分配的对象。
     数字必须按数字升序排列。
     */
//    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 8614085555555, 8618005555555 };
//    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//    for (NSUInteger index = 0; index < count; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[index];
//        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
//    }
}

- (void)addOrRemoveIncrementalBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    /*
     检索对电话号码集的所有更改以从数据存储中阻止。
     为了在有多个电话号码时获得最佳性能和内存使用，请考虑在给定时间仅加载数字子集，并使用自动释放池释放在加载的每一批号码期间分配的对象。
     */
//    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 8618513192113 };
//    NSUInteger countOfPhoneNumbersToAdd = (sizeof(phoneNumbersToAdd) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger index = 0; index < countOfPhoneNumbersToAdd; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToAdd[index];
//        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
//    }
    
    [context removeAllBlockingEntries];
    
    NSArray * contacts = [[FMDataBaseManager shareInstance] getAllContacts:kUserBlockTabel];
    for (int i= 0; i < contacts.count; i ++) {
        @autoreleasepool {
            ContactModel * contact = contacts[i];
            if (contact.phoneNumber) {
                CXCallDirectoryPhoneNumber phoneNumber = [contact.phoneNumber longLongValue];
                [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
            }
            contact = nil;
        }
    }

//    CXCallDirectoryPhoneNumber phoneNumbersToRemove[] = { 8618513192113 };
//    NSUInteger countOfPhoneNumbersToRemove = (sizeof(phoneNumbersToRemove) / sizeof(CXCallDirectoryPhoneNumber));
//    for (NSUInteger index = 0; index < countOfPhoneNumbersToRemove; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToRemove[index];
//        [context removeBlockingEntryWithPhoneNumber:phoneNumber];
//    }

    // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
}

- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    
    /* 从数据存储中检索要识别的电话号码及其识别标签。 为了在有多个电话号码时获得最佳性能和内存使用，请考虑在给定时间仅加载数字子集，并使用自动释放池释放在加载的每一批号码期间分配的对象。
    数字必须按数字升序排列。 */
    
//    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 8618775555555, 8618885555555 };
//    NSArray<NSString *> *labels = @[ @"Telemarketer", @"Local business" ];
//    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//    for (NSUInteger i = 0; i < count; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[i];
//        NSString *label = labels[i];
//        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
//    }
}

- (void)addOrRemoveIncrementalIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve any changes to the set of phone numbers to identify (and their identification labels) from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    /*检索对电话号码集的任何更改，以从数据存储区进行识别（及其识别标签）。
     为了在有多个电话号码时获得最佳性能和内存使用，请考虑在给定时间仅加载数字子集，并使用自动释放池释放在加载的每一批号码期间分配的对象。
     */
    
    [context removeAllIdentificationEntries];
    
    NSArray * contacts = [[FMDataBaseManager shareInstance] getAllContacts:kUserIdentifyTabel];
    for (int i= 0; i < contacts.count; i ++) {
        @autoreleasepool {
            ContactModel * contact = contacts[i];
            if (contact.phoneNumber && contact.identification) {
                CXCallDirectoryPhoneNumber phoneNumber = [contact.phoneNumber longLongValue];
                NSString * label = contact.identification;
                [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
            }
            contact = nil;
        }
    }
    
//    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 8614085555678 };
//    NSArray<NSString *> *labelsToAdd = @[ @"New local business" ];
//    NSUInteger countOfPhoneNumbersToAdd = (sizeof(phoneNumbersToAdd) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger i = 0; i < countOfPhoneNumbersToAdd; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToAdd[i];
//        NSString *label = labelsToAdd[i];
//        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
//    }
//
//    CXCallDirectoryPhoneNumber phoneNumbersToRemove[] = { 8618885555555 };
//    NSUInteger countOfPhoneNumbersToRemove = (sizeof(phoneNumbersToRemove) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger i = 0; i < countOfPhoneNumbersToRemove; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToRemove[i];
//        [context removeIdentificationEntryWithPhoneNumber:phoneNumber];
//    }

    // Record the most-recently loaded set of identification entries in data store for the next incremental load...
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
    /*
     添加阻止或标识条目时发生错误，请检查NSError以获取详细信息。
     有关呼叫目录错误代码，请参见<CallKit / CXError.h>中的CXErrorCodeCallDirectoryManagerError枚举。
     这可用于将错误详细信息存储在扩展的包含应用程序可访问的位置，以便即使在用户在“设置”中（而不是通过“用户”发起加载数据的请求），也可以通知应用程序有关加载数据时发生的错误。 应用本身。
     */
    NSLog(@"---- %@",error);
}

@end
