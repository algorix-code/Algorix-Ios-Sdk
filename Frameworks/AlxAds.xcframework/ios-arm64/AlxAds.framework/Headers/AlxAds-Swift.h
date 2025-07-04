#if 0
#elif defined(__arm64__) && __arm64__
// Generated by Apple Swift version 6.1.2 effective-5.10 (swiftlang-6.1.2.1.2 clang-1700.0.13.5)
#ifndef ALXADS_SWIFT_H
#define ALXADS_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#if defined(__OBJC__)
#include <Foundation/Foundation.h>
#endif
#if defined(__cplusplus)
#include <cstdint>
#include <cstddef>
#include <cstdbool>
#include <cstring>
#include <stdlib.h>
#include <new>
#include <type_traits>
#else
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>
#endif
#if defined(__cplusplus)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnon-modular-include-in-framework-module"
#if defined(__arm64e__) && __has_include(<ptrauth.h>)
# include <ptrauth.h>
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreserved-macro-identifier"
# ifndef __ptrauth_swift_value_witness_function_pointer
#  define __ptrauth_swift_value_witness_function_pointer(x)
# endif
# ifndef __ptrauth_swift_class_method_pointer
#  define __ptrauth_swift_class_method_pointer(x)
# endif
#pragma clang diagnostic pop
#endif
#pragma clang diagnostic pop
#endif

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef unsigned char char8_t;
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...) 
# endif
#endif
#if !defined(SWIFT_RUNTIME_NAME)
# if __has_attribute(objc_runtime_name)
#  define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
# else
#  define SWIFT_RUNTIME_NAME(X) 
# endif
#endif
#if !defined(SWIFT_COMPILE_NAME)
# if __has_attribute(swift_name)
#  define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
# else
#  define SWIFT_COMPILE_NAME(X) 
# endif
#endif
#if !defined(SWIFT_METHOD_FAMILY)
# if __has_attribute(objc_method_family)
#  define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
# else
#  define SWIFT_METHOD_FAMILY(X) 
# endif
#endif
#if !defined(SWIFT_NOESCAPE)
# if __has_attribute(noescape)
#  define SWIFT_NOESCAPE __attribute__((noescape))
# else
#  define SWIFT_NOESCAPE 
# endif
#endif
#if !defined(SWIFT_RELEASES_ARGUMENT)
# if __has_attribute(ns_consumed)
#  define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
# else
#  define SWIFT_RELEASES_ARGUMENT 
# endif
#endif
#if !defined(SWIFT_WARN_UNUSED_RESULT)
# if __has_attribute(warn_unused_result)
#  define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
# else
#  define SWIFT_WARN_UNUSED_RESULT 
# endif
#endif
#if !defined(SWIFT_NORETURN)
# if __has_attribute(noreturn)
#  define SWIFT_NORETURN __attribute__((noreturn))
# else
#  define SWIFT_NORETURN 
# endif
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA 
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA 
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA 
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif
#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif
#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER 
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility) 
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED_OBJC)
# if __has_feature(attribute_diagnose_if_objc)
#  define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
# else
#  define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
# endif
#endif
#if defined(__OBJC__)
#if !defined(IBSegueAction)
# define IBSegueAction 
#endif
#endif
#if !defined(SWIFT_EXTERN)
# if defined(__cplusplus)
#  define SWIFT_EXTERN extern "C"
# else
#  define SWIFT_EXTERN extern
# endif
#endif
#if !defined(SWIFT_CALL)
# define SWIFT_CALL __attribute__((swiftcall))
#endif
#if !defined(SWIFT_INDIRECT_RESULT)
# define SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#endif
#if !defined(SWIFT_CONTEXT)
# define SWIFT_CONTEXT __attribute__((swift_context))
#endif
#if !defined(SWIFT_ERROR_RESULT)
# define SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#endif
#if defined(__cplusplus)
# define SWIFT_NOEXCEPT noexcept
#else
# define SWIFT_NOEXCEPT 
#endif
#if !defined(SWIFT_C_INLINE_THUNK)
# if __has_attribute(always_inline)
# if __has_attribute(nodebug)
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline)) __attribute__((nodebug))
# else
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline))
# endif
# else
#  define SWIFT_C_INLINE_THUNK inline
# endif
#endif
#if defined(_WIN32)
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL __declspec(dllimport)
#endif
#else
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL 
#endif
#endif
#if defined(__OBJC__)
#if __has_feature(objc_modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreFoundation;
@import Foundation;
@import ObjectiveC;
@import UIKit;
#endif

#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#pragma clang diagnostic ignored "-Wdollar-in-identifier-extension"
#pragma clang diagnostic ignored "-Wunsafe-buffer-usage"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="AlxAds",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

