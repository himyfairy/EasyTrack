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
- (void)shareViewDidClickSaveToAlbum:(QLShareView *)shareView;
- (void)shareViewDidClickWechatFriend:(QLShareView *)shareView;
- (void)shareViewDidClickWechatTimeline:(QLShareView *)shareView;
@end

@interface QLShareView : UIView
@property(nonatomic, weak) id<QLShareViewDelegate> delegate;
+ (void)showWithDelegate:(id<QLShareViewDelegate>)delegate;
@end
