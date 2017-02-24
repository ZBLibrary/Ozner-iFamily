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

#import "KMSwizzle.h"
#import "KMWeakObjectContainer.h"
#import "UINavigationController+KMNavigationBarTransition.h"
#import "UIViewController+KMNavigationBarTransition.h"

FOUNDATION_EXPORT double KMNavigationBarTransitionVersionNumber;
FOUNDATION_EXPORT const unsigned char KMNavigationBarTransitionVersionString[];

