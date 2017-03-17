//
//  QTPageView.h
//  QTPageViewDemo
//
//  Created by jay on 2017/3/14.
//  Copyright © 2017年 subo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QTPageView;

typedef enum {
    QTPageViewControlPostionDefault,//BottomCenter
    QTPageViewControlPostionHide,
    QTPageViewControlPostionBottomLeft,//左下
    QTPageViewControlPostionBottomRight,//右下
} QTPageViewControlPostion;


@protocol QTPageViewDelegate <NSObject>

@optional
- (void)tapPageView:(QTPageView *)pageView imgIndex:(NSInteger)imgIdnex;

@end

@interface QTPageView : UIView
/*图片地址集合*/
@property (nonatomic,strong) NSArray *images;
/*轮播时间(秒为单位) 默认5s 至少2s*/
@property (nonatomic,assign)  NSTimeInterval time;
/*设置图片的内容模式，默认为系统默认模式*/
@property (nonatomic, assign) UIViewContentMode contentMode;
/*分页控件显示的位置*/
@property (nonatomic,assign) QTPageViewControlPostion   controlPostion;
@property (nonatomic,weak) id<QTPageViewDelegate> delegate;
@property (nonatomic,copy) void(^tapImgBlock)(NSInteger index);
/**
 设置分页控件指示器延
 不设则显示默认颜色
 @param pageColor 其他页面的颜色
 @param currentPageColor 当前页码的颜色
 */
- (void)setPageColor:(UIColor *)pageColor currentPageColor:(UIColor *)currentPageColor;
/**
 停止定时器
 */
- (void)stopTimer;
/**
 开启定时器
 */
- (void)startTimer;
@end
