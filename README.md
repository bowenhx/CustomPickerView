# CustomPickerView
Does not require an agent picker view，comfy block

这是一个轻量级的pickerview

不需要设置pickerView 代理，一句话搞定 ,block 便捷返回，例子参考如下：

//一级pickerView

//displayCout 表示返回 numberOfComponentsInPickerView 数量

//数据传入数组，类似于data = @[@"obj1",@"obj2"];

        [ActionPickerView showPickerViewTitle:@"选择区域" displayCount:1 datas:data forKey1:nil forKey2:nil defineSelect:2 doneBlock:^(ActionPickerView *picker, NSInteger selectedIndex, id selectedValue) {
        
         NSLog(@"selectedIndex = %ld,value = %@",(long)selectedIndex,selectedValue);
        
        } cancelBlock:^(ActionPickerView *picker) {
       
        NSLog(@"cancel action");
        } origin:self.view];


//二级pickerView

//有二级pickerView 传入数据及参数key 自动识别判断，不需要实现代理

//data 如@[
            @{
            @"title":@"obj1",
            @"data":@[@"obj1",@"obj2"]
            },
            @{
            @"title":@"obj2",
            @"data":@[@"obj1",@"obj2",@"obj3",@"obj4"]
            }
            ]；

//key1，key2 表示字典数据对应到pickerView 一级二级列表的key            

        [ActionPickerView showPickerViewTitle:@"选择区域" displayCount:2 datas:data forKey1:@"title" forKey2:@"data" defineSelect:0 doneBlock:^(ActionPickerView *picker, NSInteger selectedIndex, id selectedValue) {
        
          NSLog(@"selectedIndex = %ld,value = %@",(long)selectedIndex,selectedValue);
        } cancelBlock:^(ActionPickerView *picker) {
          
            NSLog(@"cancel action");
        } origin:self.view];
