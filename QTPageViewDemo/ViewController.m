//
//  ViewController.m
//  QTPageViewDemo
//
//  Created by jay on 2017/3/14.
//  Copyright © 2017年 subo. All rights reserved.
//

#import "ViewController.h"
#import "QTPageView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet QTPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.pageView.images=@[@"timg1.jpeg",@"timg2.jpeg",@"timg3.jpeg",@"timg4.jpeg"];
//    [self.pageView setControlPostion:QTPageViewControlPostionBottomLeft];
//    self.pageView.contentMode=UIViewContentModeScaleAspectFit;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
