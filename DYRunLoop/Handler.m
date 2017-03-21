//
//  Handler.m
//  计时器
//
//  Created by Ethank on 2017/3/17.
//  Copyright © 2017年 DY. All rights reserved.
//

#import "Handler.h"

@interface Handler ()

@property (nonatomic, assign)NSInteger maxTask;
@property (nonatomic, strong)NSMutableArray *tasks;
@property (nonatomic, strong)NSMutableArray *tasksAtIndexPaths;

@end

@implementation Handler

- (instancetype)init {
    if (self = [super init]) {
        _maxTask = 30;
        _tasks = [NSMutableArray array];
        _tasksAtIndexPaths = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharehandle {
    static Handler *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[Handler alloc] init];
        [self addRunLoopObserverWithObject:singleton];
    });
    return singleton;
}

+ (void)addRunLoopObserverWithObject:(Handler *)hadler {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
//    CFIndex	version;
//    void *	info;
//    const void *(*retain)(const void *info);
//    void	(*release)(const void *info);
//    CFStringRef	(*copyDescription)(const void *info);
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)hadler,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    static CFRunLoopObserverRef runloopObserver;
    runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, NSIntegerMax - 999, &callback, &context);
    
    CFRunLoopAddObserver(runloop, runloopObserver, kCFRunLoopDefaultMode);
    
    CFRelease(runloopObserver);
    
}

static void callback (CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    Handler *handler = (__bridge Handler *)info;
    if (handler.tasks.count == 0) return;
    BOOL result = NO;
    while (!result && handler.tasks.count) {
        HandlerUnit unit = handler.tasks.firstObject;
        
        result = unit();
        
        [handler.tasks removeObjectAtIndex:0];
        [handler.tasksAtIndexPaths removeObjectAtIndex:0];
    }
    
}

- (void)addTask:(HandlerUnit)task forKey:(id)key {
    [self.tasks addObject:task];
    [self.tasksAtIndexPaths addObject:key];
    if (self.tasks.count > _maxTask) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksAtIndexPaths removeObjectAtIndex:0];
    }
}


@end
