//
//  TZNotif
//
//  Created by Tomasz Zablocki on 19/10/2012.
//  Copyright (c) 2012 Tomasz Zablocki. All rights reserved.
//
typedef enum {
	TZNotifBehaviorDefault,
	TZNotifBehaviorTopFromTopToTop,
	TZNotifBehaviorMax,
} TZNotifBehavior;

typedef enum {
	TZNotifStyleDefault,
	TZNotifStyleGrayAndWhite,
	TZNotifStyleMax,
} TZNotifStyle;

@interface TZNotif : UIView

// Sets style for all notifications
+ (void)setupNotificationsWithStyle:(TZNotifStyle)style
                              delay:(NSTimeInterval)delay
                   heightPercentage:(CGFloat)heightPercentage
                          behaviour:(TZNotifBehavior)behavior
                           fontName:(NSString *)fontName;

// Shows notification for specified amount of time
+ (void)showString:(NSString *)string;

@end

