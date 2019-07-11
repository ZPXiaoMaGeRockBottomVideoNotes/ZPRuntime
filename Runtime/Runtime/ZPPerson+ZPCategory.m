//
//  ZPPerson+ZPCategory.m
//  Runtime
//
//  Created by 赵鹏 on 2019/2/16.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import "ZPPerson+ZPCategory.h"
#import <objc/runtime.h>

@implementation ZPPerson (ZPCategory)

const char *name = "nick";

#pragma mark ————— Runtime用途4：为分类增加实例变量 —————
//在分类里面重写实例变量的setter和getter方法
- (void)setNick:(NSString *)nick
{
    objc_setAssociatedObject(self, &name, nick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)nick
{
    return objc_getAssociatedObject(self, &name);
}

@end
