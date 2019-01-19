//
//  ViewController.m
//  RuntimeTest
//
//  Created by 王立涛 on 2019/1/18.
//  Copyright © 2019 EasonWang. All rights reserved.
//

#import "ViewController.h"
#import "Animal.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "RuntimeCaseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(100, 100, 100, 100);
	[button setTitle:@"跳转" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(gotoVC:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor orangeColor];
	[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[self.view addSubview:button];
	
	
//	Animal *animal = [[Animal alloc] init];
//	[animal eat];
	//相当于：Class class = [Animal class];
	Class animalClass = objc_getClass("Animal");
	
	//相当于：Animal *animal = [Animal alloc];
	Animal *animal = ((id (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Animal"), sel_registerName("alloc"));
	
	//相当于：Animal *animal = [Animal init];
	((id (*)(id, SEL))(void *)objc_msgSend)((id)animal, sel_registerName("init"));
	[animal eat];

}

- (void)gotoVC:(UIButton *)sender {
	RuntimeCaseViewController *runtimeCaseController = [[RuntimeCaseViewController alloc] init];
	[self presentViewController:runtimeCaseController animated:YES completion:nil];
}

@end
