//
//  NSObject+ZPModel.h
//  彩票项目
//
//  Created by 赵鹏 on 2019/2/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZPModel)

+ (instancetype)useRuntimeMethodPackagingObjectWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict;

@end

NS_ASSUME_NONNULL_END
