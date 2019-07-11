//
//  NSObject+ZPModel.m
//  彩票项目
//
//  Created by 赵鹏 on 2019/2/2.
//  Copyright © 2019 apple. All rights reserved.
//

/**
 封装对象的三种方式：
 1、使用普通方式封装对象；
 2、使用KVC方式封装对象；
 3、使用运行时方式封装对象。
 */
#import "NSObject+ZPModel.h"
#import <objc/runtime.h>

@implementation NSObject (ZPModel)

#pragma mark ————— Runtime用途5：使用运行时方式封装对象 —————
/**
 使用运行时方式封装对象的方法：有时候传入的字典参数里面有的key是系统的关键字，不能直接作为模型类的属性名，所以就要用其他的属性名来代替，把新的属性名和旧的属性名组成一个键值对，如果有多个的话可以组成多个键值对，然后把这些键值对组成一个字典作为这个方法中的mapDict参数传进来。
 */
+ (instancetype)useRuntimeMethodPackagingObjectWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict
{
    id object = [[self alloc] init];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    
    for (int i = 0 ; i < count; i++)
    {
        Ivar ivar = ivars[i];
        
        /**
         运行下行代码之后得到的是ZPHtml类中的"_title"、"_html"、"_ID"属性名
         */
        NSString *ivarName = @(ivar_getName(ivar));
        
        /**
         下行代码的作用是把上面得到的属性名中的"_"去掉；
         运行下行代码之后得到的是"title"、"html"、"ID"属性名
         */
        ivarName = [ivarName substringFromIndex:1];
        
        //根据属性名从字典里面取值
        id value = [dict objectForKey:ivarName];
        
        if (value == nil)  //如果取不到的话则证明字典里面没有这个属性名，比如这里面的"ID"
        {
            if (mapDict)
            {
                NSString *keyName = [mapDict objectForKey:ivarName];  //从mapDict中找到原来字典中的被替换的key
                value = [dict objectForKey:keyName];  //根据原来字典中的被替换的key从dict中找到所对应的value
            }
        }
        
        //使用KVC的方式封装对象
        [object setValue:value forKeyPath:ivarName];
    }
    
    return object;
}

@end