#if defined(__OBJC__)

SWIFT_PROTOCOL("_TtP6AlxAds13AlxAdDelegate_")
@protocol AlxAdDelegate <NSObject>
/// 广告竞价单价ecpm
/// @return
- (double)getPrice SWIFT_WARN_UNUSED_RESULT;
/// 竞价成功通知url，需要将${AUCTION_PRICE}替换为实际的价格
/// @return
- (void)reportBiddingUrl;
/// 计费通知url，需要将${AUCTION_PRICE}替换为实际的价格
/// @return
- (void)reportChargingUrl;
@end

/// 后期可扩展请求参数类
SWIFT_CLASS("_TtC6AlxAds12AlxAdRequest")
@interface AlxAdRequest : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSCoder;
@class NSString;
@class UIWindow;
/// 所有广告视图的基类【像banner、原生广告】
SWIFT_CLASS("_TtC6AlxAds13AlxBaseAdView")
@interface AlxBaseAdView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)observeValueForKeyPath:(NSString * _Nullable)keyPath ofObject:(id _Nullable)object change:(NSDictionary<NSKeyValueChangeKey, id> * _Nullable)change context:(void * _Nullable)context;
- (void)didAddSubview:(UIView * _Nonnull)subview;
- (void)willRemoveSubview:(UIView * _Nonnull)subview;
- (void)willMoveToSuperview:(UIView * _Nullable)newSuperview;
- (void)didMoveToSuperview;
- (void)willMoveToWindow:(UIWindow * _Nullable)newWindow;
- (void)didMoveToWindow;
@end

/// banner广告基类业务处理
SWIFT_CLASS("_TtC6AlxAds17AlxBaseBannerView")
@interface AlxBaseBannerView : AlxBaseAdView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@protocol AlxBannerViewAdDelegate;
@class UIViewController;
SWIFT_CLASS("_TtC6AlxAds15AlxBannerAdView")
@interface AlxBannerAdView : AlxBaseBannerView <AlxAdDelegate>
@property (nonatomic, weak) IBOutlet id <AlxBannerViewAdDelegate> _Nullable delegate;
/// 此视图控制器用于在用户点击广告后呈现重叠式广告，通常应设置为包含AlxBannerAdView的视图控制器
@property (nonatomic, weak) IBOutlet UIViewController * _Nullable rootViewController;
/// 设置刷新频率:单位s  【 0或30~120之间的数字。0表示不自动刷新, 默认30S 】
@property (nonatomic) IBInspectable NSInteger refreshInterval;
/// 是否隐藏关闭图标
@property (nonatomic) IBInspectable BOOL isHideClose;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)loadAdWithAdUnitId:(NSString * _Nonnull)adUnitId;
- (void)loadAdWithAdUnitId:(NSString * _Nonnull)adUnitId request:(AlxAdRequest * _Nullable)request;
- (BOOL)isReady SWIFT_WARN_UNUSED_RESULT;
- (void)destroy;
- (double)getPrice SWIFT_WARN_UNUSED_RESULT;
- (void)reportBiddingUrl;
- (void)reportChargingUrl;
@end

SWIFT_PROTOCOL("_TtP6AlxAds23AlxBannerViewAdDelegate_")
@protocol AlxBannerViewAdDelegate <NSObject>
- (void)bannerViewAdLoad:(AlxBannerAdView * _Nonnull)bannerView;
- (void)bannerViewAdFailToLoad:(AlxBannerAdView * _Nonnull)bannerView didFailWithError:(NSError * _Nonnull)error;
@optional
- (void)bannerViewAdImpression:(AlxBannerAdView * _Nonnull)bannerView;
- (void)bannerViewAdClick:(AlxBannerAdView * _Nonnull)bannerView;
- (void)bannerViewAdClose:(AlxBannerAdView * _Nonnull)bannerView;
@end

SWIFT_CLASS("_TtC6AlxAds19AlxBaseNativeAdView")
@interface AlxBaseNativeAdView : AlxBaseAdView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@protocol AlxInterstitialAdDelegate;
SWIFT_CLASS("_TtC6AlxAds17AlxInterstitialAd")
@interface AlxInterstitialAd : NSObject <AlxAdDelegate>
@property (nonatomic, weak) id <AlxInterstitialAdDelegate> _Nullable delegate;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)loadAdWithAdUnitId:(NSString * _Nonnull)adUnitId;
- (void)showAdWithPresent:(UIViewController * _Nonnull)present;
- (BOOL)isReady SWIFT_WARN_UNUSED_RESULT;
- (void)destroy;
- (double)getPrice SWIFT_WARN_UNUSED_RESULT;
- (void)reportBiddingUrl;
- (void)reportChargingUrl;
@end

