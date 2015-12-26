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
    [self.rangeSlider setMinValue:1.2f maxValue:1.0f];

    XCTAssertEqual(self.rangeSlider.minimumValue, self.rangeSlider.maximumValue - self.rangeSlider.minimumDistance, @"Minimum value should be less than maximum value");

    [self.rangeSlider setMinValue:1.0f maxValue:1.0f];
    XCTAssertEqual(self.rangeSlider.minimumValue, self.rangeSlider.maximumValue - self.rangeSlider.minimumDistance, @"Minimum value should be less than maximum value");
}

- (void)testSetMinimumValueGreaterThanLeftValue
{
    [self.rangeSlider setLeftValue:0.3 rightValue:1.0];
    [self.rangeSlider setMinValue:0.4f maxValue:1.0f];

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should be equal to minimum value");
}

- (void)testSetMinimumValueGreaterThanRightValue
{
    [self.rangeSlider setLeftValue:0.0 rightValue:1.0];
    [self.rangeSlider setMinValue:1.2f maxValue:1.0f];

    XCTAssertGreaterThanOrEqual(self.rangeSlider.rightValue, self.rangeSlider.minimumValue, @"Right value should be greater than or equal to minimum value");
    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should be equal to maximum value");
}

#pragma mark - Maximum value tests

- (void)testSetMaximumValueLessThanOeEqualToMinimumValue
{
    [self.rangeSlider setMinValue:0.5f maxValue:0.4f];

    XCTAssertEqual(self.rangeSlider.maximumValue, self.rangeSlider.minimumValue + self.rangeSlider.minimumDistance, @"Maximum value should be greater than maximum value");

    [self.rangeSlider setMinValue:0.5f maxValue:0.5f];
    XCTAssertEqual(self.rangeSlider.maximumValue, self.rangeSlider.minimumValue + self.rangeSlider.minimumDistance, @"Maximum value should be greater than maximum value");
}

- (void)testSetMaximumValueLessThanLeftValue
{
    [self.rangeSlider setLeftValue:0.3 rightValue:1.0];
    [self.rangeSlider setMinValue:0.0f maxValue:0.2f];

    XCTAssertLessThan(self.rangeSlider.leftValue, self.rangeSlider.maximumValue, @"Left value should be less than maximum value");
    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should be equal to minimum value");
}

- (void)testSetMaximumValueLessThanRightValue
{
    [self.rangeSlider setLeftValue:0.0 rightValue:1.0];
    [self.rangeSlider setMinValue:0.0f maxValue:0.8f];

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should be equal to maximum value");
}

#pragma mark - Left value tests

- (void)testSetLeftValuePushesRightValue
{
    self.rangeSlider.pushable = YES;
    self.rangeSlider.minimumDistance = 0.2;
    [self.rangeSlider setLeftValue:0.6 rightValue:0.7];

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.leftValue + self.rangeSlider.minimumDistance, @"Right value should be equal to left value plus minimum distance");
}

- (void)testSetLeftValueDoesntPushRightValue
{
    self.rangeSlider.pushable = YES;
    self.rangeSlider.minimumDistance = 0.2;
    [self.rangeSlider setLeftValue:0.9 rightValue:1.0];

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.rightValue - self.rangeSlider.minimumDistance, @"Left value should be equal to right value minus minimum distance");
}

- (void)testSetLeftValueExceedsMinimumDistance
{
    self.rangeSlider.minimumDistance = 0.2;
    [self.rangeSlider setLeftValue:0.9 rightValue:1.0];

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.rightValue - self.rangeSlider.minimumDistance, @"Left value should not exceed minimum distance with right value");
}

- (void)testSetLeftValueExceedsMinimumDistanceAndLessThanMinimumValue
{
    [self.rangeSlider setMinValue:0.0f maxValue:1.0f];
    self.rangeSlider.minimumDistance = 0.2;
    [self.rangeSlider setLeftValue:0.1 rightValue:0.1];

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.rightValue - self.rangeSlider.minimumDistance, @"Left value should not exceed minimum distance with right value");
    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should be equal to minimum value");
}

- (void)testSetLeftValueLessThanMinimumValue
{
    [self.rangeSlider setMinValue:0.2f maxValue:1.0f];
    [self.rangeSlider setLeftValue:0.1 rightValue:1.0];

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.minimumValue, @"Left value should not be less than minimum value");
}

#pragma mark - Right value tests

- (void)testSetRightValuePushesLeftValue
{
    self.rangeSlider.pushable = YES;
    self.rangeSlider.minimumDistance = 0.2f;
    [self.rangeSlider setLeftValue:0.6f rightValue:0.7f];

    XCTAssertEqual(self.rangeSlider.leftValue, self.rangeSlider.rightValue - self.rangeSlider.minimumDistance, @"Left value should be equal to right value minus minimum distance");
}

- (void)testSetRightValueDoesntPushLeftValue
{
    self.rangeSlider.pushable = YES;
    self.rangeSlider.minimumDistance = 0.2;
    [self.rangeSlider setLeftValue:0.0 rightValue:0.1];

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.leftValue + self.rangeSlider.minimumDistance, @"Right value should be equal to left value plus minimum distance");
}

- (void)testSetRightValueExceedsMinimumDistance
{
    self.rangeSlider.minimumDistance = 0.2;
    [self.rangeSlider setLeftValue:0.5 rightValue:0.6];

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.leftValue + self.rangeSlider.minimumDistance, @"Right value should not exceed minimum distance with left value");
}

- (void)testSetRightValueGreaterThanMaximumValue
{
    [self.rangeSlider setMinValue:0.0f maxValue:1.0f];
    [self.rangeSlider setLeftValue:0.0 rightValue:1.1];

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.maximumValue, @"Right value should not be greater than maximum value");
}

- (void)testSetRightValueExceedsMinimumDistanceAndGreaterThanMaximumValue
{
    [self.rangeSlider setMinValue:0.0f maxValue:1.0f];
    [self.rangeSlider setLeftValue:0.9f rightValue:0.9f];

    XCTAssertEqual(self.rangeSlider.rightValue, self.rangeSlider.leftValue + self.rangeSlider.minimumDistance, @"Right value should not exceed minimum distance with left value");
}

#pragma mark - Minimum distance tests

- (void)testSetMinimumDistanceGreaterThanRangeDistance
{
    [self.rangeSlider setMinValue:0.0f maxValue:1.0f];
    self.rangeSlider.minimumDistance = 2.0;

    XCTAssertEqual(self.rangeSlider.minimumDistance, self.rangeSlider.maximumValue - self.rangeSlider.minimumValue, @"Minimum distance should not exceed range distance");
}

- (void)testSetMinimumDistanceConflictsWithDistanceBetweenRightAndLeftValues
{
    [self.rangeSlider setLeftValue:0.2 rightValue:0.5];
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
    [self.rangeSlider setMinValue:0.4f maxValue:0.5f];

    XCTAssertEqual(self.rangeSlider.minimumDistance, 0.0f, @"Minimum distance should be equal to 0.0");
}

@end
