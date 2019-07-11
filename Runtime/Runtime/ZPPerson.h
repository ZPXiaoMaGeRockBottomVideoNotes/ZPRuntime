//
//  ZPPerson.h
//  Runtime
//
//  Created by 赵鹏 on 2019/2/16.
//  Copyright © 2019 赵鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPPerson : NSObject

@property (nonatomic, copy) NSString *name;

- (void)firstMethod;
- (void)secondMethod;

@end

NS_ASSUME_NONNULL_END
