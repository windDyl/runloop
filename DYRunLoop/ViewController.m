//
//  ViewController.m
//  计时器
//
//  Created by Ethank on 2017/3/17.
//  Copyright © 2017年 DY. All rights reserved.
//

#import "ViewController.h"

#import "TabViewController.h"

@interface ViewController ()

@property (nonatomic, assign)BOOL finish;
@property (nonatomic, strong)dispatch_source_t timer;
@property (nonatomic, assign)NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSTimer
//    [self addTimer];
    
    //CADisplayLink
//    [self addCADisplayLink];
    
    //dispatch_source_t
//    [self addDispatch_source_t];
    
    //添加runloop观察者
//    [self addRunloopObserver];
}

//NSTimer

- (void)addNSTimer {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        while (!_finish) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0.1]];
        }
        
    });
}

//CADisplayLink

- (void)addCADisplayLink {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerRun)];
        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        while (!_finish) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceReferenceDate:1.0/60]];
        }
        
    });
    
}

//dispatch_source_t

- (void)addDispatch_source_t {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    self.timer = timer;
    //设置时间
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    
    //间隔时间
    uint64_t interval = 2.0 * NSEC_PER_SEC;
    
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"knwdkfnwk");
    });
    
    dispatch_resume(self.timer);
    
}



- (void)timerRun {
    NSLog(@"正在计时");
}

static void callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    ViewController *vc = (__bridge ViewController *)(info);//将c转换成oc
    vc.count ++;
    NSLog(@"runloop 进行时%zd", vc.count);
    
}

- (void)addRunloopObserver {
    //获取runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
//    CFIndex	version;
//    void *	info;
//    const void *(*retain)(const void *info);
//    void	(*release)(const void *info);
//    CFStringRef	(*copyDescription)(const void *info);
    //定义一个上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),//将OC转换成C
        &CFRetain,
        &CFRelease,
        NULL
    };
    //定义一个runloop观察者
    static CFRunLoopObserverRef defaultModeObserver;
    //创建一个runloop观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, NSIntegerMax - 999, &callback, &context);
    //给runloop添加观察者
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
    //释放runloop观察者
    CFRelease(defaultModeObserver);
    
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _finish = YES;
    
    TabViewController *tabVC = [[TabViewController alloc] init];
    [self presentViewController:tabVC animated:YES completion:nil];
}

@end
