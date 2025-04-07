#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 正确声明 JXCategoryListContainerView 类
@class JXCategoryListContainerView;

// 分组1：菜鸟广告移除
%group CaiNiaoAdRemoval
%hook UIView
- (void)didMoveToSuperview {
    %orig;
    
    // 检查是否是目标视图
    if ([self isKindOfClass:NSClassFromString(@"JXCategoryListContainerView")]) {
        [self removeFromSuperview];
        NSLog(@"[NoAds] 移除广告视图: %@", self);
    }
}
%end
%end

// 初始化逻辑
%ctor {
    @autoreleasepool {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        if ([bundleID isEqualToString:@"com.cainiao.cnwireless"]) {
            // 检查类是否存在再初始化hook
            if (NSClassFromString(@"JXCategoryListContainerView")) {
                NSLog(@"找到JXCategoryListContainerView类，初始化hook");
                %init(CaiNiaoAdRemoval);
            } else {
                NSLog(@"未找到JXCategoryListContainerView类");
            }
        }
    }
}
