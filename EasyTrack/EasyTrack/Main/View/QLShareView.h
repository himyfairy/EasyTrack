//
//  QLShareView.h
//  EasyTrack
//
//  Created by 戚璐 on 2016/12/22.
//  Copyright © 2016年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QLShareView;

@protocol QLShareViewDelegate <NSObject>
@required
- (void)shareViewDidClickSaveToAlbumButton:(QLShareView *)shareView;
- (void)shareViewDidClickShareToWechatFriendButton:(QLShareView *)shareView;
- (void)shareViewDidClickShareToWechatTiemlineButton:(QLShareView *)shareView;
@end

@interface QLShareView : UIView
@property(nonatomic, weak) id<QLShareViewDelegate> delegate;
+ (void)showWithDelegate:(id<QLShareViewDelegate>)delegate;
@end
