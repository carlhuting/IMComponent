//
//  LTInputBar.m
//  IMComponent
//
//  Created by lkeg on 16/3/8.
//  Copyright © 2016年 lkeg. All rights reserved.
//

#import "LTInputBar.h"

const CGFloat margin = 5.0;
const CGFloat buttonWidth = 35.0f;
const CGFloat minLine = 1.0f;
const CGFloat maxLine = 4.0f;

@interface LTInputBar ()
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *recordButton;
@end

@implementation LTInputBar

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _btn1 = [UIButton new];
    _inputBarState = LTInputBarStateText;
    [_btn1 setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateSelected];
    [_btn1 addTarget:self action:@selector(switchtapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn1];
    
    _btn2 = [UIButton new];
    [_btn2 setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn2];
    
    _recordButton = [[UIButton alloc] init];
    [_recordButton setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.6]];
    [self addSubview:_recordButton];
    
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:15.0f];
    [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:_textView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString: @"contentSize"]) {
        CGSize size = [change[@"new"] CGSizeValue];
         NSLog(@"befor textview change to new %@ size ", NSStringFromCGSize(size));
        if (size.height > maxLine * self.textView.font.lineHeight) {
            return ;
        }
        CGFloat newheight = MAX(size.height + margin * 2, defaultBarheight);
        BOOL result = [self.delegate requestChangeHieht:newheight];
        if (result) {
            [self adjustHeight:newheight];
        }
    }
}

- (void)setInputBarState:(LTInputBarState)inputBarState {
    if (_inputBarState == LTInputBarStateAdditional) {
        [self.delegate requestAdditionView:-1];
    }
    _inputBarState = inputBarState;
}

- (void)switchtapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self endEditing:YES];
        self.inputBarState = LTInputBarStateVoice;
        BOOL result = [self.delegate requestChangeHieht:defaultBarheight];
        if (result) {
            [self adjustHeight:defaultBarheight];
        }
        [UIView transitionFromView:_textView toView:_recordButton duration:0.2 options:7 << 16 completion:^(BOOL finished) {
            
        }];
    } else {
        [self.textView becomeFirstResponder];
         self.inputBarState = LTInputBarStateText;
        CGSize size = _textView.contentSize;
        CGFloat height = MIN(size.height, maxLine * self.textView.font.lineHeight) + 2 * margin;
        height = MAX(height, defaultBarheight);
        BOOL result = [self.delegate requestChangeHieht:height];
        if (result) {
            [self adjustHeight:height];
        }
        [UIView transitionFromView:_recordButton toView:_textView duration:0.2 options:7 << 16 completion:^(BOOL finished) {
            
        }];
    }
}

- (void)adjustHeight:(CGFloat)height {
    CGRect frame = self.frame;
    self.frame = CGRectMake(0, frame.origin.y + frame.size.height - height, frame.size.width, height);
}

- (void)tapped:(UIButton *)sender {
    if (self.inputBarState == LTInputBarStateAdditional) {
        self.inputBarState = LTInputBarStateText;
        [self.delegate requestAdditionView: -1];
        [self.textView becomeFirstResponder];
    } else {
        self.inputBarState = LTInputBarStateAdditional;
        [self endEditing:YES];
        [self.delegate requestAdditionView:0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    self.btn1.frame = CGRectMake(margin, margin, buttonWidth, height - 2 *margin);
    self.textView.frame = CGRectMake(buttonWidth + 2 * margin, margin, width - margin * 4 - buttonWidth * 2, height - 2 * margin);
    self.recordButton.frame = CGRectMake(buttonWidth + 2 * margin, margin, width - margin * 4 - buttonWidth * 2, defaultBarheight - 2 * margin);
    
    self.btn2.frame = CGRectMake(width - buttonWidth -margin, margin, buttonWidth, height - 2 * margin);
}

- (void)dealloc {
    [_textView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

@end
