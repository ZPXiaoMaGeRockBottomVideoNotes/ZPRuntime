//
//  main.m
//  Runtime
//
//  Created by 赵鹏 on 2019/2/16.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZPPerson.h"
#include <objc/message.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        /**
         把本文件所在的文件夹拖到终端中，然后输入"clang -rewrite-objc main.m -o main.cpp"命令，在终端中用clang的方式进行编译，编译完成之后在文件夹中会生成本文件的.cpp文件（C++文件）；
         方法的本质：打开新生成的.cpp文件后就会看到在编译期间系统会把下行的代码转化为"ZPPerson *p = ((ZPPerson *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("ZPPerson"), sel_registerName("new"));"语句，所以说在OC中任何方法的调用都会编译成"objc_msgSend"代码，即方法的本质是发送消息；
         对象的本质：在新生成的.cpp文件中有这样的代码"struct ZPPerson_IMPL {struct NSObject_IMPL NSObject_IVARS;};"，从这句代码可以看出OC中对象的本质是结构体。
         */
        ZPPerson *person = [[ZPPerson alloc] init];
        
        /**
         下面的这句代码在.cpp文件中会转化为"((void (*)(id, SEL))(void *)objc_msgSend)((id)p, sel_registerName("run"));"语句；
         上述语句中的(id)p表示的是消息接收者，"sel_registerName("run")"表示的是方法编号；
         和C语言不同，在OC中方法的重载是根据标签来识别区分的，并不是根据参数名来区分的；
         SEL：在Runtime运行时中表示的是方法编号，可以把它理解为只是描述了一个方法的格式，如果把方法名理解为一个标签的话，SEL就是描述一种由几个标签构成的方法，更偏向于C语言里面的函数声明，SEL并不会指向方法实现本身；
         IMP：是Implement的缩写，在Runtime运行时中表示的是函数指针，指向方法实现的地址；
         在Runtime运行时中SEL和IMP是通过哈希表联系在一起的。系统通过SEL来调用方法的过程是：系统先通过SEL所在的类找到对应的IMP，然后通过IMP去掉用方法的实现。
         */
        [person firstMethod];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
