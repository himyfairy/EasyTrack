//
//  QLShareView.m
//  EasyTrack
//
//  Created by 戚璐 on 2016/12/22.
//  Copyright © 2016年 neo. All rights reserved.
//

#import "QLShareView.h"

@interface QLShareView ()
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionViewBottomConstraint;
@end

@implementation QLShareView
+ (void)showWithDelegate:(id<QLShareViewDelegate>)delegate {
    QLShareView *share = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    share.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    share.delegate = delegate;
    [[UIApplication sharedApplication].keyWindow addSubview:share];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.functionViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap:)]];
}

#pragma mark - method
- (void)maskViewTap:(UITapGestureRecognizer *)tap {
    [self dismissSelf];
}

- (void)dismissSelf {
    self.functionViewBottomConstraint.constant = self.functionView.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

//取消
- (IBAction)cancelBtnClick {
    [self dismissSelf];
}

//保存至相册
- (IBAction)saveToAlbum:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewDidClickSaveToAlbumButton:)]) {
        [self.delegate shareViewDidClickSaveToAlbumButton:self];
    }
}

//分享给微信好友
- (IBAction)shareToWechatFriend:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewDidClickShareToWechatFriendButton:)]) {
        [self.delegate shareViewDidClickShareToWechatFriendButton:self];
    }
}

//分享到微信朋友圈
- (IBAction)shareToWechatTimeline:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewDidClickShareToWechatTiemlineButton:)]) {
        [self.delegate shareViewDidClickShareToWechatTiemlineButton:self];
    }
}

@end
