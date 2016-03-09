//
//  LTInputBar.h
//  IMComponent
//
//  Created by lkeg on 16/3/8.
//  Copyright © 2016年 lkeg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  defaultBarheight 45.0f

typedef NS_ENUM(NSUInteger, LTInputBarState) {
    LTInputBarStateNormal = 0,
    LTInputBarStateAdditional = 1,
    LTInputBarStateText =2,
    LTInputBarStateVoice = 3
};

@protocol LTInputBarDelegate <NSObject>
@optional
- (void)sendMessage:(id)messag;
- (BOOL)requestChangeHieht:(CGFloat) height;
- (void)willDismissInputView;
- (void)willShowInputView;
- (void)requestAdditionView:(LTInputBarState)index;

@end

@interface LTInputBar : UIView

@property (nonatomic, weak) id<LTInputBarDelegate> delegate;
@property (nonatomic, assign) LTInputBarState inputBarState;

@end
