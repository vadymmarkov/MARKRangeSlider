//
//  UIColor+Demo.h
//  Demo
//
//  Created by Vadym Markov on 2/5/15.
//  Copyright (c) 2015 Vadym Markov. All rights reserved.
//

@import UIKit;

@interface UIColor (Demo)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)backgroundColor;
+ (UIColor *)navBarBackgroundColor;
+ (UIColor *)navBarTextColor;
+ (UIColor *)mainTextColor;
+ (UIColor *)secondaryTextColor;

@end
