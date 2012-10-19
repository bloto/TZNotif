Purpose
--------------
TZNotif is class that adds notifications functionality any iOS application.

Supported OS & SDK Versions
-----------------------------

* Created & tested on iOS 6.0 (Xcode 4.5)

ARC Compatibility
------------------

Class is designed to be used under ARC.

Installation
--------------

To use the TZNotif in your app, just drag the TZNotif class files (demo files and assets are not needed) into your project.

How to use
-----------
Import:
#import "TZNotif.h"

Initialization:
[TZNotif setupNotificationsWithStyle:TZNotifStyleDefault delay:2 heightPercentage:0.05f behaviour:TZNotifBehaviorDefault fontName:@"Helvetica Neue"];

Usage:
[TZNotif showString:@"Here I am, nice notification for you"];

