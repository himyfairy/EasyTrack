//
//  UIView+SizeCategory.m
//  EasyTrack
//
//  Created by neo on 2016/12/21.
//  Copyright © 2016年 neo. All rights reserved.
//

#import "UIView+SizeCategory.h"

@implementation UIView (SizeCategory)
#pragma mark - override getter
- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGPoint)origin {
    return self.frame.origin;
}

#pragma mark - override setter
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
@end
