//
//  AndyScrollView.m
//  测试Demo
//
//  Created by 桑协东 on 16/3/22.
//  Copyright © 2016年 Sangxiedong. All rights reserved.
//

#import "AndyScrollView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define showViewMaxWidth 100 //拖拽出来的View宽

#define maxWidth 200 //可拖动最大距离


@interface AndyScrollView ()<UIGestureRecognizerDelegate> {
    CGPoint initialLeftViewPosition;     //左视图初始位置
    CGPoint initialRightViewPosition;    //右视图初始位置
}

@property(nonatomic,strong)UIView *backView;// 左视图的背景视图
@property(nonatomic,strong)UIView *bgView; // 右视图的背景视图

@end

@implementation AndyScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    [self addGestureRecognizer];
    
}

// 添加屏幕边缘手势
-(void)addGestureRecognizer {
    
    self.leftScreenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleScreenEdgePanGesture:)];
    self.leftScreenEdgePan.edges = UIRectEdgeLeft;
    [self addGestureRecognizer: self.leftScreenEdgePan];
    self.rightScreenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleScreenEdgePanGesture:)];
    self.rightScreenEdgePan.edges = UIRectEdgeRight;
    [self addGestureRecognizer:self.rightScreenEdgePan];
    
}

-(UIView *)leftView {
    if (!_leftView) {
        _leftView = [[LeftView alloc]initWithFrame:CGRectMake(-maxWidth, 0, maxWidth, self.frame.size.height)];
        _leftView.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(PanGesLeftView:)];
        [_leftView addGestureRecognizer:pan];
    }
    return _leftView;
}

// 左视图上的滑动手势
- (void)PanGesLeftView:(UIPanGestureRecognizer *)ges {
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        //获取leftView初始位置
        initialLeftViewPosition.x = self.leftView.center.x;
    }
    
    CGPoint point = [ges translationInView:self];
    
    if (point.x <= 0 && point.x <= maxWidth) {
        _leftView.center = CGPointMake(initialLeftViewPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth + point.x) / (2* maxWidth));
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        if ( - point.x <= showViewMaxWidth) {
            
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, self.frame.size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                
            }];
            
        }else if ( - point.x > showViewMaxWidth &&  - point.x <= maxWidth)
        {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, self.frame.size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
            }];
        }
    }
}

-(UIView *)rightView {
    if (!_rightView) {
        _rightView = [[RightView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, maxWidth, self.frame.size.height)];
        _rightView.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(PanGesRightView:)];
        [_rightView addGestureRecognizer:pan];
    }
    return _rightView;
}

// 右视图上的滑动手势
- (void)PanGesRightView:(UIPanGestureRecognizer *)ges {
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        //获取rightView初始位置
        initialLeftViewPosition.x = self.rightView.center.x;
    }
    
    CGPoint point = [ges translationInView:self];
    
    if (point.x >= 0 && point.x <= maxWidth) {
        _rightView.center = CGPointMake(initialLeftViewPosition.x + point.x , _rightView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth - point.x) / (2* maxWidth));
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        if ( point.x <= showViewMaxWidth) {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _rightView.frame = CGRectMake(SCREEN_WIDTH-maxWidth, 0, maxWidth, self.frame.size.height);
                _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                
            }];
        }else if ( point.x > showViewMaxWidth &&  point.x <= maxWidth)
        {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _rightView.frame = CGRectMake(SCREEN_WIDTH, 0, maxWidth, self.frame.size.height);
                _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_bgView removeFromSuperview];
            }];
        }
    }
}

// 调用左右边缘滑动的方法
-(void)handleScreenEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)sender {
    if (self.leftScreenEdgePan.edges) {
        [self dragLeftView:sender];
    }
    if (self.rightScreenEdgePan.edges) {
        [self dragRightView:sender];
    }

}