SWIFT_PROTOCOL("_TtP6AlxAds25AlxInterstitialAdDelegate_")
@protocol AlxInterstitialAdDelegate <NSObject>
- (void)interstitialAdLoad:(AlxInterstitialAd * _Nonnull)ad;
- (void)interstitialAdFailToLoad:(AlxInterstitialAd * _Nonnull)ad didFailWithError:(NSError * _Nonnull)error;
@optional
- (void)interstitialAdImpression:(AlxInterstitialAd * _Nonnull)ad;
- (void)interstitialAdClick:(AlxInterstitialAd * _Nonnull)ad;
- (void)interstitialAdClose:(AlxInterstitialAd * _Nonnull)ad;
/// 广告渲染失败【包含：视频播放失败、web失败等】
- (void)interstitialAdRenderFail:(AlxInterstitialAd * _Nonnull)ad didFailWithError:(NSError * _Nonnull)error;
- (void)interstitialAdVideoStart:(AlxInterstitialAd * _Nonnull)ad;
- (void)interstitialAdVideoEnd:(AlxInterstitialAd * _Nonnull)ad;
@end

@class UIImage;
@protocol AlxMediaVideoDelegate;
SWIFT_CLASS("_TtC6AlxAds15AlxMediaContent")
@interface AlxMediaContent : NSObject
@property (nonatomic, strong) UIImage * _Nullable image;
@property (nonatomic, readonly) BOOL hasVideo;
@property (nonatomic, readonly) CGFloat aspectRatio;
@property (nonatomic, strong) id <AlxMediaVideoDelegate> _Nullable videoDelegate;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

SWIFT_CLASS("_TtC6AlxAds17AlxMediaModelView")
@interface AlxMediaModelView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

SWIFT_PROTOCOL("_TtP6AlxAds21AlxMediaVideoDelegate_")
@protocol AlxMediaVideoDelegate <NSObject>
@optional
- (void)videoStart;
- (void)videoEnd;
- (void)videoPlay;
- (void)videoPause;
- (void)videoPlayErrorWithError:(NSError * _Nonnull)error;
- (void)videoMuteWithIsMute:(BOOL)isMute;
@end

IB_DESIGNABLE
SWIFT_CLASS("_TtC6AlxAds12AlxMediaView")
@interface AlxMediaView : AlxMediaModelView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)setMediaContent:(AlxMediaContent * _Nullable)mediaContent;
- (UIView * _Nullable)getAdMediaView SWIFT_WARN_UNUSED_RESULT;
@end

@class AlxNativeAdImage;
@protocol AlxNativeAdDelegate;
/// 原生广告
SWIFT_CLASS("_TtC6AlxAds11AlxNativeAd")
@interface AlxNativeAd : NSObject <AlxAdDelegate>
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) NSInteger Create_Type_Unknown;)
+ (NSInteger)Create_Type_Unknown SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) NSInteger Create_Type_Large_Image;)
+ (NSInteger)Create_Type_Large_Image SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) NSInteger Create_Type_Small_Image;)
+ (NSInteger)Create_Type_Small_Image SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) NSInteger Create_Type_Group_Image;)
+ (NSInteger)Create_Type_Group_Image SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) NSInteger Create_Type_Video;)
+ (NSInteger)Create_Type_Video SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly) NSInteger createType;
@property (nonatomic, readonly, copy) NSString * _Nullable adSource;
@property (nonatomic, readonly, copy) NSString * _Nullable title;
@property (nonatomic, readonly, copy) NSString * _Nullable desc;
@property (nonatomic, readonly, strong) AlxNativeAdImage * _Nullable icon;
@property (nonatomic, readonly, copy) NSArray<AlxNativeAdImage *> * _Nullable images;
@property (nonatomic, readonly, copy) NSString * _Nullable callToAction;
@property (nonatomic, readonly, strong) AlxMediaContent * _Nullable mediaContent;
@property (nonatomic, weak) UIViewController * _Nullable rootViewController;
@property (nonatomic, weak) id <AlxNativeAdDelegate> _Nullable delegate;
- (void)registerViewWithContainer:(UIView * _Nonnull)container clickableViews:(NSArray<UIView *> * _Nullable)clickableViews;
- (void)registerViewWithContainer:(UIView * _Nonnull)container clickableViews:(NSArray<UIView *> * _Nullable)clickableViews closeView:(UIView * _Nullable)closeView;
- (void)unregisterView;
@property (nonatomic, readonly, strong) UIImage * _Nullable adLogo;
- (double)getPrice SWIFT_WARN_UNUSED_RESULT;
- (void)reportBiddingUrl;
- (void)reportChargingUrl;
@end

