//
//  ViewController.m
//  TestActionBar
//
//  Created by lkeg on 15/11/2.
//  Copyright © 2015年 lkeg. All rights reserved.
//

#import "ViewController.h"
#import "macroDefine.h"

typedef NS_ENUM(NSInteger, LTBoardState) {
    LTBoardStateDefault  = 0 ,
    LTBoardStateAction   = 1 ,
    LTBoardStateEmotion  = 2 ,
    LTBoardStateRecord   = 3 ,
    LTBoardStateKeyBoard = 4
};

@interface ViewController ()



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBoardHeight;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *actionBoard;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@property (strong, nonatomic) UIView *actionViewOne;
@property (strong, nonatomic) UIView *actionViewTwo;
@property (strong, nonatomic) UIView *actionViewThree;
@property (nonatomic, assign) LTBoardState boardState;
@end

@implementation ViewController

viewController(@"Main")

- (UIView *)actionViewOne {
    if (!_actionViewOne) {
        _actionViewOne = [[UIView alloc] init];
        _actionViewOne.frame = CGRectMake(0, 0, 20, 120);
        _actionViewOne.backgroundColor = [UIColor greenColor];
    }
    return  _actionViewOne;
}

- (UIView *)actionViewTwo {
    if (!_actionViewTwo) {
        _actionViewTwo = [[UIView alloc] init];
        _actionViewTwo.frame = CGRectMake(0, 0, 20, 220);
        _actionViewTwo.backgroundColor = [UIColor yellowColor];
    }
    return  _actionViewTwo;
}

- (UIView *)actionViewThree {
    if (!_actionViewThree) {
        _actionViewThree = [[UIView alloc] init];
        _actionViewThree.frame = CGRectMake(0, 0, 20, 80);
        _actionViewThree.backgroundColor = [UIColor purpleColor];
    }
    return  _actionViewThree;
}

- (void)showSupplementView:(UIView *)view {
    const CGFloat height = view.frame.size.height;
    self.actionBoardHeight.constant = height;
    if (!view.superview) {
        [self.actionBoard addSubview:view];
    }
    [self.actionBoard bringSubviewToFront:view];
    CGRect frame = self.actionBoard.bounds;
    frame.size.height = height;
    frame.origin.y = height;
    view.frame = frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = frame;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setBoardState:(LTBoardState)boardState {
    if (boardState == _boardState) {
        return ;
    }
    if (boardState == LTBoardStateDefault) {
        self.actionBoardHeight.constant = 0;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
    if (boardState == LTBoardStateAction) {
        [self showSupplementView:self.actionViewOne];
    }
    if (boardState == LTBoardStateEmotion) {
        [self showSupplementView:self.actionViewTwo];
    }
    _boardState = boardState;
}

- (IBAction)show:(id)sender {
    [self.textField resignFirstResponder];
    self.boardState = LTBoardStateAction;
}

- (IBAction)showTwo:(id)sender {
    [self.textField resignFirstResponder];
    self.boardState = LTBoardStateEmotion;
}

- (IBAction)showThree:(id)sender {
    [self.textField resignFirstResponder];
    self.boardState = LTBoardStateDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.boardState = LTBoardStateDefault;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.boardState = LTBoardStateKeyBoard;
    NSDictionary *userinfo = notification.userInfo;
    CGRect rect = [userinfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userinfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
     self.actionBoardHeight.constant = rect.size.height;
    [UIView animateWithDuration:duration delay:0 options:7 << 16 animations:^{
        [self.view layoutIfNeeded];

    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSDictionary *)userInfo {
 
    self.boardState = LTBoardStateDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
