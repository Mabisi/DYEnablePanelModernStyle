#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 正确声明 CNBTableViewMainCell 类（需要确认实际类名）
@class CNBTableViewMainCell;  // 如果这是Swift类，这样声明可能不够

// 分组1：URL过滤
%group URLFilter
%hook NSURL
+ (id)URLWithString:(NSString *)URLString {
    NSArray *blockedKeywords = @[@"mumu.com", @"example.com"]; // 替换为你的关键词
    for (NSString *keyword in blockedKeywords) {
        if ([URLString containsString:keyword]) {
            URLString = @"木木IOS分享";
            break;
        }
    }
    return %orig;
}
%end
%end

// 分组2：菜鸟广告移除
%group CaiNiaoAdRemoval
// 更安全的hook方式，避免直接hook Swift类
%hook UIView  // 先尝试hook UIView，因为UITableViewCell最终继承自UIView
- (void)didMoveToSuperview {
    %orig;
    
    // 检查是否是目标cell
    if ([self isKindOfClass:NSClassFromString(@"CNBTableViewMainCell")]) {
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
            if (NSClassFromString(@"CNBTableViewMainCell")) {
                %init(CaiNiaoAdRemoval);
            } else {
                NSLog(@"未找到CNBTableViewMainCell类");
            }
        }
    }
}
