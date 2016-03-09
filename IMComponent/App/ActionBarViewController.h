//
//  ActionBarViewController.h
//  IMComponent
//
//  Created by lkeg on 15/12/21.
//  Copyright © 2015年 lkeg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionBarDelegate <NSObject>
- (void)heightChanged:(CGFloat)height;
@end

typedef NS_ENUM(NSInteger, IMInputBarState) {
    IMInputBarStateDefault,
    IMInputBarStateKeyBoard,
    IMInputBarStateMedia,
    IMInputBarStateMedia2
};

@interface ActionBarViewController : UIViewController
@property (nonatomic, weak) id<ActionBarDelegate> delegate;
@property (nonatomic, assign) IMInputBarState imInputState;
@end
