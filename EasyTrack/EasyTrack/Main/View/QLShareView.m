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
//RGB(137, 217, 82)
//RGB(239, 241, 242)
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
@end
