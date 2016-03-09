//
//  ActionBarViewController.m
//  IMComponent
//
//  Created by lkeg on 15/12/21.
//  Copyright © 2015年 lkeg. All rights reserved.
//

#import "ActionBarViewController.h"

const NSInteger static MaxLineNumber = 8;
const NSInteger static MinLineNumber = 1;
const NSInteger static intricHeight = 46;

@interface ActionBarViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) NSArray *rightContainer;
@property (nonatomic, strong) NSLayoutConstraint *layconstraintHeight;
@end

@implementation ActionBarViewController

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.scrollsToTop = NO;
        _textView.clipsToBounds = YES;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.cornerRadius = 5.0;
        _textView.layer.borderWidth = 1.0f;
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        _recordButton.clipsToBounds = YES;
        _recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _recordButton.layer.cornerRadius = 5.0;
        _recordButton.layer.borderWidth = 1.0f;
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    return _recordButton;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UIButton alloc] init];
        [_switchButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [_switchButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateSelected];
        
        [_switchButton addTarget:self action:@selector(switchtapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (void)setImInputState:(IMInputBarState)imInputState {
    if (imInputState == IMInputBarStateDefault) {
       
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
           // [self.inputView addSubview:self.inputViewOne];
            [UIView animateWithDuration:.23 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case IMInputBarStateMedia2: {
            [self.textView resignFirstResponder];
            //[self.inputView addSubview:self.inputViewTwo];
           // self.height2.constant = 120;
            [UIView animateWithDuration:.23 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        default:
            break;
    }
    _imInputState = imInputState;
}

- (void)textViewDidChange:(UITextView *)textView {
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSInteger lineNumbers = ceilf(textView.contentSize.height / textView.font.lineHeight);
    if (lineNumbers > MaxLineNumber) {
        self.textView.scrollEnabled = YES;
        return;
    }
    
    if (fabs(textView.frame.size.height - textView.contentSize.height) >= 10.0) {
        self.layconstraintHeight.constant = MAX(intricHeight, textView.contentSize.height + 10);
        [UIView animateWithDuration:0.23 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSInteger lineNumbers = ceilf(textView.contentSize.height / textView.font.lineHeight);
    if (lineNumbers > MaxLineNumber) {
        self.textView.scrollEnabled = YES;
        return;
    }
   CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    if (fabs(textView.frame.size.height - textView.contentSize.height) >= 10.0) {
         self.layconstraintHeight.constant = MAX(intricHeight, textView.contentSize.height + 10);
        [UIView animateWithDuration:0.23 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.recordButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.switchButton.translatesAutoresizingMaskIntoConstraints = NO;
   
    
    self.layconstraintHeight = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:46];
    [self.view addConstraint:self.layconstraintHeight];
    
    [self.view addSubview:self.textView];
     [self.view addSubview:self.switchButton];
   
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    self.imInputState = IMInputBarStateDefault;
}

- (void)switchtapped:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.layconstraintHeight.constant = 46;
        [UIView transitionFromView:self.textView toView:self.recordButton duration:.23 options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished) {
            self.recordButton.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.recordButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.recordButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.recordButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.recordButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
        }];
        self.view.userInteractionEnabled = YES;
    } else {
        [UIView transitionFromView:self.recordButton toView:self.textView duration:.23 options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished) {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
            self.view.userInteractionEnabled = YES;

        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
