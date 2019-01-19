//
//  RuntimeCaseViewController.m
//  RuntimeTest
//
//  Created by 王立涛 on 2019/1/18.
//  Copyright © 2019 EasonWang. All rights reserved.
//

#import "RuntimeCaseViewController.h"
#import "Cat.h"
#import "Cat+CatCategory.h"
#import <objc/runtime.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RuntimeCaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titleArray;
@end

@implementation RuntimeCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.titleArray = @[@"分类增加属性",
						@"获取类的实例方法",
						@"获取类的类方法",
						@"获取类的属性",
						@"获取所有成员变量",
						@"获取当前所遵守的所有协议",
						@"方法添加和替换",
						@"修改私有属性",
						];
	[self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = self.titleArray[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		//给分类添加属性
		Cat *cat = [[Cat alloc] init];
		cat.color = @"白色";
		NSLog(@"cat的颜色是%@",cat.color);
		[cat clearAssociateObject];
		NSLog(@"cat的颜色是%@",cat.color);
	} else if (indexPath.row == 1) {
		//获取类的实例方法
		unsigned int count = 0;
		Method *allMothods = class_copyMethodList([Cat class], &count);
		for (int i = 0; i < count; i++) {
			//Method,为runtime声明的一个宏，表示对一个方法的描述
			Method md = allMothods[i];
			//获取SEL:SEL类型，即获取方法选择器@selector（）
			SEL sel = method_getName(md);
			//得到sel的方法名：以字符串格式获取sel的name，也即@selector（）中的方法名称
			const char *methodName = sel_getName(sel);
			NSLog(@"(Method:%s)",methodName);
		}
		free(allMothods);
	} else if (indexPath.row == 2) {
		//获取类的类方法
		Class metaClass = object_getClass([Cat class]);
		unsigned int count = 0;
		Method *allMothods = class_copyMethodList(metaClass, &count);
		for (int i = 0; i < count; i++) {
			Method md = allMothods[i];
			SEL sel = method_getName(md);
			//得到sel的方法名：以字符串格式获取sel的name，也即@selector（）中的方法名称
			const char *methodName = sel_getName(sel);
			NSLog(@"(Method:%s)",methodName);
		}
		free(allMothods);
		
	} else if (indexPath.row == 3) {
		//获取类的属性列表
		unsigned int count;
		objc_property_t *propertyList = class_copyPropertyList([Cat class], &count);
		for (unsigned int i = 0; i<count; i++) {
			const char *propertyName = property_getName(propertyList[i]);
			NSLog(@"PropertyName(%d): %@",i,[NSString stringWithUTF8String:propertyName]);
		}
		free(propertyList);
	} else if (indexPath.row == 4) {
		unsigned int count = 0;
		//获取类的一个包含所有变量的列表，IVar是runtime声明的一个宏，是实例变量的意思
		Ivar *allVariables = class_copyIvarList([Cat class], &count);
		for (int i = 0; i<count; i++) {
			Ivar ivar = allVariables[i];
			const char *VariableName = ivar_getName(ivar);//获取成员变量名称
			const char *VariableType = ivar_getTypeEncoding(ivar);//获取成员变量类型
			NSLog(@"(Name:%s) ---(Type:%s)",VariableName,VariableType);
		}
		free(allVariables);
	} else if (indexPath.row == 5) {
		//获取类所遵守的所有协议
		unsigned int count;
		__unsafe_unretained Protocol **protocolList = class_copyProtocolList([Cat class], &count);
		for (int i=0; i< count; i++) {
			Protocol *protocal = protocolList[i];
			const char *protocolName = protocol_getName(protocal);
			NSLog(@"protocol(%d): %@",i, [NSString stringWithUTF8String:protocolName]);
		}
		free(protocolList);
	} else if (indexPath.row == 6) {
		//方法替换
		Cat *cat = [[Cat alloc] init];
		[cat sleep];
		SEL originalSleep = @selector(sleep);
		SEL swizzledSleep = @selector(sleepAndDream);
		
		Method originalMethod = class_getInstanceMethod([cat class],originalSleep);
		Method swizzledMethod = class_getInstanceMethod([cat class],swizzledSleep);
		
		//判断名为swizzledMethod的方法是否存在存在,返回NO表示存在，YES表示不存在。
		BOOL didAddMethod = class_addMethod([cat class], originalSleep, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
		
		if (didAddMethod) {
			//如果swizzledSleep不存在，我们就用它替换掉我们要交换的方法
			class_replaceMethod([cat class], swizzledSleep, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
		} else {
			//如果swizzledSleep存在，交换他们两个的实现
			method_exchangeImplementations(originalMethod, swizzledMethod);
		}
		[cat sleep];
		
	} else if (indexPath.row == 7) {
		Cat *cat = [[Cat alloc] init];
		NSLog(@"cat的name: %@",[cat valueForKey:@"name"]); //null
		//第一步：遍历对象的所有属性
		unsigned int count;
		Ivar *ivarList = class_copyIvarList([cat class], &count);
		for (int i= 0; i<count; i++) {
			//第二步：获取每个属性名
			Ivar ivar = ivarList[i];
			const char *ivarName = ivar_getName(ivar);
			NSString *propertyName = [NSString stringWithUTF8String:ivarName];
			if ([propertyName isEqualToString:@"_name"]) {
				//第三步：匹配到对应的属性，然后修改；注意属性带有下划线
				object_setIvar(cat, ivar, @"hello小小酥");
			}
		}
		NSLog(@"cat的name: %@",[cat valueForKey:@"name"]);
	} else if (indexPath.row == 8) {
		
	}
}



- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	}
	return _tableView;
}

@end
