# ZPRuntime
本Demo主要介绍了Runtime运行时的概念以及objc_msgSend函数的作用，还介绍了Runtime运行时的五大用途，还介绍了Runtime运行时常用的API的使用方法。

Runtime运行时在项目中的五个作用：

1、动态改变对象的属性值；

2、动态交换方法；

3、动态添加方法；

4、为分类增加实例变量；

5、使用运行时方式封装对象。

视频路径：小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day11——>089-Runtime01-简介.ev4、090-Runtime02-isa01-简介.ev4、091-Runtime03-isa02-需求.ev4、092-Runtime04-isa03-取值.ev4、093-Runtime05-isa04-设值.ev4、094-Runtime06-isa05-位域.ev4、095-Runtime07-isa06-共用体.ev4、096-Runtime08-isa07-总结.ev4；

视频路径：小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day12——>097-Runtime09-isa08-位运算补充.ev4、098-Runtime10-isa09-细节.ev4、099-Runtime11-方法01-Class的结构.ev4、100-Runtime12-方法02-method.ev4、101-Runtime13-方法03-Type%20Encoding.ev4、102-Runtime14-方法04-cache_t.ev4、103-Runtime15-方法05-散列表缓存.ev4；

视频路径：小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day13——>104-Runtime16-方法06-查看缓存01.ev4、105-Runtime17-方法07-查看缓存02.ev4、106-Runtime18-objc_msgSend01-简介.ev4、107-Runtime19-objc_msgSend02-消息发送01.ev4、108-Runtime20-objc_msgSend03-消息发送02.ev4、109-Runtime21-objc_msgSend04-动态方法解析01.ev4、110-Runtime22-objc_msgSend05-动态方法解析02.ev4、111-Runtime23-objc_msgSend06-动态方法解析03.ev4；

视频路径：小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day14——>112-Runtime24-objc_msgSend07-消息转发01.ev4、113-Runtime25-objc_msgSend08-消息转发02.ev4、114-Runtime26-objc_msgSend09-消息转发03.ev4、115-Runtime27-objc_msgSend10-消息转发04.ev4、116-Runtime28-objc_msgSend11-消息转发05.ev4、117-Runtime29-objc_msgSend12-总结.ev4、120-Runtime32-答疑.ev4。

视频路径：小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day15——>123-Runtime35-super面试题01.ev4、124-Runtime36-super面试题02.ev4、125-Runtime37-super面试题03.ev4、126-Runtime38-super面试题04.ev4、127-Runtime39-super面试题05.ev4、128-Runtime40-答疑.ev4；

视频路径：小马哥——>2018年9月iOS底层原理班（加密版）——>下（OC对象、关联对象、多线程、内存管理、性能优化）——>2.底层下-原理——>day16——>129-Runtime41-LLVM的中间代码.ev4、130-Runtime42-API01-类.ev4、131-Runtime43-API02-成员变量01.ev4、132-Runtime44-API02-成员变量02.ev4、133-Runtime45-API02-成员变量03.ev4、134-Runtime46-API03-方法01.ev4、135-Runtime47-总结.ev4。