SWIFT_PROTOCOL("_TtP6AlxAds19AlxNativeAdDelegate_")
@protocol AlxNativeAdDelegate <NSObject>
@optional
- (void)nativeAdImpression:(AlxNativeAd * _Nonnull)nativeAd;
- (void)nativeAdClick:(AlxNativeAd * _Nonnull)nativeAd;
- (void)nativeAdClose:(AlxNativeAd * _Nonnull)nativeAd;
@end

SWIFT_CLASS("_TtC6AlxAds16AlxNativeAdImage")
@interface AlxNativeAdImage : NSObject
@property (nonatomic, readonly, copy) NSString * _Nullable url;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@protocol AlxNativeAdLoaderDelegate;
SWIFT_CLASS("_TtC6AlxAds17AlxNativeAdLoader")
@interface AlxNativeAdLoader : NSObject
@property (nonatomic, weak) id <AlxNativeAdLoaderDelegate> _Nullable delegate;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
- (nonnull instancetype)initWithAdUnitID:(NSString * _Nonnull)adUnitID OBJC_DESIGNATED_INITIALIZER;
- (void)loadAd;
@end

SWIFT_PROTOCOL("_TtP6AlxAds25AlxNativeAdLoaderDelegate_")
@protocol AlxNativeAdLoaderDelegate <NSObject>
- (void)nativeAdLoadedWithDidReceive:(NSArray<AlxNativeAd *> * _Nonnull)ads;
- (void)nativeAdFailToLoadWithDidFailWithError:(NSError * _Nonnull)error;
@end

@protocol AlxRewardVideoAdDelegate;
SWIFT_CLASS("_TtC6AlxAds16AlxRewardVideoAd")
@interface AlxRewardVideoAd : NSObject <AlxAdDelegate>
@property (nonatomic, weak) id <AlxRewardVideoAdDelegate> _Nullable delegate;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)loadAdWithAdUnitId:(NSString * _Nonnull)adUnitId;
- (void)showAdWithPresent:(UIViewController * _Nonnull)present;
- (BOOL)isReady SWIFT_WARN_UNUSED_RESULT;
- (void)destroy;
- (double)getPrice SWIFT_WARN_UNUSED_RESULT;
- (void)reportBiddingUrl;
- (void)reportChargingUrl;
@end

SWIFT_PROTOCOL("_TtP6AlxAds24AlxRewardVideoAdDelegate_")
@protocol AlxRewardVideoAdDelegate <NSObject>
- (void)rewardVideoAdLoad:(AlxRewardVideoAd * _Nonnull)ad;
- (void)rewardVideoAdFailToLoad:(AlxRewardVideoAd * _Nonnull)ad didFailWithError:(NSError * _Nonnull)error;
@optional
- (void)rewardVideoAdImpression:(AlxRewardVideoAd * _Nonnull)ad;
- (void)rewardVideoAdClick:(AlxRewardVideoAd * _Nonnull)ad;
- (void)rewardVideoAdClose:(AlxRewardVideoAd * _Nonnull)ad;
- (void)rewardVideoAdPlayStart:(AlxRewardVideoAd * _Nonnull)ad;
- (void)rewardVideoAdPlayEnd:(AlxRewardVideoAd * _Nonnull)ad;
- (void)rewardVideoAdReward:(AlxRewardVideoAd * _Nonnull)ad;
- (void)rewardVideoAdPlayFail:(AlxRewardVideoAd * _Nonnull)ad didFailWithError:(NSError * _Nonnull)error;
@end

SWIFT_CLASS("_TtC6AlxAds6AlxSdk")
@interface AlxSdk : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
+ (void)initializeSDKWithToken:(NSString * _Nonnull)token sid:(NSString * _Nonnull)sid appId:(NSString * _Nonnull)appId;
+ (BOOL)isSDKInit SWIFT_WARN_UNUSED_RESULT;
+ (void)setDebug:(BOOL)debug;
+ (NSString * _Nonnull)getSDKName SWIFT_WARN_UNUSED_RESULT;
+ (NSString * _Nonnull)getSDKVersion SWIFT_WARN_UNUSED_RESULT;
+ (void)addExtraParametersWithKey:(NSString * _Nonnull)key value:(id _Nonnull)value;
+ (NSDictionary<NSString *, id> * _Nonnull)getExtraParameters SWIFT_WARN_UNUSED_RESULT;
+ (void)setGDPRConsent:(BOOL)value;
+ (void)setGDPRConsentMessage:(NSString * _Nonnull)value;
+ (void)setCOPPAConsent:(BOOL)value;
+ (void)setCCPA:(NSString * _Nonnull)value;
@end

#endif
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#if defined(__cplusplus)
#endif
#pragma clang diagnostic pop
#endif

#else
#error unsupported Swift architecture
#endif
