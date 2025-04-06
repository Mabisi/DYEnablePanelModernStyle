%hook NSURL

+ (id)URLWithString:(NSString *)URLString
{
    // 定义所有需要拦截的关键词
    NSArray *blockedKeywords = @[
        @"mumu.com", //域名，自己根据添加
        @"mumu.com",
        @"mumu.com",
        @"mumu.comd",
        @"mumu.com",
        @"mumu.com",
        @"mumu.com"
    ];

    // 遍历所有关键词，如果 URL 中包含某个关键词，则修改为自定义字符串
    for (NSString *keyword in blockedKeywords) {
        if ([URLString containsString:keyword]) {
            URLString = @"木木IOS分享";
            break;
        }
    }

    return %orig;
}

%end

// 添加钩子处理菜鸟应用中的广告视图
%group CaiNiaoAdRemoval

// 针对JXCategoryListContainerView的钩子
%hook JXCategoryListContainerView

// 在视图即将添加到父视图时进行处理
- (void)didMoveToSuperview
{
    %orig; // 先调用原始方法
    
    // 判断是否为广告视图，如果是则将其隐藏或移除
    UIView *selfView = self;
    if (selfView) {
        // 可以通过多种方式判断是否为广告视图
        // 1. 直接移除
        [selfView removeFromSuperview];
        
        // 或者仅仅隐藏它
        // selfView.hidden = YES;
        
        // 或者设置为零尺寸
        // selfView.frame = CGRectZero;
        
        NSLog(@"[NoAds] 成功移除菜鸟应用中的JXCategoryListContainerView广告视图");
    }
}

// 可选：限制视图大小为零
- (void)layoutSubviews
{
    %orig;
    self.frame = CGRectZero;
}

%end

%end

// 根据应用包名决定是否加载特定的钩子组
%ctor {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleID isEqualToString:@"com.cainiao.cnwireless"]) {
        %init(CaiNiaoAdRemoval);
        NSLog(@"[NoAds] 已加载菜鸟应用的广告移除功能");
    }
}
