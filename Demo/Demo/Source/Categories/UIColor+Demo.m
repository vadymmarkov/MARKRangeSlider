#import "UIColor+Demo.h"

@implementation UIColor (Demo)

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    // Bypass '#' character
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithHexString:@"#121314"];
}

+ (UIColor *)navBarBackgroundColor
{
    return [UIColor colorWithHexString:@"#0c0c0d"];
}

+ (UIColor *)navBarTextColor
{
    return [UIColor colorWithHexString:@"#84bd00"];
}

+ (UIColor *)navBarBackButtonColor
{
    return [UIColor colorWithHexString:@"#cbccd1"];
}

+ (UIColor *)mainTextColor
{
    return [UIColor colorWithHexString:@"#ffffff"];
}

+ (UIColor *)secondaryTextColor
{
    return [UIColor colorWithHexString:@"#cbccd1"];
}

@end
