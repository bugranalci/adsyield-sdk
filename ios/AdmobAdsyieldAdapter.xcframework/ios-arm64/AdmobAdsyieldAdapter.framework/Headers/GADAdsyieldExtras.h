

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GADAdsyieldErrorCode) {
    
    // Invalid parameters encountered(App ID、App Key orPlacement ID being nil)
    GADAdsyieldErrorInvalidServerParameters = 1014,
    // Ad source not filled, cause by customize fillter.
    GADAdsyieldErrorAdNoFill = 1030,
};

@interface GADAdsyieldExtras : NSObject

/// native
@property (nonatomic, assign) CGSize adSize;

/// native ad
@property (nonatomic, assign) BOOL isAdSizeToFit;


@end

NS_ASSUME_NONNULL_END