// 屏幕边缘滑动左视图
-(void)dragLeftView:(UIScreenEdgePanGestureRecognizer *)sender {
    [_leftView removeFromSuperview];
    [_backView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backView];
    [window addSubview:self.leftView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //获取leftView初始位置
        initialLeftViewPosition.x = self.leftView.center.x;
    }
    
    CGPoint point = [sender translationInView:self]; //在指定坐标系移动
    
    if (point.x >= 0 && point.x <= maxWidth) {
        _leftView.center = CGPointMake(initialLeftViewPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth + point.x) / (2* maxWidth) - 0.5);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (point.x <= showViewMaxWidth) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, self.frame.size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
            }];
            
        }else if (point.x > showViewMaxWidth && point.x <= maxWidth)
        {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, self.frame.size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

// 屏幕边缘滑动右视图
- (void)dragRightView:(UIScreenEdgePanGestureRecognizer *)sender {
    
    [self.rightView removeFromSuperview];
    [self.bgView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self.rightView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        //获取rightView初始位置
        initialRightViewPosition.x = self.rightView.center.x;
    }
    
    CGPoint point = [sender translationInView:self]; //在指定坐标系移动
    
    if (point.x <= 0 && -point.x <= maxWidth) {
        _rightView.center = CGPointMake(initialRightViewPosition.x + point.x , _rightView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth - point.x) / (2* maxWidth) - 0.5);
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (-point.x <= showViewMaxWidth) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _rightView.frame = CGRectMake(SCREEN_WIDTH, 0, maxWidth, self.frame.size.height);
                _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_bgView removeFromSuperview];
            }];
            
        }else if (-point.x > showViewMaxWidth && -point.x <= maxWidth)
        {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _rightView.frame = CGRectMake(SCREEN_WIDTH-maxWidth, 0, maxWidth, self.frame.size.height);
                _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

// 右视图滑出后的背景视图bgView
-(UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTapGes:)];
        [_bgView addGestureRecognizer:tap];
        UIPanGestureRecognizer *backPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(bgPanGes:)];
        [_bgView addGestureRecognizer:backPan];
    }
    return _bgView;
}

// 点击bgView
-(void)bgViewTapGes:(UITapGestureRecognizer *)ges
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _rightView.frame = CGRectMake(SCREEN_WIDTH, 0, maxWidth, self.frame.size.height);
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
    }];
    
}

// 滑动bgView
-(void)bgPanGes:(UIPanGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        //获取leftView初始位置
        initialLeftViewPosition.x = self.rightView.center.x;
    }
    
    CGPoint point = [ges translationInView:self];
    
    if (point.x >= 0 && point.x <= maxWidth) {
        _rightView.center = CGPointMake(initialLeftViewPosition.x + point.x , _rightView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth - point.x) / (2* maxWidth));
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        if ( point.x <= showViewMaxWidth) {
            
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _rightView.frame = CGRectMake(SCREEN_WIDTH-maxWidth, 0, maxWidth, self.frame.size.height);
                _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                
            }];
            
        }else if ( point.x > showViewMaxWidth &&  point.x <= maxWidth)
        {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _rightView.frame = CGRectMake(SCREEN_WIDTH, 0, maxWidth, self.frame.size.height);
                _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_bgView removeFromSuperview];
            }];
        }
    }
}

// 左视图滑出后的背景视图backView
-(UIView *)backView
{
    if (!_backView)
    {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        UIPanGestureRecognizer *backPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backPanGes:)];
        [_backView addGestureRecognizer:backPan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapGes:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

// 滑动backView
-(void)backPanGes:(UIPanGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        //获取leftView初始位置
        initialLeftViewPosition.x = self.leftView.center.x;
    }
    
    CGPoint point = [ges translationInView:self];
    
    if (point.x <= 0 && point.x <= maxWidth) {
        _leftView.center = CGPointMake(initialLeftViewPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (maxWidth + point.x) / (2* maxWidth));
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        if ( - point.x <= showViewMaxWidth) {
            
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, maxWidth, self.frame.size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            } completion:^(BOOL finished) {
                
            }];
            
        }else if ( - point.x > showViewMaxWidth &&  - point.x <= maxWidth)
        {
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, self.frame.size.height);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
            }];
        }
    }
}

// 点击backView
-(void)backViewTapGes:(UITapGestureRecognizer *)ges
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _leftView.frame = CGRectMake(-maxWidth, 0, maxWidth, self.frame.size.height);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];

}

// 判断点击的按钮
- (void)isShowLeftOrRight:(NSInteger )index{
    if (index == 0) {
        [self showLeftView];
    }else {
        [self showRightView];
    }
    
    
}
// 点击按钮 显示左视图
- (void)showLeftView{
    [_leftView removeFromSuperview];
    [_backView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backView];
    [window addSubview:self.leftView];
    [UIView animateWithDuration:0.35f animations:^{
        _leftView.frame = CGRectMake(0, 0, maxWidth, self.frame.size.height);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    }];
    
}

// 点击按钮 显示右视图
- (void)showRightView {
    [_rightView removeFromSuperview];
    [_bgView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self.rightView];
    [UIView animateWithDuration:0.35f animations:^{
        _rightView.frame = CGRectMake(SCREEN_WIDTH-maxWidth, 0, maxWidth, self.frame.size.height);
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    }];
}

#pragma mark- 返回YES，则可以同时接收两个事件运行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self panShowLeftView:gestureRecognizer])
    {
        return YES;
    }
    return NO;
}
#pragma mark - 解决手势冲突
- (BOOL)panShowLeftView:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer)
    {
        UIScreenEdgePanGestureRecognizer *panGes = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [panGes translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state)
        {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x < 0 && location.x < self.frame.size.width && self.contentOffset.x <= 0)
            {
                return YES;
            }
            
        }
        
    }
    return NO;
    
}



@end
