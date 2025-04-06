#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
%hook JXCategoryListContainerView
- (void)didMoveToSuperview {
    %orig;
    [self removeFromSuperview];
    NSLog(@"[NoAds] 移除广告视图");
}
%end
%end

// 初始化逻辑
%ctor {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleID isEqualToString:@"com.cainiao.cnwireless"]) {
        %init(URLFilter);
        %init(CaiNiaoAdRemoval);
    }
}
