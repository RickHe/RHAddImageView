//
//  ViewController.m
//  RHAddImageView
//
//  Created by DaFenQI on 2017/9/5.
//  Copyright © 2017年 DaFenQi. All rights reserved.
//

#import "ViewController.h"
#import "RHAddImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RHAddImageView *img = [[RHAddImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100) numberOfImageForOneLine:2];
    [self.view addSubview:img];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
