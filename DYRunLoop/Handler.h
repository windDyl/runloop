//
//  Handler.h
//  计时器
//
//  Created by Ethank on 2017/3/17.
//  Copyright © 2017年 DY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^HandlerUnit)(void);

@interface Handler : NSObject

+ (instancetype)sharehandle;

- (void)addTask:(HandlerUnit)task forKey:(id)key;

@end
