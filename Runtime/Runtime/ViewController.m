//
//  ViewController.m
//  Runtime
//
//  Created by 赵鹏 on 2019/2/16.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 Runtime运行时的概念：
 1、Runtime运行时是一套比较底层的API，它是由C语言、C++、汇编语言组成的；
 2、OC是一门动态性比较强的编程语言，允许很多操作推迟到运行时再进行。OC的动态性就是由Runtime来支撑和实现的；
 3、编译时：这个阶段是代码编译的阶段。平时编程用的语言（例如：OC、Swift、Java等）称为高级语言，这些语言机器并不能识别，在编译的时候系统会把它们转化为机器能够识别的机器语言（汇编语言等），然后再转化为二进制数据进行运行；
 4、运行时：代码在经过编译时编译以后，程序就会被运行起来，这个阶段就是Runtime运行时阶段。Runtime底层库经过编译会提供Runtime API来供OC进行调用。
 
 调用Runtime运行时框架的三种方式：
 1、在文件中引入"#include <objc/message.h>"头文件，然后在"TARGETS"中的"Build Settings"中搜索"msg"，在搜索结果中把"Enable Strict Checking of objc_msgSend Calls"由"Yes"改为"No"，否则无法调用相关的函数，最后再调用Runtime自身的API，例如："objc_msgSend()"；
 2、调用NSObject中的API，例如："isKindOfClass:<#(__unsafe_unretained Class)#>]"；
 3、调用OC的上层方法，例如："@selector(<#selector#>)"。
 
 isa详解：
 1、在arm64架构之前，isa就是一个普通的指针，存储着类对象(Class)、元类对象(Meta-Class)的内存地址；
 2、从arm64架构开始，系统就对isa进行了优化，变成了一个共用体（union）结构，还使用位域来存储更多的信息。
 
 objc_msgSend函数：
 OC中的方法调用其实都是转成了objc_msgSend函数的调用，给receiver（方法调用者）发送了一条消息（selector方法名）；
 objc_msgSend底层有3大阶段：
 1、消息发送（当前类、父类中查找）；
 2、动态方法解析；
 3、消息转发。
 */
#import "ViewController.h"
#import "ZPPerson.h"
#import <objc/runtime.h>  //Runtime框架在objc文件中
#import "ZPPerson+ZPCategory.h"
#import "ZPHtml.h"
#import "NSObject+ZPModel.h"
#import "ZPAnimals.h"
#import "ZPCar.h"

@interface ViewController ()

@property (nonatomic, strong) ZPPerson *person;
@property (nonatomic, strong) NSArray *htmlsArray;

@end

@implementation ViewController

#pragma mark ————— 懒加载 —————
- (NSArray *)htmlsArray
{
    if (_htmlsArray == nil)
    {
        //获取json文件的路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"help.json" ofType:nil];
        
        //把json文件变成二进制数据
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        //解析json数据
        NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //封装对象
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray)
        {
            //Runtime用途5：使用运行时方式封装对象
            ZPHtml *html = [ZPHtml useRuntimeMethodPackagingObjectWithDict:dict mapDict:[NSDictionary dictionaryWithObject:@"id" forKey:@"ID"]];
            
            [mutableArray addObject:html];
        }
        
        _htmlsArray = mutableArray;
    }
    
    return _htmlsArray;
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.person = [[ZPPerson alloc] init];
    self.person.name = @"Tom";
    NSLog(@"%@", self.person.name);
    
    [self test];
}

#pragma mark ————— Runtime用途1：动态改变对象的属性值 —————
- (void)changePropertyValue
{
    //实例变量的个数
    unsigned int count = 0;
    
    //获取到的ivar是person对象的所有实例变量的指针所组成的数组。
    Ivar *ivar = class_copyIvarList([self.person class], &count);
    
    //遍历上述指针数组
    for (int i = 0; i < count; i++)
    {
        //获取对象实例变量的指针
        Ivar var = ivar[i];
        
        //获取实例变量的名字
        const char *varName = ivar_getName(var);
        
        //把实例变量的名字转化成字符串类型
        NSString *name = [NSString stringWithUTF8String:varName];
        
        if ([name isEqualToString:@"_name"])  //改变对象的属性值
        {
            object_setIvar(self.person, var, @"Jerry");
            
            break;
        }
    }
}

#pragma mark ————— Runtime用途2：动态交换方法 —————
//这种用途常用于Method Swizzle（方法欺骗），相关的Demo可以参考“逻辑教育视频笔记——>付费课——>iOS逆向工程及应用安全——>20181207--第四讲--代码注入——>方法欺骗”。
- (void)exchangeMethod
{
    //获取方法
    Method method1 = class_getInstanceMethod([self.person class], @selector(firstMethod));
    Method method2 = class_getInstanceMethod([self.person class], @selector(secondMethod));
    
    method_exchangeImplementations(method1, method2);
}

