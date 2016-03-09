//
//  ViewController.m
//  learnInputBar
//
//  Created by lkeg on 15/9/4.
//  Copyright (c) 2015年 lkeg. All rights reserved.
//

#import "IMViewController.h"
#import "MessageCell.h"
#import "UITableView+FDTemplateLayoutCell.h"



@interface IMViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *message;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@end

@implementation IMViewController

viewController(@"IM")

- (void)righttaped:(UIBarButtonItem *)sender {
    UIViewController *vc = [IMViewController viewController];
    [self.navigationController pushViewController:vc animated:YES];
}

-  (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self unRegisterKeyBoardObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self unRegisterKeyBoardObserver];
    [self registerKeyBoardObserver];
}

- (void)registerKeyBoardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterKeyBoardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"A" style:UIBarButtonItemStylePlain target:self action:@selector(righttaped:)];
    

    NSArray *message = @[@"hello, joke",
                         @"人生不在年龄，贵在心理年轻；衣着不在时尚，贵在舒适合体；膳食不在丰富，贵在营养均衡；居室不在大小，贵在整洁舒畅；养生不在刻意，贵在顺其自然；锻炼不在夏冬，贵在持之以恒；作息不在早晚，贵在规律养成；情趣不在雅俗，贵在童心；朋友不在多少，贵在求一知己。",
                         @"where are from,China or US",
                          @"人生不在年龄，贵在心理年轻；衣着不在时尚，贵在舒适合体；膳食不在丰富，贵在营养均衡；居室不在大小，贵在整洁舒畅；养生不在刻意，贵在顺其自然；锻炼不在夏冬，贵在持之以恒；作息不在早晚，贵在规律养成；情趣不在雅俗，贵在童心；朋友不在多少，贵在求一知己。",
                          @"人生不在年龄，贵在心理年轻；衣着不在时尚，贵在舒适合体；膳食不在丰富，贵在营养均衡；居室不在大小，贵在整洁舒畅；养生不在刻意，贵在顺其自然；锻炼不在夏冬，贵在持之以恒；作息不在早晚，贵在规律养成；情趣不在雅俗，贵在童心；朋友不在多少，贵在求一知己。",
                         @"1234567890p",
                         @"印尼退回中日高铁方案 欲改建中速铁路】印尼经济统筹部长说，中日两国的雅加达－万隆高铁方案并不适合印尼，印尼已经退回了两国提交的工程方案。高铁列车加速到每小时350公里需耗时14分钟，而雅加达－万隆150公里沿线有5至8个站点，“火车没到每小时350公里即需刹车”。",
                         @"印尼退回中日高铁方案 欲改建中速铁路】印尼经济统筹部长说，中日两国的雅加达－万隆高铁方案并不适合印尼，印尼已经退回了两国提交的工程方案。高铁列车加速到每小时350公里需耗时14分钟，而雅加达－万隆150公里沿线有5至8个站点，“火车没到每小时350公里即需刹车”。",
                         @"印尼退回中日高铁方案 欲改建中速铁路】印尼经济统筹部长说，中日两国的雅加达－万隆高铁方案并不适合印尼，印尼已经退回了两国提交的工程方案。高铁列车加速到每小时350公里需耗时14分钟，而雅加达－万隆150公里沿线有5至8个站点，“火车没到每小时350公里即需刹车”。"
                         ];
    self.message = [NSMutableArray arrayWithArray:message];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageCell class])];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.message.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageCell class]) forIndexPath:indexPath];
    cell.message = self.message[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   CGFloat height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass([MessageCell class]) cacheByIndexPath:indexPath configuration:^(MessageCell *cell) {
        cell.message = self.message[indexPath.row];
    }];
    return MAX(height, 56);
}

- (void)scrollToBottom {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.message.count -1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userinfo = notification.userInfo;
    if (userinfo) {
        CGRect  r = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        double duration = [userinfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSInteger animationcurve = [userinfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        self.constraintBottom.constant =  -CGRectGetHeight(r);
        [UIView animateWithDuration:duration delay:0 options:1<<animationcurve animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finish) {
           
        }];
        [self scrollToBottom];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userinfo = notification.userInfo;
    if (userinfo) {
        double duration = [userinfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSInteger animationcurve = [userinfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        self.constraintBottom.constant = 0;
        [UIView animateWithDuration:duration delay:0 options:1<<animationcurve animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
