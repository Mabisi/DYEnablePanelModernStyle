#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 正确声明 JXCategoryListContainerView 类（需要确认实际类名）
@class JXCategoryListContainerView;  // 如果这是Swift类，这样声明可能不够

// 分组2：菜鸟广告移除
%group CaiNiaoAdRemoval
// 更安全的hook方式，避免直接hook Swift类
%hook UIView  // 先尝试hook UIView，因为UITableViewCell最终继承自UIView
- (void)didMoveToSuperview {
    %orig;
    
    // 检查是否是目标cell
    if ([self isKindOfClass:NSClassFromString(@"JXCategoryListContainerView")]) {
        [self removeFromSuperview];
        NSLog(@"[NoAds] 移除广告视图");
    }
}
%end
%end

// 初始化逻辑
%ctor {
    @autoreleasepool {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        if ([bundleID isEqualToString:@"com.cainiao.cnwireless"]) {
            %init(URLFilter);
            
            // 检查类是否存在再初始化hook
            if (NSClassFromString(@"JXCategoryListContainerView")) {
                %init(CaiNiaoAdRemoval);
            } else {
                NSLog(@"未找到JXCategoryListContainerView类");
            }
        }
    }
}
