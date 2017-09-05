//
//  RHAddImageView.h
//  addImageTest
//
//  Created by hemiying on 15/12/30.
//  Copyright © 2015年 hemiying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RHAddImageView;

@protocol RHAddImageViewDelegtate <NSObject>

/**
 *  增加了图片并且frame变大
 *
 *  @param imageView
 */
- (void)RHAddImageViewFrameDidIncrease:(RHAddImageView *)imageView;
/**
 *  删除了图片并且frame变小
 *
 *  @param imageView
 */
- (void)RHAddImageViewFrameDidDecrease:(RHAddImageView *)imageView;

@end

@interface RHAddImageView : UIView

/**
 *  初始化
 *
 *  @param frame         frame
 *  @param numberOfImage 一行显示几张图片
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
      numberOfImageForOneLine:(NSUInteger)numberOfImage;

@property (nonatomic, readwrite, strong) UIImage *deleteImage;
@property (nonatomic, readwrite, strong) UIImage *addImage;
@property (nonatomic, weak) id<RHAddImageViewDelegtate> delegate;
@property (nonatomic, readonly, assign) NSUInteger currentSection; // 当前图片行数

@end
