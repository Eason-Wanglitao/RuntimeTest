//
//  Cat.m
//  RuntimeTest
//
//  Created by 王立涛 on 2019/1/18.
//  Copyright © 2019 EasonWang. All rights reserved.
//

#import "Cat.h"


@interface Cat ()

@property (nonatomic, copy) NSString *name;

@end

@implementation Cat

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.name = @"小小酥";
	}
	return self;
}

+ (NSInteger)getCatAge {
	return 8;
}

- (void)sleep {
	NSLog(@"cat睡觉了");
}

- (void)sleepAndDream {
	NSLog(@"cat睡觉并且做梦了");
}

@end
