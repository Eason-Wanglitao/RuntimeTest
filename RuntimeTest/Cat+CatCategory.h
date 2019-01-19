//
//  Cat+CatCategory.h
//  RuntimeTest
//
//  Created by 王立涛 on 2019/1/19.
//  Copyright © 2019 EasonWang. All rights reserved.
//

#import "Cat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cat (CatCategory)
@property (nonatomic, copy) NSString *color;
- (void)clearAssociateObject;
@end

NS_ASSUME_NONNULL_END
