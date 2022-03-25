#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(PsVideoViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(color, NSString)
RCT_EXPORT_VIEW_PROPERTY(url, NSString)
RCT_EXPORT_VIEW_PROPERTY(play, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(paused, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(onBuffering, RCTBubblingEventBlock)
@end
