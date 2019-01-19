//
//  Cat+CatCategory.m
//  RuntimeTest
//
//  Created by 王立涛 on 2019/1/19.
//  Copyright © 2019 EasonWang. All rights reserved.
//

#import "Cat+CatCategory.h"
#import <objc/runtime.h>

@implementation Cat (CatCategory)
- (void)setColor:(NSString *)color {
	objc_setAssociatedObject(self, @selector(color), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)color {
	return objc_getAssociatedObject(self, @selector(color));
}

///清除关联属性
- (void)clearAssociateObject {
	objc_removeAssociatedObjects(self);
}
@end
