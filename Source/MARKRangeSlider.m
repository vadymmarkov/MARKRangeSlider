#import "MARKRangeSlider.h"

static NSString * const kMARKRangeSliderThumbImage = @"rangeSliderThumb.png";
static NSString * const kMARKRangeSliderTrackImage = @"rangeSliderTrack.png";
static NSString * const kMARKRangeSliderTrackRangeImage = @"rangeSliderTrackRange.png";

@interface MARKRangeSlider ()

@property (nonatomic) UIImageView *trackImageView;
@property (nonatomic) UIImageView *rangeImageView;

@property (nonatomic) UIImageView *leftThumbImageView;
@property (nonatomic) UIImageView *rightThumbImageView;

@end

@implementation MARKRangeSlider

@synthesize trackImage = _trackImage;
@synthesize rangeImage = _rangeImage;
@synthesize leftThumbImage = _leftThumbImage;
@synthesize rightThumbImage = _rightThumbImage;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
        [self setUpViewComponents];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
        [self setUpViewComponents];
    }
    return self;
}

#pragma mark - Public

- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    self.maximumValue = maxValue;
    self.minimumValue = minValue;
}

- (void)setLeftValue:(CGFloat)leftValue rightValue:(CGFloat)rightValue {
    if (leftValue == 0 && rightValue == 0) {
        self.leftValue = leftValue;
        self.rightValue = rightValue;
    } else {
        self.rightValue = rightValue;
        self.leftValue = leftValue;
    }
}

#pragma mark - Configuration

- (void)setDefaults
{
    self.minimumValue = 0.0f;
    self.maximumValue = 1.0f;
    self.leftValue = self.minimumDistance;
    self.rightValue = self.maximumValue;
    self.minimumDistance = 0.2f;
}

- (void)setUpViewComponents
{
    self.multipleTouchEnabled = YES;

    // Init track image
    self.trackImageView = [[UIImageView alloc] initWithImage:self.trackImage];
    [self addSubview:self.trackImageView];

    // Init range image
    self.rangeImageView = [[UIImageView alloc] initWithImage:self.rangeImage];
    [self addSubview:self.rangeImageView];

    // Init left thumb image
    self.leftThumbImageView = [[UIImageView alloc] initWithImage:self.leftThumbImage];
    self.leftThumbImageView.userInteractionEnabled = YES;
    self.leftThumbImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.leftThumbImageView];

    // Add left pan recognizer
    UIPanGestureRecognizer *leftPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [self.leftThumbImageView addGestureRecognizer:leftPanRecognizer];

    // Init right thumb image
    self.rightThumbImageView = [[UIImageView alloc] initWithImage:self.rightThumbImage];
    self.rightThumbImageView.userInteractionEnabled = YES;
    self.rightThumbImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.rightThumbImageView];

    // Add right pan recognizer
    UIPanGestureRecognizer *rightPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [self.rightThumbImageView addGestureRecognizer:rightPanRecognizer];
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    CGFloat width = _trackImage.size.width + _leftThumbImage.size.width + _rightThumbImage.size.width;
    CGFloat height = MAX(_leftThumbImage.size.height, _rightThumbImage.size.height);

    return CGSizeMake(width, height);
}

