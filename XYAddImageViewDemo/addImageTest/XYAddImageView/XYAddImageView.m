//
//  XYAddImageView.m
//  addImageTest
//
//  Created by hemiying on 15/12/30.
//  Copyright © 2015年 hemiying. All rights reserved.
//

#import "XYAddImageView.h"
#import "UIView+ViewController.h"

#define HMYScreenHeight [UIScreen mainScreen].bounds.size.height
#define HMYScreenWidth [UIScreen mainScreen].bounds.size.width
#define HMYDefaultRatioOfLengthWidth 4/3

static const NSUInteger kBaseImageTag = 100;
static const CGFloat kDefaultImageVerticalSpacing = 10;
static const CGFloat kMaxImageHorizontalSpacing = 18;
static const CGFloat kDefaultImageHeight = 100;
static const NSUInteger kDefaultNumberOfImageForOneLine = 4;
static const NSUInteger kMaxNumberOfImageForOneLine = 11;

const NSString *kAddImageNotification = @"kAddImageNotification";
const NSString *kDeleteImageNotification = @"kDeleteImageNotification";

@interface XYAddImageView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSUInteger _imageCount;                 // 图片数量
    UIButton *_addImageBtn;                 // 添加按钮
    CGFloat _viewHeight;                    // 视图高度
    CGFloat _imageWidth;                    // 视图宽度
    CGFloat _imageHeight;                   // 视图高度
    NSMutableArray *_selectedImageArray;    // 选中图片存在本数组
    NSMutableArray *_tagArray;              // 图片的删除键的tag值数组
    NSUInteger _numberOfImageForOneLine;    // 一行图片数量
}

@property (nonatomic, readwrite, assign) NSUInteger currentSection; // 当前图片行数

@end

@implementation XYAddImageView
#pragma mark - Init Self
/**
 *  初始化
 *
 *  @param frame         frame
 *  @param numberOfImage 一行显示几张图片
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
      numberOfImageForOneLine:(NSUInteger)numberOfImage {
    if (self = [super initWithFrame:frame]) {
        [self p_initData:numberOfImage];
        [self p_initSubViews];
    }
    return self;
}

/**
 *  初始化 默认一行显示4个
 *
 *  @param frame         frame
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfImageForOneLine:kDefaultNumberOfImageForOneLine];
}

/**
 *  初始化 默认一行显示4个,frame 从(0, 0)开始
 *
 *  @return self
 */
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, HMYScreenWidth, kDefaultImageHeight) numberOfImageForOneLine:kDefaultNumberOfImageForOneLine];
}

#pragma mark - Private
- (void)p_initSubViews {
    // 添加按钮
    _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImageBtn setBackgroundImage:_addImage forState:UIControlStateNormal];
    _addImageBtn.frame = CGRectMake((kMaxImageHorizontalSpacing - _numberOfImageForOneLine), 0, _imageWidth, _imageHeight);
    [_addImageBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addImageBtn];
}

- (void)p_initData:(NSUInteger)numberOfImage {
    _deleteImage = [UIImage imageNamed:@"XYdeletepicyure"];
    _addImage = [UIImage imageNamed:@"XYaddpicture"];
    NSParameterAssert(numberOfImage < kMaxNumberOfImageForOneLine);
    _numberOfImageForOneLine = numberOfImage;
    _imageWidth = (HMYScreenWidth - (numberOfImage + 1) * (kMaxImageHorizontalSpacing - numberOfImage)) / numberOfImage;
    _imageHeight = _imageWidth * HMYDefaultRatioOfLengthWidth;
    CGRect rect = self.frame;
    rect.size.height = _imageHeight;
    _selectedImageArray = [NSMutableArray new];
    _tagArray = [NSMutableArray new];
}



#pragma mark - Set Image
- (void)setAddImage:(UIImage *)addImage {
    _addImage = addImage;
    [_addImageBtn setBackgroundImage:_addImage forState:UIControlStateNormal];
}

#pragma mark - ButtonActions
/**
 *  删除图片
 *
 *  @param btn
 */
- (void)deleteImage:(UIButton *)btn {
    NSUInteger flag = 0;
    // 移除imageView
    for (int index = 0; index < _tagArray.count; index++) {
        if (btn.tag == [_tagArray[index] integerValue]) {
            UIImageView *image = [self viewWithTag:[_tagArray[index] integerValue]];
            [image removeFromSuperview];
            flag = index;
            [_selectedImageArray removeObjectAtIndex:index];
            [_tagArray removeObjectAtIndex:index];
        }
    }
    // 若图片移除完了
    if (_tagArray.count == 0) {
        _addImageBtn.frame = CGRectMake((kMaxImageHorizontalSpacing - _numberOfImageForOneLine) , 0, _imageWidth, _imageHeight);
        return;
    }
    // 更新移除完imageView的布局
    [self p_layoutSubviewsAfterDeleteImage];
}

/**
 *  添加图片按钮事件
 *
 *  @param btn
 */
- (void)addImage:(UIButton *)btn {
    //调用相机的相关功能
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction* OpenPhotoAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action){
        [self p_takePhoto];
    }];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action){
        [self p_getLocalPhoto];
        
    }];
    [alertController addAction:fromPhotoAction];
    [alertController addAction:OpenPhotoAction];
    [alertController addAction:cancelAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
    
    // 兼容ipad
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = _addImageBtn;
        popover.sourceRect = self.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
}

#pragma mark - ImageManipulate
/**
 *  打开本地相册
 */
- (void)p_getLocalPhoto {
    // 本地相册
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    [self.viewController presentViewController:pick animated:YES completion:nil];
}

