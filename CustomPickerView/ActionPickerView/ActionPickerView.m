//
//  ActionPickerView.m
//  PickerViewDemo
//
//  Created by bowen on 16/2/19.
//  Copyright © 2016年 com.mobile-kingdom. All rights reserved.
//

#import "ActionPickerView.h"

@interface ActionPickerView()
@property (nonatomic , strong) NSArray   *data;
@property (nonatomic , assign) NSInteger displayCount;      //display count
@property (nonatomic , assign) NSInteger endSelectedIndex;  //end selected
@property (nonatomic , assign) NSInteger selectedIndex;     //begin selected

@property (nonatomic , copy)   NSString  *key1;             // display stair key
@property (nonatomic , copy)   NSString  *key2;             // display tow key
@end

@implementation ActionPickerView

+ (instancetype)showPickerViewTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlock origin:(id)origin{
    ActionPickerView * picker = [[ActionPickerView alloc] initWithTitle:title displayCount:count datas:data forKey1:key1 forKey2:key2 defineSelect:index doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title displayCount:count datas:data forKey1:key1 forKey2:key2 defineSelect:index target:nil finishAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (instancetype)showPickerViewTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index target:(id)target finishAction:(SEL)finishAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    ActionPickerView *picker = [[ActionPickerView alloc] initWithTitle:title displayCount:count datas:data forKey1:key1 forKey2:key2 defineSelect:index target:target finishAction:finishAction cancelAction:cancelActionOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index target:(id)target finishAction:(SEL)finishAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target successAction:finishAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.title              = title;
        self.key1               = key1;
        self.key2               = key2;
        self.data               = data;
        self.selectedIndex      = 0;
        self.endSelectedIndex   = index;
        self.displayCount       = count;
    }
    return self;
}


- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView selectRow:self.endSelectedIndex inComponent:0 animated:NO];
    if (self.data.count == 0) {
        pickerView.showsSelectionIndicator = NO;
        pickerView.userInteractionEnabled = NO;
    } else {
        pickerView.showsSelectionIndicator = YES;
        pickerView.userInteractionEnabled = YES;
    }
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = pickerView;
    
    return pickerView;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
        if (self.displayCount == 1) {
            id selectedObject = (self.data.count > 0) ? (self.data)[(NSUInteger) self.endSelectedIndex] : nil;
            _onActionSheetDone(self, self.endSelectedIndex, selectedObject);
        }else if (self.displayCount == 2){
            NSString *selectedObject = (self.data.count > 0) ? (self.data)[(NSUInteger) self.selectedIndex][_key1]: nil;
            NSString *componentObject = (self.data.count > 0) ? (self.data)[(NSUInteger) self.selectedIndex][_key2][(NSUInteger) self.endSelectedIndex] : nil;
            NSString *object = [NSString stringWithFormat:@"%@,%@",selectedObject,componentObject];
            _onActionSheetDone(self, self.endSelectedIndex, object);
        }
        
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:@(self.endSelectedIndex) withObject:origin];
#pragma clang diagnostic pop
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker and done block is nil.", object_getClassName(target), sel_getName(successAction));
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}
- (NSArray *)getCitiesByContinent
{
    NSArray *citiesIncontinent = self.data[_selectedIndex][_key2];
    return citiesIncontinent;
}

- (NSAttributedString *)attributedStringOfString:(NSString *)str
{
    // return the object if it is already a NSString,
    // otherwise, return the description, just like the toString() method in Java
    // else, return nil to prevent exception
    
    if ([str isKindOfClass:[NSString class]])
        return [[NSAttributedString alloc] initWithString:str attributes:self.pickerTextAttributes];
    
    if ([str respondsToSelector:@selector(description)])
        return [[NSAttributedString alloc] initWithString:[str performSelector:@selector(description)] attributes:self.pickerTextAttributes];
    
    return nil;
}

#pragma mark - UIPickerViewDelegate / DataSource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.displayCount ==1) {
        self.endSelectedIndex = row;
    }else if (self.displayCount == 2){
        switch (component) {
            case 0:{
                self.selectedIndex = row;
                [pickerView reloadComponent:1];
            }
                break;
            case 1:
                 self.endSelectedIndex = row;
                break;
            default:break;
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.displayCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.displayCount == 1) {
        //return NSString object
        return self.data.count;
    }else if (self.displayCount == 2){
        switch (component) {
            case 0:
                return self.data.count;
            case 1:
                return [[self getCitiesByContinent] count];
            default:break;
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.displayCount == 1) {
        id obj = (self.data)[(NSUInteger) row];
        
        // return the object if it is already a NSString,
        // otherwise, return the description, just like the toString() method in Java
        // else, return nil to prevent exception
        
        if ([obj isKindOfClass:[NSString class]])
            return obj;
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            return obj[_key1];
        }else if ([obj respondsToSelector:@selector(description)])
            return [obj performSelector:@selector(description)];
    }else if (self.displayCount == 2){
        switch (component) {
            case 0:
                return self.data[row][_key1];
            case 1:
                return [self getCitiesByContinent][row];
            default:break;
        }
    }
   
    
    return nil;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.displayCount == 1) {
        id obj = (self.data)[(NSUInteger) row];
        
        return [self attributedStringOfString:obj];
        
    }else if (self.displayCount == 2){
        switch (component) {
            case 0:
                return [self attributedStringOfString:self.data[row][_key1]];
            case 1:
                return [self attributedStringOfString:[self getCitiesByContinent][row]];
            default:break;
        }
    }
    
    return nil;
}
/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: return firstColumnWidth;
        case 1: return secondColumnWidth;
        default:break;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectZero;
        
        switch (component) {
            case 0: frame = CGRectMake(0.0, 0.0, firstColumnWidth, 32);
                break;
            case 1:
                frame = CGRectMake(0.0, 0.0, secondColumnWidth, 32);
                break;
            default:
                assert(NO);
                break;
        }

        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        if ([pickerLabel respondsToSelector:@selector(setMinimumScaleFactor:)])
            [pickerLabel setMinimumScaleFactor:0.5];
        [pickerLabel setAdjustsFontSizeToFitWidth:YES];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    
    NSAttributedString *attributeTitle = nil;
    
    if (self.displayCount == 1) {
        id obj = (self.data)[(NSUInteger) row];
        
        attributeTitle = [self attributedStringOfString:obj];
        
        if (attributeTitle == nil) {
            attributeTitle = [[NSAttributedString alloc] initWithString:@"" attributes:self.pickerTextAttributes];
        }
        pickerLabel.attributedText = attributeTitle;
        
    }else if (self.displayCount == 2){
        switch (component) {
            case 0:
            {
                attributeTitle = [self attributedStringOfString:self.data[row][_key1]];
                 pickerLabel.attributedText = attributeTitle;
            }
                break;
            case 1:
            {
                 attributeTitle = [self attributedStringOfString:[self getCitiesByContinent][row]];
                 pickerLabel.attributedText = attributeTitle;
            }
                break;
            default:break;
        }
    }
    
     return pickerLabel;
}


@end
