//
//  UIView+SizeCategory.h
//  EasyTrack
//
//  Created by neo on 2016/12/21.
//  Copyright © 2016年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SizeCategory)
#pragma mark - override getter
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)x;
- (CGFloat)y;
- (CGPoint)origin;

#pragma mark - override setter
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
@end