/**
 *  拍照
 */
- (void)p_takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.delegate = self;
        pick.allowsEditing = YES;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:pick animated:YES completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
#pragma clang diagnostic pop
    }
}

/**
 *  移除图片后更新布局
 */
- (void)p_layoutSubviewsAfterDeleteImage {
    for (int index = 0; index < _tagArray.count; index++)
    {
        UIImageView *image = [self viewWithTag:[_tagArray[index] integerValue]];
        NSUInteger imageRow = index % _numberOfImageForOneLine;
        NSUInteger imageSection = index / _numberOfImageForOneLine;
        image.frame = CGRectMake((kMaxImageHorizontalSpacing - _numberOfImageForOneLine) + imageRow * (_imageWidth + (kMaxImageHorizontalSpacing - _numberOfImageForOneLine)), imageSection * (_imageHeight + kDefaultImageVerticalSpacing), _imageWidth, _imageHeight);
        NSUInteger btnRow = (index + 1) % _numberOfImageForOneLine;
        NSUInteger btnSection = (index + 1) / _numberOfImageForOneLine;
        _addImageBtn.frame = CGRectMake((kMaxImageHorizontalSpacing - _numberOfImageForOneLine) + btnRow * (_imageWidth + (kMaxImageHorizontalSpacing - _numberOfImageForOneLine)), btnSection * (_imageHeight + kDefaultImageVerticalSpacing), _imageWidth, _imageHeight);
        
        CGRect frame = self.frame;
        frame.size.height = _addImageBtn.frame.origin.y + _imageHeight + kDefaultImageVerticalSpacing;
        self.frame = frame;
        
        if (_currentSection - 1 == btnSection) {
            if ([_delegate respondsToSelector:@selector(XYAddImageViewFrameDidDecrease:)]) {
                [_delegate XYAddImageViewFrameDidDecrease:self];
            }
        }
        _currentSection = btnSection;
    }
}

/**
 *  添加图片完成后更新布局
 */
- (void)p_layoutSubviewsAfterAddImage {
    static int index = 1;
    _imageCount = _selectedImageArray.count;
    NSUInteger imageRow = (_imageCount - 1) % _numberOfImageForOneLine;
    NSUInteger imageSection = (_imageCount - 1) / _numberOfImageForOneLine;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((kMaxImageHorizontalSpacing - _numberOfImageForOneLine) + imageRow * (_imageWidth + (kMaxImageHorizontalSpacing - _numberOfImageForOneLine)), imageSection * (_imageHeight + (kMaxImageHorizontalSpacing - _numberOfImageForOneLine)), _imageWidth, _imageHeight)];
    image.image = _selectedImageArray[_selectedImageArray.count - 1];
    image.tag = kBaseImageTag + index;
    [_tagArray addObject:@(image.tag)];
    image.userInteractionEnabled = YES;
    [self addSubview:image];

    UIButton *_deleteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteImageBtn setBackgroundImage:_deleteImage forState:UIControlStateNormal];
    _deleteImageBtn.frame = CGRectMake(image.frame.size.width - 6, -6, 12, 12);
    [_deleteImageBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    _deleteImageBtn.tag = kBaseImageTag + index;
    index++;
    [image addSubview:_deleteImageBtn];
    
    NSUInteger btnRow = _imageCount % _numberOfImageForOneLine;
    NSUInteger btnSection = _imageCount / _numberOfImageForOneLine;
    _addImageBtn.frame = CGRectMake((kMaxImageHorizontalSpacing - _numberOfImageForOneLine) + btnRow * (_imageWidth + (kMaxImageHorizontalSpacing - _numberOfImageForOneLine)), btnSection * (_imageHeight + kDefaultImageVerticalSpacing), _imageWidth, _imageHeight);
    CGRect frame = self.frame;
    frame.size.height = _addImageBtn.frame.origin.y + _imageHeight + kDefaultImageVerticalSpacing;
    self.frame = frame;
    if (_currentSection + 1 == btnSection) {
        if ([_delegate respondsToSelector:@selector(XYAddImageViewFrameDidIncrease:)]) {
            [_delegate XYAddImageViewFrameDidIncrease:self];
        }
    }
    _currentSection = btnSection;
}

#pragma mark - Hittest
/**
 *  子视图在父视图外面部分的事件响应
 *
 *  @param point
 *  @param event
 *
 *  @return 处理的视图
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    // 首先获取叉叉按钮
    UIView *buttonView = [UIView new];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            for (UIView *subSubview in subview.subviews) {
                if ([subSubview isKindOfClass:[UIButton class]]) {
                    CGRect rect = [self.superview convertRect:subSubview.frame fromView:subview];
                    CGPoint tPoint = [self.superview convertPoint:point fromView:self];
                    if (CGRectContainsPoint(rect, tPoint)) {
                        buttonView = subSubview;
                    }
                }
            }
        }
    }
    // 若view在self外面
    if (view == nil) {
        view = buttonView;
    }
    // 若view在self里面但是在superview外面
    if ([view isKindOfClass:[self class]]) {
        CGPoint tPoint = [buttonView convertPoint:point fromView:self];
        if (CGRectContainsPoint(buttonView.bounds, tPoint)) {
            view = buttonView;
        } else {
            // 正常
        }
    }
    return view;
}


#pragma mark - UINavigationControllerDelegate
/**
 *  照片获取完成
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@", info);
    [_selectedImageArray addObject: info[@"UIImagePickerControllerOriginalImage"]];
    [self p_layoutSubviewsAfterAddImage];
   [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  取消获取照片
 *
 *  @param picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
