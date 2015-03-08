//
//  MARKRangeSlider.h
//  MARKRangeSlider
//
//  Created by Vadym Markov on 2/7/15.
//  Copyright (c) 2015 Vadym Markov. All rights reserved.
//

@import UIKit;

@interface MARKRangeSlider : UIControl

// Values
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;

@property (nonatomic, assign) CGFloat minimumDistance;

// Images
@property (nonatomic) UIImage *trackImage;
@property (nonatomic) UIImage *rangeImage;

@property (nonatomic) UIImage *leftThumbImage;
@property (nonatomic) UIImage *rightThumbImage;

@end