- (void)layoutSubviews
{
    // Calculate coords & sizes
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);

    CGFloat trackHeight = _trackImage.size.height;

    CGSize leftThumbImageSize = self.leftThumbImageView.image.size;
    CGSize rightThumbImageSize = self.rightThumbImageView.image.size;

    CGFloat leftAvailableWidth = width - leftThumbImageSize.width;
    CGFloat rightAvailableWidth = width - rightThumbImageSize.width;
    if (self.disableOverlapping) {
        leftAvailableWidth -= leftThumbImageSize.width;
        rightAvailableWidth -= rightThumbImageSize.width;
    }

    CGFloat leftInset = leftThumbImageSize.width / 2;
    CGFloat rightInset = rightThumbImageSize.width / 2;

    CGFloat trackRange = self.maximumValue - self.minimumValue;

    CGFloat leftX = floorf((self.leftValue - self.minimumValue) / trackRange * leftAvailableWidth);
    if (isnan(leftX)) {
        leftX = 0.0;
    }

    CGFloat rightX = floorf((self.rightValue - self.minimumValue) / trackRange * rightAvailableWidth);
    if (isnan(rightX)) {
        rightX = 0.0;
    }

    CGFloat trackY = (height - trackHeight) / 2;
    CGFloat gap = 1.0;

    // Set track frame
    CGFloat trackX = gap;
    CGFloat trackWidth = width - gap * 2;
    if (self.disableOverlapping) {
        trackX += leftInset;
        trackWidth -= leftInset + rightInset;
    }
    self.trackImageView.frame = CGRectMake(trackX, trackY, trackWidth, trackHeight);

    // Set range frame
    CGFloat rangeWidth = rightX - leftX;
    if (self.disableOverlapping) {
        rangeWidth += rightInset + gap;
    }
    self.rangeImageView.frame = CGRectMake(leftX + leftInset, trackY, rangeWidth, trackHeight);

    // Set thumb image view frame sizes
    CGRect leftImageViewFrame = { CGPointMake(0, 0), leftThumbImageSize };
    CGRect rightImageViewFrame = { CGPointMake(0, 0), rightThumbImageSize };
    self.leftThumbImageView.frame = leftImageViewFrame;
    self.rightThumbImageView.frame = rightImageViewFrame;

    // Set left & right thumb frames
    leftX += leftInset;
    rightX += rightInset;
    if (self.disableOverlapping) {
        rightX = rightX + rightInset * 2 - gap;
    }
    self.leftThumbImageView.center = CGPointMake(leftX, height / 2);
    self.rightThumbImageView.center = CGPointMake(rightX, height / 2);
}

#pragma mark - Gesture recognition

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        //Fix when minimumDistance = 0.0 and slider is move to 1.0-1.0
        [self bringSubviewToFront:self.leftThumbImageView];

        CGPoint translation = [gesture translationInView:self];
        CGFloat trackRange = self.maximumValue - self.minimumValue;
        CGFloat width = CGRectGetWidth(self.frame) - CGRectGetWidth(self.leftThumbImageView.frame);

        // Change left value
        self.leftValue += translation.x / width * trackRange;

        [gesture setTranslation:CGPointZero inView:self];

        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        //Fix when minimumDistance = 0.0 and slider is move to 1.0-1.0
        [self bringSubviewToFront:self.rightThumbImageView];

        CGPoint translation = [gesture translationInView:self];
        CGFloat trackRange = self.maximumValue - self.minimumValue;
        CGFloat width = CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightThumbImageView.frame);

        // Change right value
        self.rightValue += translation.x / width * trackRange;

        [gesture setTranslation:CGPointZero inView:self];

        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Getters

- (UIView *)leftThumbView
{
    return self.leftThumbImageView;
}

- (UIView *)rightThumbView
{
    return self.rightThumbImageView;
}

- (UIImage *)trackImage
{
    if (!_trackImage) {
        _trackImage = [self bundleImageNamed: kMARKRangeSliderTrackImage];
    }
    return _trackImage;
}

- (UIImage *)rangeImage
{
    if (!_rangeImage) {
        _rangeImage = [self bundleImageNamed: kMARKRangeSliderTrackRangeImage];
    }
    return _rangeImage;
}

- (UIImage *)leftThumbImage
{
    if (!_leftThumbImage) {
        _leftThumbImage = [self bundleImageNamed: kMARKRangeSliderThumbImage];
    }
    return _leftThumbImage;
}

- (UIImage *)rightThumbImage
{
    if (!_rightThumbImage) {
        _rightThumbImage = [self bundleImageNamed: kMARKRangeSliderThumbImage];
    }
    return _rightThumbImage;
}

#pragma mark - Setters

- (void)setMinimumValue:(CGFloat)minimumValue
{
    if (minimumValue >= self.maximumValue) {
        minimumValue = self.maximumValue - self.minimumDistance;
    }

    if (self.leftValue < minimumValue) {
        self.leftValue = minimumValue;
    }

    if (self.rightValue < minimumValue) {
        self.rightValue = self.maximumValue;
    }

    _minimumValue = minimumValue;

    [self checkMinimumDistance];

    [self setNeedsLayout];
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    if (maximumValue <= self.minimumValue) {
        maximumValue = self.minimumValue + self.minimumDistance;
    }

    if (self.leftValue > maximumValue) {
        self.leftValue = self.minimumValue;
    }

    if (self.rightValue > maximumValue) {
        self.rightValue = maximumValue;
    }

    _maximumValue = maximumValue;

    [self checkMinimumDistance];

    [self setNeedsLayout];
}


