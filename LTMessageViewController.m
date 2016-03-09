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
@property (nonatomic, strong) UIView *additionView;
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

- (UIView *)additionView {
    if (!_additionView) {
        _additionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds), CGRectGetWidth(self.view.bounds), 270)];
        _additionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _additionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self.view addSubview:_additionView];
    }
    return  _additionView;
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

- (void)requestAdditionView:(LTInputBarState)state {
    FLOG
    void (^InputViewAnimation)(UIView *floatView, UIView *anchorView) = ^(UIView *floatView, UIView *anchorView) {
        CGRect frame = floatView.frame;
        frame.origin.y = (CGRectGetMinY(anchorView.frame) - CGRectGetHeight(frame));
        [UIView animateWithDuration:0.3 delay:0 options:7 << 16 animations:^{
            floatView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    };
    
    void (^ShareMenuViewAnimation)(UIView *additionView, BOOL hide) = ^(UIView *additionView, BOOL hide) {
        CGRect frame = additionView.frame;
        frame.origin.y = (hide ? CGRectGetHeight(self.view.bounds) : (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(frame)));
        [UIView animateWithDuration:0.3 delay:0 options:7 << 16 animations:^{
            additionView.frame = frame;

        } completion:^(BOOL finished) {
            
        }];
    };
    if (state == LTInputBarStateText) {
        ShareMenuViewAnimation(self.additionView, YES);
    } else if(state == LTInputBarStateAdditional) {
        ShareMenuViewAnimation(self.additionView, NO);
        InputViewAnimation(self.inputView, self.additionView);
        UIEdgeInsets edgeInset = _tableView.contentInset;
        edgeInset.bottom = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.inputView.frame);
        [self adjustEdgeInset:edgeInset];
    } else {
        ShareMenuViewAnimation(self.additionView, YES);
        InputViewAnimation(self.inputView, self.additionView);
        UIEdgeInsets edgeInset = _tableView.contentInset;
        edgeInset.bottom = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.inputView.frame);
        [self adjustEdgeInset:edgeInset];
    }
}

- (void)adjustEdgeInset:(UIEdgeInsets)edgeInset {
    FLOG
    NSLog(@"UIEdgeInset<%f,%f,%f,%f>", edgeInset.top,edgeInset.left,edgeInset.bottom,edgeInset.right);
    [UIView animateWithDuration:0.3 delay:0 options:7 <<16  animations:^{
        _tableView.contentInset =  edgeInset;
        _tableView.scrollIndicatorInsets = edgeInset;
    } completion:^(BOOL finished) {
        
    }];
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
    [UIView animateWithDuration:0.3 delay:0 options:7 <<16  animations:^{
        self.inputView.frame = CGRectMake(0,y, CGRectGetWidth(self.view.bounds), CGRectGetHeight(originalframe));
    } completion:^(BOOL finished) {
        
    }];
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, CGRectGetHeight(originalframe) + frame.size.height , 0);
    [self adjustEdgeInset:edgeInset];
}

- (void)keyboardWillDismiss:(NSNotification *)notification {
    FLOG
    CGRect originalframe = self.inputView.frame;
    originalframe.origin.y = CGRectGetMaxY(self.view.bounds) - originalframe.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:7 << 16 animations:^{
        self.inputView.frame = originalframe;
    } completion:^(BOOL finished) {
        
    }];
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
