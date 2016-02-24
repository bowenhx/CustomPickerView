//
//  ViewController.m
//  CustomPickerView
//
//  Created by bowen on 16/2/24.
//  Copyright © 2016年 com.mobile-kingdom. All rights reserved.
//

#import "ViewController.h"
#import "ActionPickerView.h"

@interface ViewController ()
{
    NSArray   *_arrData1;
    NSArray   *_arrData2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _arrData1 = @[@"屯門區",@"元朗區",@"大埔區",@"西貢區",@"沙田區",@"離島區",@"北區",@"荃灣區",@"葵青區"];
    
    _arrData2 = @[
                  @{@"title":@"香港島",
                    @"data":@[@"中西區",@"灣仔區",@"東區",@"南區"]
                    },
                  @{@"title":@"九龍",
                    @"data":@[@"油尖旺區",@"深水埗區",@"九龍城區",@"黃大仙區"]
                    },
                  @{@"title":@"新界及離島",
                    @"data":@[@"屯門區",@"元朗區",@"大埔區",@"西貢區",@"沙田區",@"離島區",@"北區",@"荃灣區",@"葵青區"]
                    },
                  @{@"title":@"其他",
                    @"data":@[@"其他"]
                    }
                  ];
    
}
- (IBAction)showPickerViewAction:(UIButton *)sender
{
    if (sender.tag == 10) {
        //一级pickerView
        ActionPickerView *action = [ActionPickerView showPickerViewTitle:@"选择区域" displayCount:1 datas:_arrData1 forKey1:nil forKey2:nil defineSelect:2 doneBlock:^(ActionPickerView *picker, NSInteger selectedIndex, id selectedValue) {
            NSLog(@"selectedIndex = %ld,value = %@",(long)selectedIndex,selectedValue);
            [sender setTitle:selectedValue forState:0];
        } cancelBlock:^(ActionPickerView *picker) {
            NSLog(@"cancel action");
        } origin:self.view];
    
        action.toolbar.barTintColor = [UIColor greenColor];
        
    }else{
        //有二级pickerView 传入数据及参数key 自动识别判断，不需要实现代理
        [ActionPickerView showPickerViewTitle:@"选择区域" displayCount:2 datas:_arrData2 forKey1:@"title" forKey2:@"data" defineSelect:0 doneBlock:^(ActionPickerView *picker, NSInteger selectedIndex, id selectedValue) {
            NSLog(@"selectedIndex = %ld,value = %@",(long)selectedIndex,selectedValue);
            [sender setTitle:selectedValue forState:0];
        } cancelBlock:^(ActionPickerView *picker) {
            NSLog(@"cancel action");
        } origin:self.view];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
