//
//  ActionBoard.m
//  IMComponent
//
//  Created by lkeg on 15/11/10.
//  Copyright © 2015年 lkeg. All rights reserved.
//

#import "ActionBoard.h"

@implementation ActionBoard

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    UINib *nib = [[NSBundle mainBundle] loadNibNamed:@"ActionBoard" owner:nil options:nil];
    return [nib instantiateWithOwner:self options:nil].firstObject;
}

@end
