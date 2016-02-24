//
//  ActionPickerView.h
//  PickerViewDemo
//
//  Created by bowen on 16/2/19.
//  Copyright © 2016年 com.mobile-kingdom. All rights reserved.
//

#import "AbstractActionSheetPicker.h"

@class ActionPickerView;
typedef void(^ActionStringDoneBlock)(ActionPickerView *picker, NSInteger selectedIndex, id selectedValue);
typedef void(^ActionStringCancelBlock)(ActionPickerView *picker);

static const float firstColumnWidth = 100.0f;
static const float secondColumnWidth = 160.0f;

@interface ActionPickerView : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

/**
 *  Create and display an action sheet picker.
 *
 *  @param title             Title label for picker
 *  @param count             returns the number of 'columns' to display.
 *  @param data              is an array of strings to use for the picker's available selection choices
 *  @param key1,key2         get component is 1...  key1...
 *  @param index             is used to establish the initially selected row;
 *  @param target            must not be empty.  It should respond to "onSuccess" actions.
 *  @param finishAction
 *  @param cancelActionOrNil cancelAction
 *  @param origin            must not be empty.  It can be either an originating container view or a UIBarButtonItem to use with a popover arrow.
 *
 *  @return  return instance of picker
 */

+ (instancetype)showPickerViewTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data  forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index target:(id)target finishAction:(SEL)finishAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;


// Create an action sheet picker, but don't display until a subsequent call to "showActionPicker".  Receiver must release the picker when ready. */
- (instancetype)initWithTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data  forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index target:(id)target finishAction:(SEL)finishAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;


+ (instancetype)showPickerViewTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data  forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlock origin:(id)origin;


- (instancetype)initWithTitle:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data  forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin;

/**
 *  numberOfComponents is 2 used key
 *  selectedKey is stair key
 *  componentKey is subset key
 */


@property (nonatomic , copy) ActionStringDoneBlock onActionSheetDone;
@property (nonatomic , copy) ActionStringCancelBlock onActionSheetCancel;

@end