- (void)setLeftValue:(CGFloat)leftValue
{
    CGFloat allowedValue = self.rightValue - self.minimumDistance;
    if (leftValue > allowedValue) {
        if (self.pushable) {
            CGFloat rightSpace = self.maximumValue - self.rightValue;
            CGFloat deltaLeft = self.minimumDistance - (self.rightValue - leftValue);
            if (deltaLeft > 0 && rightSpace > deltaLeft) {
                self.rightValue += deltaLeft;
            }
            else {
                leftValue = allowedValue;
            }
        }
        else {
            leftValue = allowedValue;
        }
    }

    if (leftValue < self.minimumValue) {
        leftValue = self.minimumValue;
        if (self.rightValue - leftValue < self.minimumDistance) {
            self.rightValue = leftValue + self.minimumDistance;
        }
    }

    _leftValue = leftValue;

    [self setNeedsLayout];
}

- (void)setRightValue:(CGFloat)rightValue
{
    CGFloat allowedValue = self.leftValue + self.minimumDistance;
    if (rightValue < allowedValue) {
        if (self.pushable) {
            CGFloat leftSpace = self.leftValue - self.minimumValue;
            CGFloat deltaRight = self.minimumDistance - (rightValue - self.leftValue);
            if (deltaRight > 0 && leftSpace > deltaRight) {
                self.leftValue -= deltaRight;
            }
            else {
                rightValue = allowedValue;
            }
        }
        else {
            rightValue = allowedValue;
        }
    }

    if (rightValue > self.maximumValue) {
        rightValue = self.maximumValue;
        if (rightValue - self.leftValue < self.minimumDistance) {
            self.leftValue = rightValue - self.minimumDistance;
        }
    }

    _rightValue = rightValue;

    [self setNeedsLayout];
}

- (void)setMinimumDistance:(CGFloat)minimumDistance
{
    CGFloat distance = self.maximumValue - self.minimumValue;
    if (minimumDistance > distance) {
        minimumDistance = distance;
    }

    if (self.rightValue - self.leftValue < minimumDistance) {
        // Reset left and right values
        self.leftValue = self.minimumValue;
        self.rightValue = self.maximumValue;
    }

    _minimumDistance = minimumDistance;

    [self setNeedsLayout];
}

#pragma mark - Setters

- (void)setTrackImage:(UIImage *)trackImage
{
    _trackImage = trackImage;
    self.trackImageView.image = _trackImage;
}

- (void)setRangeImage:(UIImage *)rangeImage
{
    _rangeImage = rangeImage;
    self.rangeImageView.image = _rangeImage;
}

- (void)setLeftThumbImage:(UIImage *)leftThumbImage
{
    _leftThumbImage = leftThumbImage;
    self.leftThumbImageView.image = _leftThumbImage;
}

- (void)setRightThumbImage:(UIImage *)rightThumbImage
{
    _rightThumbImage = rightThumbImage;
    self.rightThumbImageView.image = _rightThumbImage;
}

#pragma mark - Helpers

- (UIImage *)bundleImageNamed:(NSString *)imageName
{
    NSString *bundlePath = [[[NSBundle bundleForClass:self.class] resourcePath]
                            stringByAppendingPathComponent:@"MARKRangeSlider.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];
    if ([UITraitCollection class]) {
        // Use default traits associated with main screen
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        // Backward compatible for pre iOS 8
        return [self imageNamed:imageName inBundle:bundle];
    }
}

- (UIImage *)imageNamed:(NSString *)imageName inBundle:(NSBundle *)bundle
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        NSInteger scale = [[UIScreen mainScreen] scale];
        NSString *scalledImagePath = [[bundle resourcePath]
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@%dx.%@",
                                                            [imageName stringByDeletingPathExtension],
                                                            scale,
                                                            [imageName pathExtension]]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:scalledImagePath]) {
            return [[UIImage alloc] initWithContentsOfFile:scalledImagePath];
        }
    }
    return nil;
}

- (void)checkMinimumDistance
{
    if (self.maximumValue - self.minimumValue < self.minimumDistance) {
        self.minimumDistance = 0.0f;
    }
}

@end
