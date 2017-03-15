//
//  QTPageView.h
//  QTPageViewDemo
//
//  Created by jay on 2017/3/14.
//  Copyright © 2017年 subo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTPageView : UIView
/*图片地址集合*/
@property (nonatomic,strong) NSArray *images;
/*轮播时间(秒为单位) 默认5s 至少2s*/
@property (nonatomic,assign)  NSTimeInterval time;
/*设置图片的内容模式，默认为系统默认模式*/
@property (nonatomic, assign) UIViewContentMode contentMode;
/*分页控件显示的位置*/
@property (nonatomic,assign) CGPoint pageControlPosition;
/**
 设置分页控件指示器延
 不设则显示默认颜色
 @param pageColor 其他页面的颜色
 @param currentPageColor 当前页码的颜色
 */
- (void)setPageColor:(UIColor *)pageColor currentPageColor:(UIColor *)currentPageColor;
@end
