//
//  MARKRangeSliderTests.m
//  MARKRangeSliderDemo
//
//  Created by Vadym Markov on 2/8/15.
//  Copyright (c) 2015 Vadym Markov. All rights reserved.
//

@import UIKit;
@import XCTest;

#import "MARKRangeSlider.h"

@interface MARKRangeSlider ()

@property (nonatomic) UIImageView *trackImageView;
@property (nonatomic) UIImageView *rangeImageView;

@property (nonatomic) UIImageView *leftThumbImageView;
@property (nonatomic) UIImageView *rightThumbImageView;

@end

@interface MARKRangeSliderTests : XCTestCase

@property (nonatomic, strong) MARKRangeSlider *rangeSlider;

@end

@implementation MARKRangeSliderTests

- (void)setUp
{
    [super setUp];

    self.rangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)];
}

- (void)tearDown
{
    self.rangeSlider = nil;
    [super tearDown];
}

- (void)testDefaultsAfterInit
{
    XCTAssertEqual(self.rangeSlider.minimumValue, 0.0f, @"Minimum value is %f but it should be %f", self.rangeSlider.minimumValue, 0.0f);
    XCTAssertEqual(self.rangeSlider.maximumValue, 1.0f, @"Maximum value is %f but it should be %f", self.rangeSlider.maximumValue, 0.0f);
    XCTAssertEqual(self.rangeSlider.leftValue, 0.0f, @"Left value is %f but it should be %f", self.rangeSlider.leftValue, 0.0);
    XCTAssertEqual(self.rangeSlider.rightValue, 1.0f, @"Right value is %f but it should be %f", self.rangeSlider.rightValue, 0.0f);
    XCTAssertEqual(self.rangeSlider.minimumDistance, 0.2f, @"Minimum distance value is %f but it should be %f", self.rangeSlider.minimumDistance, 0.0);
}

- (void)testImagesAreSetProperly
{
    UIImage *image = [[UIImage alloc] init];

    self.rangeSlider.trackImage = image;
    XCTAssertEqualObjects(self.rangeSlider.trackImage, image, @"Track image does not set properly");

    self.rangeSlider.rangeImage = image;
    XCTAssertEqualObjects(self.rangeSlider.rangeImage, image, @"Range image does not set properly");

    self.rangeSlider.leftThumbImage = image;
    XCTAssertEqualObjects(self.rangeSlider.leftThumbImage, image, @"Left thumb image does not set properly");

    self.rangeSlider.rightThumbImage = image;
    XCTAssertEqualObjects(self.rangeSlider.rightThumbImage, image, @"Right thumb image does not set properly");
}

#pragma mark - Minumum value tests

- (void)testSetMinimumValueGreaterThanOeEqualToMaximumValue
{
    self.rangeSlider.maximumValue = 1.0f;
    self.rangeSlider.minimumValue = 1.2f;

    XCTAssertEqual(self.rangeSlider.minimumValue, self.rangeSlider.maximumValue - self.rangeSlider.minimumDistance, @"Minimum value should be less than maximum value");
    self.rangeSlider.minimumValue = 1.0;
    XCTAssertEqual(self.rangeSlider.minimumValue, self.rangeSlider.maximumValue - self.rangeSlider.minimumDistance, @"Minimum value should be less than maximum value");
}

- (void)testSetMinimumValueGreaterThanLeftValue
{
    self.rangeSlider.leftValue = 0.3;
    self.rangeSlider.minimumValue = 0.4;

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should be equal to minimum value");
}

- (void)testSetMinimumValueGreaterThanRightValue
{
    self.rangeSlider.rightValue = 1.0;
    self.rangeSlider.minimumValue = 1.2;

    XCTAssertGreaterThanOrEqual(self.rangeSlider.rightValue, self.rangeSlider.minimumValue, @"Right value should be greater than or equal to minimum value");
    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should be equal to maximum value");
}

#pragma mark - Maximum value tests

- (void)testSetMaximumValueLessThanOeEqualToMinimumValue
{
    self.rangeSlider.minimumValue = 0.5;
    self.rangeSlider.maximumValue = 0.4;

    XCTAssertEqual(self.rangeSlider.maximumValue, self.rangeSlider.minimumValue + self.rangeSlider.minimumDistance, @"Maximum value should be greater than maximum value");
    self.rangeSlider.maximumValue = 0.5;
    XCTAssertEqual(self.rangeSlider.maximumValue, self.rangeSlider.minimumValue + self.rangeSlider.minimumDistance, @"Maximum value should be greater than maximum value");
}

- (void)testSetMaximumValueLessThanLeftValue
{
    self.rangeSlider.leftValue = 0.3;
    self.rangeSlider.maximumValue = 0.2;

    XCTAssertLessThan(self.rangeSlider.leftValue, self.rangeSlider.maximumValue, @"Left value should be less than maximum value");
    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should be equal to minimum value");
}

