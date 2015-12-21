//
//  LTSegmentedControl.h
//  IMComponent
//
//  Created by lkeg on 15/12/17.
//  Copyright © 2015年 lkeg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UIColor;
@class UIView;

@protocol LTSegmentedControlDelegate <NSObject>

@optional
- (void)selectedIndexChanged:(NSUInteger) index;
@end

IB_DESIGNABLE @interface LTSegmentedControl : UIScrollView

@property (nonatomic, strong) NSArray<NSString *>* items;
@property(nonatomic,readonly) NSUInteger numberOfSegments;
@property(nonatomic) NSUInteger selectedSegmentIndex;

@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat minWidth IBInspectable;
@property (nonatomic, assign) CGFloat maxWidth;

@property (nonatomic, strong) UIColor *hightlightColor;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, weak) id<LTSegmentedControlDelegate> segmentDelegate;

- (instancetype)initWithItems:(NSArray<NSString *>*) items;


@end
NS_ASSUME_NONNULL_END