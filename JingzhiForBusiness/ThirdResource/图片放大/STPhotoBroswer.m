//
//  ；
//  STPhotoBroeser
//
//  Created by StriEver on 16/3/16.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "STPhotoBroswer.h"
#import "STImageVIew.h"
#define MAIN_BOUNDS   [UIScreen mainScreen].bounds
#define Screen_Width  [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
//图片距离左右 间距
#define SpaceWidth    10
@interface STPhotoBroswer ()<STImageViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * numberLabel;
@end
@implementation STPhotoBroswer
- (instancetype)initWithImageArray:(NSArray *)imageArray currentIndex:(NSInteger)index{
    if (self == [super init]) {
        self.imageArray = imageArray;
        self.index = index;
        [self setUpView];
    }
    return self;
}
//--getter
- (void)makescrollView{
           }
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Screen_Width, 40)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor greenColor];
        _numberLabel.text = [NSString stringWithFormat:@"%d/%d",self.index ,self.imageArray.count];
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}
- (void)setUpView{
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    //这里
    _scrollView.contentSize = CGSizeMake((Screen_Width + 2*SpaceWidth) * self.imageArray.count, Screen_Height);
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;

    int index = 0;
    
    for (NSString * str in self.imageArray) {
        STImageVIew * imageView = [[STImageVIew alloc]init];
        imageView.delegate = self;
//        imageView.contentMode =UIViewContentModeScaleToFill;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        

        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
        imageView.tag = index;
        [_scrollView addSubview:imageView];
        index ++;
            }

    [self addSubview:_scrollView];
    [self numberLabel];

}
#pragma mark ---UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/Screen_Width;
    self.index = index;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:@"STImageVIew"]) {
            STImageVIew * imageView = (STImageVIew *) obj;
            [imageView resetView];
        }
                }];
    self.numberLabel.text = [NSString stringWithFormat:@"%d/%d",self.index+1,self.imageArray.count];
    

    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //主要为了设置每个图片的间距，并且使 图片铺满整个屏幕，实际上就是scrollview每一页的宽度是 屏幕宽度+2*Space  居中。图片左边从每一页的 Space开始，达到间距且居中效果。
    _scrollView.bounds = CGRectMake(0, 0, Screen_Width + 2 * SpaceWidth,Screen_Height);
    _scrollView.center = self.center;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(SpaceWidth + (Screen_Width+20) * idx, 0,Screen_Width,Screen_Height);
    }];
    _scrollView.contentOffset = CGPointMake((Screen_Width+20)* (self.index-1), 0);

}
- (void)show{
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [window addSubview:self];
    self.transform = CGAffineTransformMakeScale(0, 0);

    [UIView animateWithDuration:.3 animations:^{
        self.transform = CGAffineTransformIdentity;

    }];
}
- (void)dismiss{
     self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0000000001, 0.00000001);
    }completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}
#pragma mark ---STImageViewDelegate
- (void)stImageVIewSingleClick:(STImageVIew *)imageView{
    [self dismiss];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com