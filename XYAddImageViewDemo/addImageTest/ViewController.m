//
//  ViewController.m
//  addImageTest
//
//  Created by hemiying on 15/12/30.
//  Copyright © 2015年 hemiying. All rights reserved.
//

#import "ViewController.h"
#import "XYAddImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    XYAddImageView *img = [[XYAddImageView alloc] initWithFrame:CGRectMake(100, 100, self.view.frame.size.width, 10)  numberOfImageForOneLine:2];
    [self.view addSubview:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