- (void)testSetMaximumValueLessThanRightValue
{
    self.rangeSlider.rightValue = 1.0;
    self.rangeSlider.maximumValue = 0.8;

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should be equal to maximum value");
}

#pragma mark - Left value tests

- (void)testSetLeftValueExceedsMinimumDistance
{
    self.rangeSlider.rightValue = 1.0;
    self.rangeSlider.minimumDistance = 0.2;
    self.rangeSlider.leftValue = 0.9;

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.rightValue - self.rangeSlider.minimumDistance, @"Left value should not exceed minimum distance with right value");
}

- (void)testSetLeftValueExceedsMinimumDistanceAndLessThanMinimumValue
{
    self.rangeSlider.minimumValue = 0.0;
    self.rangeSlider.maximumValue = 1.0;
    self.rangeSlider.minimumDistance = 0.2;
    self.rangeSlider.rightValue = 0.1;
    self.rangeSlider.leftValue = 0.1;

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.rightValue - self.rangeSlider.minimumDistance, @"Left value should not exceed minimum distance with right value");
    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should be equal to minimum value");
}

- (void)testSetLeftValueLessThanMinimumValue
{
    self.rangeSlider.minimumValue = 0.2;
    self.rangeSlider.leftValue = 0.1;

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should not be less than minimum value");
}

#pragma mark - Right value tests

- (void)testSetRightValueExceedsMinimumDistance
{
    self.rangeSlider.leftValue = 0.5;
    self.rangeSlider.minimumDistance = 0.2;
    self.rangeSlider.rightValue = 0.6;

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.leftValue + self.rangeSlider.minimumDistance, @"Right value should not exceed minimum distance with left value");
}

- (void)testSetRightValueGreaterThanMaximumValue
{
    self.rangeSlider.maximumValue = 1.0;
    self.rangeSlider.rightValue = 1.1;

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should not be greater than maximum value");
}

- (void)testSetRightValueExceedsMinimumDistanceAndGreaterThanMaximumValue
{
    self.rangeSlider.minimumValue = 0.0;
    self.rangeSlider.maximumValue = 1.0;
    self.rangeSlider.minimumDistance = 0.2;
    self.rangeSlider.leftValue = 0.9;
    self.rangeSlider.rightValue = 0.9;

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.leftValue + self.rangeSlider.minimumDistance, @"Right value should not exceed minimum distance with left value");
    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should be equal to maximum value");
}

#pragma mark - Minimum distance tests

- (void)testSetMinimumDistanceGreaterThanRangeDistance
{
    self.rangeSlider.minimumValue = 0.0;
    self.rangeSlider.maximumValue = 1.0;
    self.rangeSlider.minimumDistance = 2.0;

    XCTAssertEqual(self.rangeSlider.minimumDistance, self.rangeSlider.maximumValue - self.rangeSlider.minimumValue, @"Minimum distance should not exceed range distance");
}

- (void)testSetMinimumDistanceConflictsWithDistanceBetweenRightAndLeftValues
{
    self.rangeSlider.leftValue = 0.2;
    self.rangeSlider.rightValue = 0.5;
    self.rangeSlider.minimumDistance = 0.5;

    XCTAssertEqual(self.rangeSlider.minimumDistance, 0.5, @"Minimum distance does not set properly");
    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should equal to minimum value");
    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should equal to maximum value");
}

- (void)testSetTrackImage
{
    UIImage *image = [[UIImage alloc] init];
    self.rangeSlider.trackImage = image;
    XCTAssertEqualObjects(self.rangeSlider.trackImageView.image, image, @"Track image does not set properly");
}

- (void)testSetRangeImage
{
    UIImage *image = [[UIImage alloc] init];
    self.rangeSlider.rangeImage = image;
    XCTAssertEqualObjects(self.rangeSlider.rangeImageView.image, image, @"Range image does not set properly");
}

- (void)testSetLeftThumbImage
{
    UIImage *image = [[UIImage alloc] init];
    self.rangeSlider.leftThumbImage = image;
    XCTAssertEqualObjects(self.rangeSlider.leftThumbImageView.image, image, @"Left thumb image does not set properly");
}

- (void)testSetRightThumbImage
{
    UIImage *image = [[UIImage alloc] init];
    self.rangeSlider.rightThumbImage = image;
    XCTAssertEqualObjects(self.rangeSlider.rightThumbImageView.image, image, @"Right thumb image does not set properly");
}

- (void)testCheckMinimumDistance
{
    self.rangeSlider.minimumDistance = 0.2;
    self.rangeSlider.minimumValue = 0.4;
    self.rangeSlider.maximumValue = 0.5;

    XCTAssertEqual(self.rangeSlider.minimumDistance, 0.0f, @"Minimum distance should be equal to 0.0");
}

@end
