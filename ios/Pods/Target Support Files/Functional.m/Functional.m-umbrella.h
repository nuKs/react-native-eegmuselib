#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "F.h"
#import "NSArray+F.h"
#import "NSDictionary+F.h"
#import "NSNumber+F.h"

FOUNDATION_EXPORT double Functional_mVersionNumber;
FOUNDATION_EXPORT const unsigned char Functional_mVersionString[];

