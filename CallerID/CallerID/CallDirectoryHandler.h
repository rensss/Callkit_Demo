//
//  CallDirectoryHandler.h
//  CallerID
//
//  Created by Rzk on 2019/11/20.
//  Copyright © 2019 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"

@interface CallDirectoryHandler : NSObject

+ (instancetype)shared;

/// 添加标记
/// @param ID 标记
/// @param number 号码
/// @param block 回调
- (void)addIdentification:(NSString *)ID toNumber:(NSString *)number complete:(void(^)(BOOL finish))block;

/// 移除标记
/// @param number 号码
/// @param block 回调
- (void)removeIdentificationForNumber:(NSString *)number complete:(void(^)(BOOL finish))block;

/// 添加block
/// @param number 号码
/// @param block 回调
- (void)addBlockNumber:(NSString *)number complete:(void(^)(BOOL finish))block;

/// 移除block
/// @param nubmer 号码
/// @param block 回调
- (void)removeBlockNumber:(NSString *)nubmer complete:(void(^)(BOOL finish))block;

@end
