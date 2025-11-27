//
//  OmAdSafe.h
//  AlxAds
//
//  Created by liu weile on 2025/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

//【注意：】在.h文件中不要用双引号，否则会引起编译错误，应为尖括号包裹的头文件路径。但是在.m文件中可以用双引号。因为.h文件是向外公开的，.m文件不向外公开
//#import "OmAdType.h"
//#import "OmFriendlyType.h"
// 在.h文件中推荐用尖括号import，不要用双引号import
#import <AlxAds/OmAdType.h>
#import <AlxAds/OmFriendlyType.h>

// 前向声明
@class AlxOmidBean;


NS_ASSUME_NONNULL_BEGIN

@interface OmAdSafe : NSObject

// 初始化方法
- (instancetype)initWithAdType:(OmAdType)adType
                        adView:(nullable UIView *)adView
                          bean:(nullable AlxOmidBean *)bean
                webViewContext:(nullable WKWebView *)webViewContext;


- (instancetype)initWithAdType:(OmAdType)adType
                        adView:(nullable UIView *)adView
                          bean:(nullable AlxOmidBean *)bean;

- (instancetype)initWithAdType:(OmAdType)adType
                  webCreative:(WKWebView *)webCreative;

// 静态方法
+ (void)initOMSDK;
+ (BOOL)isOmidEnabledWithBean:(nullable AlxOmidBean *)bean
NS_SWIFT_NAME(isOmidEnabled(bean:));

// 会话控制
- (void)startSession;
- (void)destroy;

// 事件上报
- (void)reportLoad;
- (void)reportLoadWithIsSkipAble:(BOOL)isSkipAble
                    offsetForSkip:(CGFloat)offsetForSkip
                        isAutoPlay:(BOOL)isAutoPlay
NS_SWIFT_NAME(reportLoad(isSkipAble:offsetForSkip:isAutoPlay:));

- (void)reportImpress;

- (void)addFriendlyObstructionWithView:(UIView *)view
                               purpose:(OmFriendlyType)purpose
                                reason:(nullable NSString *)reason
NS_SWIFT_NAME(addFriendlyObstruction(view:purpose:reason:));

// 视频事件（仅用于视频广告）
- (void)reportVideoStartWithDuration:(CGFloat)duration isMute:(BOOL)isMute
NS_SWIFT_NAME(reportVideoStart(duration:isMute:));

- (void)reportVideoVolumeChangeWithIsMute:(BOOL)isMute
NS_SWIFT_NAME(reportVideoVolumeChange(isMute:));

- (void)reportVideoResume;
- (void)reportVideoPause;
- (void)reportVideoBufferEnd;
- (void)reportVideoBufferStart;
- (void)reportVideoClick;
- (void)reportVideoFirstQuartile;
- (void)reportVideoMidpoint;
- (void)reportVideoThirdQuartile;
- (void)reportVideoSkip;
- (void)reportVideoComplete;

@end

NS_ASSUME_NONNULL_END
