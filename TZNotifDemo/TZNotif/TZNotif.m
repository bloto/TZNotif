//
//  TZNotif
//
//  Created by Tomasz Zablocki on 19/10/2012.
//  Copyright (c) 2012 Tomasz Zablocki. All rights reserved.
//
#import "TZNotif.h"
#import "QuartzCore/QuartzCore.h"

// Defines how much height will be used by text in notification box
#define NOTIF_TO_STRING_RATIO 1.5

// Let's name these globals as they were class ivars
static TZNotifStyle _style;
static NSTimeInterval _delay;
static CGFloat _heightInPoints;
static TZNotifBehavior _behavior;
static UIFont *_font;
static NSInteger _activeNotifs = 0;
static NSInteger _nextNotifPosition = 0;

@interface TZNotif ()
- (id)initWithString:(NSString *)string;
- (void)animate;
@end

@implementation TZNotif

// Sets style for all notifications
// This function should be therefore called from AppDelegate's didFinishLaunchingWithOptions
+ (void)setupNotificationsWithStyle:(TZNotifStyle)style
                              delay:(NSTimeInterval)delay
                   heightPercentage:(CGFloat)heightPercentage
                          behaviour:(TZNotifBehavior)behavior
                           fontName:(NSString *)fontName
{
    // this gives me thread safety here
    dispatch_async(dispatch_get_main_queue(), ^{
        _style = style;
        _delay = delay;
        _behavior = behavior;
        
        CGSize windowSize = [[TZNotif visibleWindow] frame].size;// always the same regardless of orientation
        _heightInPoints = heightPercentage * windowSize.height;
        _font = [UIFont fontWithName:fontName size:_heightInPoints / NOTIF_TO_STRING_RATIO];
    });
}

+ (UIWindow *)visibleWindow
{
    // I assume there is only one window, this is not always true
    return [[UIApplication sharedApplication].windows objectAtIndex:0];
}

// Shows notification for specified amount of time
+ (void)showString:(NSString *)string
{
    // all UIView manipulations must go from main thread, thread safety by the way
    dispatch_async(dispatch_get_main_queue(), ^{
        TZNotif *notification = [[TZNotif alloc] initWithString:string];
        [notification animate];
        // Add to subview because we want orientation, transform and translation events
        [[[[TZNotif visibleWindow] subviews] objectAtIndex:0] addSubview:notification];
    });
}

- (id)initWithString:(NSString *)string
{
    if (self = [super init])
    {
        CGSize stringSize = [string sizeWithFont:_font];
        // initial position
        self.frame = CGRectMake(0, 0, stringSize.width + 2 * (_heightInPoints - stringSize.height), _heightInPoints);
        
        // set label to be the same size, text will be smaller anyway
        UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
        switch(_style)
        {
            case TZNotifStyleDefault:
            case TZNotifStyleGrayAndWhite:
                [self setBackgroundColor:[UIColor grayColor]];
                [self setAlpha:0.5f];
                [self.layer setCornerRadius:5.0f];
                [label setTextColor:[UIColor whiteColor]];
                break;
            default:
                break;
        };
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:_font];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:string];
        [self addSubview:label];
    }
    return self;
}

- (void)animate
{
    switch(_behavior)
    {
        case TZNotifBehaviorDefault:
        case TZNotifBehaviorTopFromTopToTop:
        {
            // initial position over window
            CGSize windowSize = [[[[TZNotif visibleWindow] subviews] objectAtIndex:0] bounds].size;// takes orientation into account
            [self setCenter:CGPointMake(windowSize.width/2, -_heightInPoints / 2)];
            
            // make it transformable to new orientation
            [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
            
            // animations
            [UIView animateWithDuration:_delay / 3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self setCenter:CGPointMake(self.center.x, self.center.y + _heightInPoints * 1.2 + _heightInPoints * (CGFloat)_nextNotifPosition)];
                                 _activeNotifs++;
                                 _nextNotifPosition++;
                             }
                             completion:^(BOOL finished){
                                 //if (finished) { // in case of orientation change we do it anyway
                                 [UIView animateWithDuration:_delay / 3
                                                       delay:_delay
                                                     options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{
                                                      [self setCenter:CGPointMake(self.center.x, - _heightInPoints/2)]; //fully hidden
                                                  }
                                                  completion:^(BOOL finished){
                                                      //if (finished) { // in case of orientation change we do it anyway
                                                      _activeNotifs--;
                                                      if (_activeNotifs == 0)
                                                      {
                                                          _nextNotifPosition = 0;
                                                      }
                                                      [self removeFromSuperview];
                                                  }
                                  ];
                             }
             ];
        }
            break;
        default:
        {
        }
            break;
    };
}

@end