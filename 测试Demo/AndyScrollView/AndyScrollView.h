//
//  AndyScrollView.h
//  测试Demo
//
//  Created by 桑协东 on 16/3/22.
//  Copyright © 2016年 Sangxiedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftView.h"
#import "RightView.h"
#import "ViewController.h"

@interface AndyScrollView : UIScrollView<ShowLeftViewDelegate>

@property(nonatomic)LeftView *leftView;
@property(nonatomic)RightView *rightView;
@property(nonatomic)UIPanGestureRecognizer *pan;
@property(nonatomic)UIScreenEdgePanGestureRecognizer *leftScreenEdgePan;
@property(nonatomic)UIScreenEdgePanGestureRecognizer *rightScreenEdgePan;
- (void)isShowLeftOrRight:(NSInteger )index;

@end