#pragma mark ————— Runtime用途3：动态添加方法 —————
- (void)addMethod
{
    /**
     cls参数：给哪个类添加方法；
     name参数：方法名；
     imp参数：方法的指针；
     types参数：类型。
     
     "v@:@"："v"表示实现方法里的返回值void，"@"表示id类型，":"表示方法编号(SEL)，"@"表示实现方法的参数
     */
    class_addMethod([self.person class], @selector(run:), (IMP)runMethod, "v@:@");
}

//方法的实现
void runMethod(id self, SEL _cmd, NSString *miles)
{
    NSLog(@"%@", miles);
}

#pragma mark ————— 点击“改变”按钮 —————
- (IBAction)change:(UIButton *)sender
{
    //Runtime用途1：动态改变对象的属性值
    [self changePropertyValue];
    
    //Runtime用途2：动态交换方法
//    [self exchangeMethod];
    
    //Runtime用途3：动态添加方法
//    [self addMethod];
    
    //Runtime用途4：为分类增加实例变量
//    self.person.nick = @"Cat";
}

#pragma mark ————— 点击“显示”按钮 —————
- (IBAction)show:(UIButton *)sender
{
    //对应Runtime用途1
    NSLog(@"%@", self.person.name);
    
    //对应Runtime用途2
//    [self.person firstMethod];
    
    //对应Runtime用途3
//    if ([self.person respondsToSelector:@selector(run:)])
//    {
//        [self.person performSelector:@selector(run:) withObject:@"1 miles"];
//    }else
//    {
//        NSLog(@"没有方法实现");
//    }
    
    //对应Runtime用途4
//    NSLog(@"%@", self.person.nick);
    
    //对应Runtime用途5
//    NSLog(@"htmlsArray = %@", self.htmlsArray);
}

#pragma mark ————— Runtime常用的API—————
- (void)test
{
    ZPAnimals *animals = [[ZPAnimals alloc] init];
    [animals run];
    
    /**
     "object_getClass"：后面的参数放入的是实例对象的话，获取到的是类对象，放入的是类对象的话获取到的是元类对象，总之是获取参数里面的isa指针指向的东西。
     */
    NSLog(@"%p, %p", object_getClass(animals), [ZPAnimals class]);
    
    /**
     "object_setClass"：动态地修改参数中实例对象的类型；
     修改参数中实例对象的isa指针指向的class类型，把参数中实例对象的原来类型变为另外的一个新类型。
     */
    object_setClass(animals, [ZPCar class]);
    [animals run];
    
    /**
     "object_isClass"：判断参数中的oc对象是否是类对象；
     元类对象也是一种特殊的类对象。
     */
    NSLog(@"%d, %d, %d", object_isClass(animals), object_isClass([ZPAnimals class]), object_isClass(object_getClass([ZPAnimals class])));
    
    /**
     "objc_allocateClassPair"：动态创建一个新的类和元类；
     第一个参数是将要创建的这个类的父类；第二个参数是将要创建的这个类的类名；第三个参数是当创建这个类的时候需要扩充的内存空间，一般填写0就可以了。
     */
    Class newClass = objc_allocateClassPair([NSObject class], "ZPDog", 0);
    
    /**
     "class_addIvar"：为新创建的类添加成员变量；
     第一个参数写新创建的类；第二个参数写新添加的成员变量的名字；第三个参数写这个新添加的成员变量所占用的字节数；第四个参数代表内存对其，一般写1；第五个参数写新添加的那个成员变量的类型。
     */
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    class_addIvar(newClass, "_weight", 4, 1, @encode(int));
    
    /**
     "class_addMethod"：为新创建的类添加方法；
     第一个参数写新创建的类；第二个参数写要添加的方法的名称；第三个参数写新添加的方法的实现；
     */
    class_addMethod(newClass, @selector(run), (IMP)run, "v@:");
    
    //"objc_registerClassPair"：动态创建完了新的类之后还需要注册这个新的类。
    objc_registerClassPair(newClass);
    
    /**
     用动态新创建的类型来创建一个实例对象；
     然后用KVO的方式给这个实例对象里面的成员变量赋值（不能使用点的方式赋值，因为没有get和set方法）。
     */
    id dog = [[newClass alloc] init];
    [dog setValue:[NSNumber numberWithInteger:10] forKey:@"_age"];
    [dog setValue:[NSNumber numberWithInteger:20] forKey:@"_weight"];
    
    NSLog(@"%@, %@", [dog valueForKey:@"_age"], [dog valueForKey:@"_weight"]);
    
    //调用动态添加的新方法
    [dog run];
    
    /**
     "class_getInstanceSize"：查看新创建的类占用了多少内存空间；
     newClass这个新创建的类里面包含占用8个字节的isa指针，还有各占用4个字节的"_age"和"_weight"成员变量，所以这个新创建的类一共占有16个字节的内存空间。
     */
    NSLog(@"%zd", class_getInstanceSize(newClass));
}

void run(id self, SEL _cmd)
{
    NSLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
}

@end
