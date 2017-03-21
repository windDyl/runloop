//
//  UITableViewCell+Dy.m
//  计时器
//
//  Created by Ethank on 2017/3/17.
//  Copyright © 2017年 DY. All rights reserved.
//

#import "UITableViewCell+Dy.h"
#import <objc/message.h>

static const void * key = "associated";

@implementation UITableViewCell (Dy)

- (void)setCurrentPage:(NSIndexPath *)currentPage {
    objc_setAssociatedObject(self, key, currentPage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)currentPage {
    NSIndexPath *currentPage = objc_getAssociatedObject(self, key);
    return currentPage;
}

@end
