//
//  ViewController.h
//  测试Demo
//
//  Created by 桑协东 on 16/7/10.
//  Copyright © 2016年 Sangxiedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowLeftViewDelegate

- (void)isShowLeftOrRight:(NSInteger )index;

@end

@interface ViewController : UIViewController

@property (nonatomic,weak)id<ShowLeftViewDelegate>delegate;

@end

