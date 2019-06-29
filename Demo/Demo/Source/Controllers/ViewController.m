#import "ViewController.h"
#import "MARKRangeSlider.h"
#import "UIColor+Demo.h"

static CGFloat const kViewControllerRangeSliderWidth = 290.0;
static CGFloat const kViewControllerLabelWidth = 100.0;

@interface ViewController ()

@property (nonatomic, strong) MARKRangeSlider *rangeSlider;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Additional setup after loading the view
    self.title = @"Slider Demo";
    self.view.backgroundColor = [UIColor backgroundColor];
    [self setUpViewComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat labelX = (CGRectGetWidth(self.view.frame) - kViewControllerLabelWidth) / 2;
    self.label.frame = CGRectMake(labelX, 110.0, kViewControllerLabelWidth, 20.0);

    CGFloat sliderX = (CGRectGetWidth(self.view.frame) - kViewControllerRangeSliderWidth) / 2;
    self.rangeSlider.frame = CGRectMake(sliderX, CGRectGetMaxY(self.label.frame) + 20.0, 290.0, 20.0);
}

#pragma mark - Actions

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    [self updateRangeText];
}

#pragma mark - UI

- (void)setUpViewComponents
{
    // Text label
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.backgroundColor = [UIColor backgroundColor];
    self.label.numberOfLines = 1;
    self.label.textColor = [UIColor secondaryTextColor];

    // Init slider
    self.rangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectZero];
    self.rangeSlider.backgroundColor = [UIColor backgroundColor];
    [self.rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    self.rangeSlider.sendInstantUpdates = YES;
    [self.rangeSlider setMinValue:0.0 maxValue:1.0];
    [self.rangeSlider setLeftValue:0.2 rightValue:0.7];

    self.rangeSlider.minimumDistance = 0.2;

    [self updateRangeText];

    [self.view addSubview:self.label];
    [self.view addSubview:self.rangeSlider];
}

- (void)updateRangeText
{
    NSLog(@"%0.2f - %0.2f", self.rangeSlider.leftValue, self.rangeSlider.rightValue);
    self.label.text = [NSString stringWithFormat:@"%0.2f - %0.2f",
                       self.rangeSlider.leftValue, self.rangeSlider.rightValue];
}

@end
