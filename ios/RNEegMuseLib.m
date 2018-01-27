#import <Muse/Muse.h>
#import "RNEegMuseLib.h"

#if __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import <React/RCTLog.h>
#endif

@implementation RNEegMuseLib

RCT_EXPORT_MODULE()

/*
- (id) init
{
    self = [super init];
    
    if (self) {
        self._allMuses = nil;
        self._connectedMuses = nil;
        
        RCTLogInfo(@"My super first Init :)");
    }
    
    return self;
}
*/

//// Use the main app thread.
//- (dispatch_queue_t) methodQueue
//{
//    return dispatch_get_main_queue();
//}

//// Export constants to javascript
//- (NSDictionary *) constantsToExport
//{
//    return @{ @"FrameworkVersion": @"6.0.8" };
//}

//RCT_EXPORT_METHOD(addEvent: (NSString *)name location: (NSString *)location)
//{
//    RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
//}

@end
