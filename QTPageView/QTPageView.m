//
//  QTPageView.m
//  QTPageViewDemo
//
//  Created by jay on 2017/3/14.
//  Copyright © 2017年 subo. All rights reserved.
//

#import "QTPageView.h"

@interface QTPageView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scorllView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIImageView *currentImgView;
@property (nonatomic,strong) UIImageView *otherImgView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger nextIndex;
@end


static CGFloat defaultTime=5;
@implementation QTPageView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initView];
}

- (CGFloat)scrollViewH{
    return self.frame.size.height;
}

- (CGFloat)scrollViewW{
    return self.frame.size.width;
}

- (void)initView{
    self.scorllView=[[UIScrollView alloc]initWithFrame:self.bounds];
    self.scorllView.contentSize=CGSizeMake(3*[self scrollViewW], [self scrollViewH]);
    self.scorllView.contentOffset=CGPointMake([self scrollViewW], 0);
    self.scorllView.showsVerticalScrollIndicator=NO;
    self.scorllView.showsHorizontalScrollIndicator=NO;
    self.scorllView.pagingEnabled=YES;
    self.scorllView.delegate=self;
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgView)];
    [self.scorllView addGestureRecognizer:singleTap];
    [self addSubview:self.scorllView];
    
    self.currentImgView=[[UIImageView alloc]initWithFrame:CGRectMake([self scrollViewW], 0, [self scrollViewW], [self scrollViewH])];
    [self.scorllView addSubview:self.currentImgView];
    
    self.otherImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self scrollViewW], [self scrollViewH])];
    [self.scorllView addSubview:self.otherImgView];
    
    self.pageControl=[[UIPageControl alloc]init];
    self.pageControl.currentPage=0;
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    [self addSubview:self.pageControl];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer=nil;
}

- (void)startTimer{
    //如果只有一张图片 不需要启动定时器
    if (_images.count<=1) return;
    if (self.timer) {
        [self stopTimer];
    }
    NSTimeInterval time=_time<2?defaultTime:_time;
    self.timer=[NSTimer timerWithTimeInterval:time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 点击图片 block和delegate都可 block优先级高
 */
- (void)tapImgView{
    if (self.tapImgBlock) {
        self.tapImgBlock(self.currentIndex);
    }else{
        if ([self.delegate respondsToSelector:@selector(tapPageView:imgIndex:)]) {
            [self.delegate tapPageView:self imgIndex:self.currentIndex];
        }
    }
}

/**
 自动轮播
 */
- (void)nextPage{
    [self.scorllView setContentOffset:CGPointMake(2*[self scrollViewW], 0) animated:YES];
}

/**
 切换到下一页
 */
- (void)changeToNextPage{
    //重置偏移量
    self.scorllView.contentOffset=CGPointMake([self scrollViewW], 0);
    //交换数据
    self.currentImgView.image=self.otherImgView.image;
    self.currentIndex=self.nextIndex;
    self.pageControl.currentPage=self.currentIndex;
}

- (void)setImages:(NSArray *)images{
    _images=images;
    self.currentImgView.image=[UIImage imageNamed:self.images[self.currentIndex]];
    self.pageControl.numberOfPages=self.images.count;
    CGSize size=[self.pageControl sizeForNumberOfPages:self.images.count];
    self.pageControl.frame=CGRectMake(([self scrollViewW]-size.width)/2, [self scrollViewH]-size.height, size.width, size.height);
    self.pageControl.hidden=images.count==1;
    [self startTimer];
}

/**
 设置轮播时间
 @param time 轮播时间
 */
- (void)setTime:(NSTimeInterval)time{
    _time=time;
    [self startTimer];
}

- (void)setControlPostion:(QTPageViewControlPostion)controlPostion{
    CGSize controlSize=[_pageControl sizeForNumberOfPages:_images.count];
    CGFloat margin=10;
    CGRect controlF=_pageControl.frame;
    switch (controlPostion) {
        case QTPageViewControlPostionHide:
            self.pageControl.hidden=YES;
            break;
        case QTPageViewControlPostionBottomLeft:
            controlF.origin.x=margin;
            _pageControl.frame=controlF;
            break;
        case QTPageViewControlPostionBottomRight:
            controlF.origin.x=[self scrollViewW]-controlSize.width-margin;
            _pageControl.frame=controlF;
            break;
        default:
            break;
    }
}

/**
 设置分页控件指示器延
 不设则显示默认颜色
 @param pageColor 其他页面的颜色
 @param currentPageColor 当前页码的颜色
 */
- (void)setPageColor:(UIColor *)pageColor currentPageColor:(UIColor *)currentPageColor{
    self.pageControl.pageIndicatorTintColor=pageColor;
    self.pageControl.currentPageIndicatorTintColor=currentPageColor;
}

/**
 设置图片填充模式
 @param contentMode 填充模式
 */
- (void)setContentMode:(UIViewContentMode)contentMode{
    _contentMode=contentMode;
    self.currentImgView.contentMode=contentMode;
    self.otherImgView.contentMode=contentMode;
}

#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetX=scrollView.contentOffset.x;
    if (offSetX>[self scrollViewW]) {
        //向左
        self.otherImgView.frame=CGRectMake(CGRectGetMaxX(_currentImgView.frame), 0, [self scrollViewW], [self scrollViewH]);
        self.nextIndex=self.currentIndex+1;
        if (self.nextIndex>=self.images.count) {
            self.nextIndex=0;
        }
        if (offSetX>=2*[self scrollViewW]) {
            [self changeToNextPage];
        }
    }else if(offSetX<[self scrollViewW]){
        //向右
        self.otherImgView.frame=CGRectMake(0, 0, [self scrollViewW], [self scrollViewH]);
        self.nextIndex=self.currentIndex-1;
        if (self.nextIndex<=0) {
            self.nextIndex=self.images.count-1;
        }
        if (offSetX<=0) {
            [self changeToNextPage];
        }
    }
    self.otherImgView.image=[UIImage imageNamed:[self.images objectAtIndex:self.nextIndex]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
@end
