//
//  LTControlViewController.m
//  IMComponent
//
//  Created by lkeg on 15/12/17.
//  Copyright © 2015年 lkeg. All rights reserved.
//

#import "LTControlViewController.h"
#import "LTSegmentedControl.h"

@interface LTControlViewController ()<LTSegmentedControlDelegate>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) LTSegmentedControl *segmentControl;
@end

@implementation LTControlViewController

viewController(@"IM")

- (void)viewDidLoad {
    [super viewDidLoad];
    LTSegmentedControl *segmentZero = [[LTSegmentedControl alloc] initWithItems:@[@"A", @"B"]];
    segmentZero.backgroundColor = [UIColor orangeColor];
    segmentZero.lineSpace = 1.0;
    segmentZero.minWidth = ([UIScreen mainScreen].bounds.size.width) / 2;
    segmentZero.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width,30);
    segmentZero.segmentDelegate = self;
    [self.view addSubview:segmentZero];
    
    LTSegmentedControl *segmentTwo = [[LTSegmentedControl alloc] initWithItems:@[@"A", @"B", @"C"]];
    segmentTwo.lineSpace = 1.0;
    segmentTwo.minWidth = ([UIScreen mainScreen].bounds.size.width - 2) / 3;
    segmentTwo.frame = CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width,30);
    segmentTwo.segmentDelegate = self;
    [self.view addSubview:segmentTwo];
    
    
    self.segmentControl = [[LTSegmentedControl alloc] initWithItems:@[@"A", @"B", @"C", @"D", @"拇指医生", @"F", @"G", @"H", @"I", @"J", @"K", @"L"]];
    self.segmentControl.lineSpace = 0;
    self.segmentControl.minWidth = 40;
    self.segmentControl.maxWidth = 60;
    self.segmentControl.frame = CGRectMake(0, 190, [UIScreen mainScreen].bounds.size.width,30);
    [self.view addSubview:self.segmentControl];
    self.segmentControl.segmentDelegate = self;

    // Do any additional setup after loading the view.
    _label = [[UILabel alloc] init];
    [self.view addSubview:self.label];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 430, 60, 30)];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)tapped:(UIButton *)sender {
    NSUInteger index = random();
    index = index % (self.segmentControl.numberOfSegments + 1);
    //index = 5;
    self.segmentControl.selectedSegmentIndex = index;
}

-(void)selectedIndexChanged:(NSUInteger)index {
    self.label.text = @(index).stringValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
