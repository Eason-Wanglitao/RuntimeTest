//
//  Animal.m
//  RuntimeTest
//
//  Created by 王立涛 on 2019/1/18.
//  Copyright © 2019 EasonWang. All rights reserved.
//

#import "Animal.h"
#import <objc/runtime.h>
#import "AnimalForwarding.h"

@implementation Animal

+ (BOOL)resolveInstanceMethod:(SEL)sel {
	NSLog(@"消息转发了，执行了resolveInstanceMethod方法");
	if (sel == @selector(eat)) {
		class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(newEat)), "V@:");
		return YES;
	}
	return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
	NSLog(@"执行了forwardingTargetForSelector方法进行消息接收者重定向");
	return nil;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSLog(@"执行了forwardInvocation方法，进行最后一次IMP寻找");
	SEL sel = anInvocation.selector;
	AnimalForwarding *aForwarding = [AnimalForwarding new];
	if ([aForwarding respondsToSelector:sel]) {
		[anInvocation invokeWithTarget:aForwarding];
	}
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	NSLog(@"执行了methodSignatureForSelector方法，返回方法签名");
	if (aSelector == @selector(eat)) {
		return [NSMethodSignature signatureWithObjCTypes:"v@:"];
	}
	return [super methodSignatureForSelector:aSelector];
}


@end
