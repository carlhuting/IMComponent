//
//  MessageCell.m
//  learnInputBar
//
//  Created by lkeg on 15/9/4.
//  Copyright (c) 2015年 lkeg. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avtorImageView;

@property (weak, nonatomic) IBOutlet UILabel *messagelabel;
@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.layer.cornerRadius = 23.0;
    self.messagelabel.font = [UIFont systemFontOfSize:15];
    self.messagelabel.numberOfLines = 0;
    self.messagelabel.textColor = [UIColor darkTextColor];
}

- (void)setMessage:(NSString *)message {
    _message =message;
    [self.messagelabel setText:message];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
