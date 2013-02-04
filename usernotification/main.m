//
//  main.m
//  usernotification
//
//    (The WTFPL)
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    Version 2, December 2004
//
//    Copyright (C) 2013 Norio Nomura
//
//    Everyone is permitted to copy and distribute verbatim or modified
//    copies of this license document, and changing it is allowed as long
//    as the name is changed.
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
//    0. You just DO WHAT THE FUCK YOU WANT TO.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


#pragma mark - Swizzle NSBundle

NSString *fakeBundleIdentifier = nil;

@implementation NSBundle(swizle)

// Overriding bundleIdentifier works, but overriding NSUserNotificationAlertStyle does not work.

- (NSString *)__bundleIdentifier
{
    if (self == [NSBundle mainBundle]) {
        return fakeBundleIdentifier ? fakeBundleIdentifier : @"com.apple.finder";
    } else {
        return [self __bundleIdentifier];
    }
}

@end

BOOL installNSBundleHook()
{
    Class class = objc_getClass("NSBundle");
    if (class) {
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(bundleIdentifier)),
                                       class_getInstanceMethod(class, @selector(__bundleIdentifier)));
        return YES;
    }
	return NO;
}


#pragma mark - NotificationCenterDelegate

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate>

@property (nonatomic, assign) BOOL keepRunning;

@end

@implementation NotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    self.keepRunning = NO;
}

@end


#pragma mark -

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (installNSBundleHook()) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            fakeBundleIdentifier = [defaults stringForKey:@"identifier"];
            
            NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
            NotificationCenterDelegate *ncDelegate = [[NotificationCenterDelegate alloc]init];
            ncDelegate.keepRunning = YES;
            nc.delegate = ncDelegate;
            
            NSUserNotification *note = [[NSUserNotification alloc] init];
            note.title = [defaults stringForKey:@"title"];
            note.subtitle = [defaults stringForKey:@"subtitle"];
            note.informativeText = [defaults stringForKey:@"informativeText"];
            
            if (!(note.title || note.subtitle || note.informativeText)) {
                note.title = @"Usage: usernotification";
                note.informativeText = @"Options: [-identifier <IDENTIFIER>] [-title <TEXT>] [-subtitle TEXT] [-informativeText TEXT]";
            }
            
            [nc deliverNotification:note];
            
            while (ncDelegate.keepRunning) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            }
        }
    }
    return 0;
}
