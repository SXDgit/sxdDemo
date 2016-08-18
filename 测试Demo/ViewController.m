//
//  ViewController.m
//  测试Demo
//
//  Created by 桑协东 on 16/7/10.
//  Copyright © 2016年 Sangxiedong. All rights reserved.
//
#import "ViewController.h"
#import "AndyScrollView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    UIPanGestureRecognizer *pan;
}
@property (nonatomic) AndyScrollView *scroll;
@property (nonatomic) UIButton *leftBtn;
@property (nonatomic) UIButton *rightBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
}

-(void)initUI {
    
    [self.view addSubview:self.scroll];
    [self.navigationController.navigationBar addSubview:self.leftBtn];
    [self.navigationController.navigationBar addSubview:self.rightBtn];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}
-(UIScrollView *)scroll {
    if (!_scroll)
    {
        _scroll = [[AndyScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scroll.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.delegate = self;
        _scroll.bounces = NO;
    }
    return _scroll;
}

-(UIButton *)leftBtn {
    if (!_leftBtn)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(10, 0, 40, 44);
        [_leftBtn setTitle:@"左击" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag = 100;
    }
    return _leftBtn;
}

-(UIButton *)rightBtn {
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH-50, 0, 40, 44);
        [_rightBtn setTitle:@"右击" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.tag = 101;
    }
    return _rightBtn;
}

-(void)buttonClick:(UIButton *)btn {
    self.delegate = _scroll;
    NSInteger index = btn.tag-100;
    [self.delegate isShowLeftOrRight:index];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
