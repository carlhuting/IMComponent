//
//  LTMessageViewController.m
//  IMComponent
//
//  Created by lkeg on 16/3/8.
//  Copyright © 2016年 lkeg. All rights reserved.
//

#import "LTMessageViewController.h"
#import "LTInputBar.h"




@interface LTMessageViewController (UITableViewDataSource) <UITableViewDataSource, UITableViewDelegate>

@end

@interface LTMessageViewController () <LTInputBarDelegate>
@property (nonatomic, strong) LTInputBar *inputView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *actionsView;
@end

@implementation LTMessageViewController

+ (instancetype)viewController {
    return [[LTMessageViewController alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (UIView *)actionsView {
    if (!_actionsView) {
        _actionsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds), CGRectGetWidth(self.view.bounds), 270)];
        _actionsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _actionsView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
        [self.view addSubview:_actionsView];
    }
    return  _actionsView;
}

- (void)setUp {
    FLOG
    NSLog(@"%@",self.topLayoutGuide);
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _inputView = [[LTInputBar alloc] initWithFrame:CGRectZero];
    _inputView.delegate = self;
    _inputView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
     _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_inputView];
    
    _tableView.frame = self.view.bounds;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _inputView.frame = CGRectMake(0, height - defaultBarheight, width, defaultBarheight);
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, defaultBarheight, 0);
    [self adjustEdgeInset:edgeInset];
}

- (void)viewDidAppear:(BOOL)animated {
     FLOG
}
- (void)viewDidLoad {
    [super viewDidLoad];
    FLOG
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self setUp];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FLOG
}
- (void)viewWillLayoutSubviews {
    FLOG
}

- (void)viewDidLayoutSubviews {
   FLOG
    UIEdgeInsets edgeInset = _tableView.contentInset;
    edgeInset.top = self.topLayoutGuide.length;
    [self adjustEdgeInset:edgeInset];
}

- (BOOL)requestChangeHieht:(CGFloat)height {
    FLOG
    CGFloat location = (CGRectGetMaxY(self.view.bounds) - (CGRectGetMinY(_inputView.frame) + CGRectGetHeight(_inputView.frame) - height));
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, location, 0);
    [self adjustEdgeInset:edgeInset];
    return YES;
}

- (void)requestAdditionView:(NSInteger)state {
    FLOG
    BOOL hide = state == -1;
   __block CGRect inputViewFrame = _inputView.frame;
   __block CGRect otherMenuViewFrame;
    otherMenuViewFrame = self.actionsView.frame;
    otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
    self.actionsView.frame = otherMenuViewFrame;
    
    void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
        inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
        self.inputView.frame = inputViewFrame;
    };
    
    
    void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
        otherMenuViewFrame = self.actionsView.frame;
        otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
        self.actionsView.alpha = !hide;
        self.actionsView.frame = otherMenuViewFrame;
    };
    
    ShareMenuViewAnimation(hide);
    InputViewAnimation(hide);
    UIEdgeInsets edgeInset = _tableView.contentInset;
    edgeInset.bottom = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.inputView.frame);
    [self adjustEdgeInset:edgeInset];
}

- (void)adjustEdgeInset:(UIEdgeInsets)edgeInset {
    FLOG
    NSLog(@"UIEdgeInset<%f,%f,%f,%f>", edgeInset.top,edgeInset.left,edgeInset.bottom,edgeInset.right);
    _tableView.contentInset =  edgeInset;
    _tableView.scrollIndicatorInsets = edgeInset;
    NSInteger row = [_tableView numberOfRowsInSection:0];
    if (row > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)willShowInputView {
    
}

- (void)sendMessage:(id)messag {
    
}

- (void)willDismissInputView {
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    FLOG
    NSDictionary *userinfo = [notification userInfo];
    CGRect frame = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect originalframe = self.inputView.frame;
    CGFloat y = CGRectGetMinY(frame) - CGRectGetHeight(originalframe);
    self.inputView.frame = CGRectMake(0,y, CGRectGetWidth(self.view.bounds), CGRectGetHeight(originalframe));
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, CGRectGetHeight(originalframe) + frame.size.height , 0);
    [self adjustEdgeInset:edgeInset];
}

- (void)keyboardWillDismiss:(NSNotification *)notification {
    FLOG
    CGRect originalframe = self.inputView.frame;
    originalframe.origin.y = CGRectGetMaxY(self.view.bounds) - originalframe.size.height;
    self.inputView.frame = originalframe;
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, CGRectGetHeight(self.view.bounds) - CGRectGetMinY(originalframe) , 0);
    [self adjustEdgeInset:edgeInset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    FLOG
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _inputView.delegate = nil;
}

@end

@implementation LTMessageViewController (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", indexPath];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

@end
