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
#import "IMInputBar.h"

const NSInteger static MaxLineNumber = 8;
const NSInteger static MinLineNumber = 1;

typedef NS_ENUM(NSInteger, IMInputBarState) {
    IMInputBarStateDefault,
    IMInputBarStateKeyBoard,
    IMInputBarStateMedia,
     IMInputBarStateMedia2
};


@interface IMViewController ()<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet IMInputBar *inputBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *inputTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) UIView *inputViewOne;
@property (strong, nonatomic) UIView *inputViewTwo;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (nonatomic, assign) IMInputBarState imInputState;

@end

@implementation IMViewController

viewController(@"IM")

- (UIView *)inputViewOne {
    if (!_inputViewOne) {
        CGRect frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        _inputViewOne = [[UIView alloc] initWithFrame:frame];
        _inputViewOne.backgroundColor = [UIColor orangeColor];
    }
    return _inputViewOne;
}


- (UIView *)inputViewTwo {
    if (!_inputViewTwo) {
        CGRect frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120);
        _inputViewTwo = [[UIView alloc] initWithFrame:frame];
        _inputViewTwo.backgroundColor = [UIColor greenColor];
    }
    return _inputViewTwo;
}

- (IBAction)taoemojed:(id)sender {
    if (self.imInputState != IMInputBarStateMedia2) {
        self.imInputState = IMInputBarStateMedia2;
    } else {
        self.imInputState = IMInputBarStateDefault;
    }
}

- (IBAction)inputypedtapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.imInputState = IMInputBarStateDefault;
        self.voiceButton.hidden = NO;
        self.height.constant = 46;
        self.textView.hidden = YES;
    } else {
        self.voiceButton.hidden = YES;
        self.textView.hidden = NO;
         self.imInputState = IMInputBarStateKeyBoard;
    }
    [UIView animateWithDuration:0.23 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)tapmoreed:(id)sender {
    if (self.imInputState != IMInputBarStateMedia) {
        self.imInputState = IMInputBarStateMedia;
    } else {
        self.imInputState = IMInputBarStateDefault;
    }
}

- (void)setImInputState:(IMInputBarState)imInputState {
    if (imInputState == IMInputBarStateDefault) {
        self.height2.constant = 0;
        [UIView animateWithDuration:.23 delay:0 options:7 << 16 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        [self.textView resignFirstResponder];
        _imInputState = IMInputBarStateDefault;
        return ;
    }
    if (_imInputState == imInputState) {
        return ;
    }
    //收
    switch (imInputState) {
        case IMInputBarStateKeyBoard: {
            [self.textView becomeFirstResponder];
        }
            break;
        case IMInputBarStateMedia: {
            [self.textView resignFirstResponder];
            [self.inputView addSubview:self.inputViewOne];
            self.height2.constant = 200;
            [UIView animateWithDuration:.23 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                    
            }];
        }
            break;
        case IMInputBarStateMedia2: {
            [self.textView resignFirstResponder];
            [self.inputView addSubview:self.inputViewTwo];
            self.height2.constant = 120;
            [UIView animateWithDuration:.23 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                    
            }];
            
        }
            break;
        default:
            break;
    }
    [self scrollToBottom];
    _imInputState = imInputState;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.imInputState = IMInputBarStateDefault;
}

- (void)righttaped:(UIBarButtonItem *)sender {
    self.imInputState = IMInputBarStateDefault;
    UIViewController *vc = [IMViewController viewController];
    [self.navigationController pushViewController:vc animated:YES];
}

-  (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self unRegisterKeyBoardObserver];
    self.imInputState = IMInputBarStateDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self unRegisterKeyBoardObserver];
    [self registerKeyBoardObserver];
    self.imInputState = IMInputBarStateDefault;
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
    self.messages = [NSMutableArray arrayWithArray:message];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageCell class])];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    

    
    self.textView.scrollsToTop = NO;
    self.textView.clipsToBounds = YES;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addGestureRecognizer:tapGesture];
    self.imInputState = IMInputBarStateDefault;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageCell class]) forIndexPath:indexPath];
    cell.message = self.messages[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   CGFloat height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass([MessageCell class]) cacheByIndexPath:indexPath configuration:^(MessageCell *cell) {
        cell.message = self.messages[indexPath.row];
    }];
    return MAX(height, 56);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSInteger lineNumbers = ceilf(textView.contentSize.height / textView.font.lineHeight);
    if (lineNumbers > MaxLineNumber) {
        self.textView.scrollEnabled = YES;
        return;
    }
    
    if (fabs(textView.frame.size.height - textView.contentSize.height) >= 10.0) {
        self.height.constant = textView.contentSize.height + 5;
        [UIView animateWithDuration:0.23 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger lineNumbers = ceilf(textView.contentSize.height / textView.font.lineHeight);
    if (lineNumbers > MaxLineNumber) {
        self.textView.scrollEnabled = YES;
        return;
    }
    
    if (fabs(textView.frame.size.height - textView.contentSize.height) >= 10.0) {
        self.height.constant = textView.contentSize.height + 5;
        [UIView animateWithDuration:0.23 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)tapScreen:(id) sender {
    
}

- (void)scrollToBottom {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.messages.count -1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userinfo = notification.userInfo;
    if (userinfo) {
        CGRect  r = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        double duration = [userinfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSInteger animationcurve = [userinfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        self.height2.constant =  CGRectGetHeight(r);
        [UIView animateWithDuration:duration delay:0 options:1<<animationcurve animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finish) {
           
        }];
        [self scrollToBottom];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userinfo = notification.userInfo;
//    if (userinfo) {
//        double duration = [userinfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        NSInteger animationcurve = [userinfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//        self.height2.constant = 0;
//        [UIView animateWithDuration:duration delay:0 options:1<<animationcurve animations:^{
//            [self.view layoutIfNeeded];
//        } completion:nil];
//    }
    self.imInputState = IMInputBarStateDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
