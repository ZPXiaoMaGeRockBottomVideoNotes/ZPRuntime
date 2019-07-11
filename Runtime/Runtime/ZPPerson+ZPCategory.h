//
//  ZPPerson+ZPCategory.h
//  Runtime
//
//  Created by 赵鹏 on 2019/2/16.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZPPerson (ZPCategory)

/**
 一般情况下分类可以为现有的类增加方法，但是无法直接增加实例变量；
 可以通过Runtime为分类增加实例变量。
 */
@property (nonatomic, copy) NSString *nick;  //昵称

@end

NS_ASSUME_NONNULL_END
