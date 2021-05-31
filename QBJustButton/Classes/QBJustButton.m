//
//  QBJustButton.m
//  QBJustButton
//
//  Created by quan bui on 2021/05/31.
//

#import "QBJustButton.h"

@interface QBJustButton()

/** Track button tapped state*/
@property (nonatomic, assign) BOOL isTapped;

/** Container view*/
@property (nonatomic, strong) UIView *containerView;

/** Title label diplay text in the center of the button*/
@property (nonatomic, strong) UILabel *titleLabel;

/** Background view display the rounded box behind the text*/
@property (nonatomic, strong) UIView *backgroundView;

/** Label background color*/
@property (nonatomic, readonly) UIColor *labelBackgroundColor;

@end

# pragma mark - QBJustButton -
@implementation QBJustButton

- (instancetype)initWithTitle:(NSString *)text {
    self = [super initWithFrame:CGRectMake(0, 0, 288.0f, 50.0f)];
    if (self) {
        [self commonInit];
        _titleLabel.text = text;
        [_titleLabel sizeToFit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _cornerRadius = (_cornerRadius > FLT_EPSILON) ?: 4.0f;
    _tappedTitleAlpha = (_tappedTitleAlpha > FLT_EPSILON) ?: 1.0f;
    _tappedButtonScale = (_tappedButtonScale > FLT_EPSILON) ?: 0.96f;
    _tappedAnimationDuration = (_tappedAnimationDuration > FLT_EPSILON) ?: 0.4f;

    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerView.clipsToBounds = YES;
    self.containerView.userInteractionEnabled = NO;
    [self addSubview:self.containerView];

    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = self.tintColor;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.layer.cornerRadius = self.cornerRadius;
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        self.backgroundView.layer.cornerCurve = kCACornerCurveContinuous;
    }
#endif
    [self.containerView addSubview:self.backgroundView];

    UIFont *font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular];
    if (@available(iOS 11.0, *)) {
        UIFontMetrics *metric = [[UIFontMetrics alloc] initForTextStyle:UIFontTextStyleBody];
        font = [metric scaledFontForFont:font];
    }
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = font;
    self.titleLabel.backgroundColor = self.labelBackgroundColor;
    self.titleLabel.text = @"Button";
    self.titleLabel.numberOfLines = 0;
    [self.containerView addSubview:self.titleLabel];

    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchDownInside) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDownRepeat];
    [self addTarget:self action:@selector(dragInside) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(dragOutside) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchCancel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.center = self.containerView.center;
    self.titleLabel.frame = CGRectIntegral(self.titleLabel.frame);
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.titleLabel.backgroundColor = self.labelBackgroundColor;
    self.backgroundView.backgroundColor = self.tintColor;
    [self setNeedsLayout];
}

- (UIColor *)labelBackgroundColor {
    if (self.isTapped) {
        return [UIColor clearColor];
    }
    BOOL isClear = CGColorGetAlpha(self.tintColor.CGColor) < (1.0f - FLT_EPSILON);
    return  isClear ? [UIColor clearColor] : self.tintColor;
}

- (void)touchDownInside {
    self.isTapped = YES;
    [self setLabelAlphaTappedAnimation:NO];
    [self setBackgroundColorTappedAnimation:YES];
    [self setButtonScaleTappedAnimation:YES];
}

- (void)touchUpInside {
    self.isTapped = NO;
    [self setLabelAlphaTappedAnimation:YES];
    [self setBackgroundColorTappedAnimation:YES];
    [self setButtonScaleTappedAnimation:YES];
    [self sendActionsForControlEvents:UIControlEventPrimaryActionTriggered];

    if (self.tap) { self.tap(); }
}

- (void)dragOutside {
    self.isTapped = NO;
    [self setLabelAlphaTappedAnimation:YES];
    [self setBackgroundColorTappedAnimation:YES];
    [self setButtonScaleTappedAnimation:YES];
}

- (void)dragInside {
    self.isTapped = YES;
    [self setLabelAlphaTappedAnimation:YES];
    [self setBackgroundColorTappedAnimation:YES];
    [self setButtonScaleTappedAnimation:YES];
}

- (void)setLabelAlphaTappedAnimation:(BOOL)animated {
    if (self.tappedTitleAlpha > 1.0f - FLT_EPSILON) { return; }
    CGFloat alpha = self.isTapped ? self.tappedTitleAlpha : 1.0f;

    // animate block alpha
    void (^animateBlock)(void) = ^{
        self.titleLabel.alpha = alpha;
    };

    if (!animated) {
        [self.titleLabel.layer removeAnimationForKey:@"opacity"];
        animateBlock();
        return;
    }

    self.titleLabel.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:self.tappedAnimationDuration
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animateBlock
                     completion:nil];
}

- (void)setButtonScaleTappedAnimation:(BOOL)animated {
    if (self.tappedButtonScale < FLT_EPSILON) { return; }
    CGFloat scale = self.isTapped ? self.tappedButtonScale : 1.0f;

    void (^animateBlock)(void) = ^{
        self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    };

    if (!animated) {
        animateBlock();
        return;
    }

    [UIView animateWithDuration:self.tappedAnimationDuration
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animateBlock
                     completion:nil];
}

- (void)setBackgroundColorTappedAnimation:(BOOL)animated {
    if (!self.tappedBackgroundColor) { return; }

    void (^updateTitleBackground)(void) = ^{
        self.titleLabel.backgroundColor = self.labelBackgroundColor;
    };
    void (^animateBlock)(void) = ^{
        self.backgroundView.backgroundColor = self.isTapped ? self.tappedBackgroundColor : self.tintColor;
    };
    void (^completionBlock)(BOOL) = ^(BOOL completed){
        if (completed == NO) { return; }
        updateTitleBackground();
    };
    
    if (!animated) {
        animateBlock();
        completionBlock(YES);
    } else {
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:self.tappedAnimationDuration
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:0.5f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:animateBlock
                         completion:completionBlock];
    }
}

#pragma mark -Public properties-

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.titleLabel.attributedText = attributedText;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}
- (NSAttributedString *)attributedText {
    return self.titleLabel.attributedText;
}

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}
- (NSString *)text {
    return self.titleLabel.text;
}

- (void)setTextFont:(UIFont *)textFont {
    self.titleLabel.font = textFont;
    self.textPointSize = 0.0f;
}
- (UIFont *)textFont {
    return self.titleLabel.font;
}

- (void)setTextColor:(UIColor *)textColor {
    self.titleLabel.textColor = textColor;
}
- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

- (void)setTextPointSize:(CGFloat)textPointSize {
    if (_textPointSize == textPointSize) { return; }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.backgroundView.backgroundColor = tintColor;
    self.titleLabel.backgroundColor = self.labelBackgroundColor;
    [self setNeedsLayout];
}

- (void)setTappedBackgroundColor:(UIColor *)tappedBackgroundColor {
    if (_tappedBackgroundColor == tappedBackgroundColor) { return; }
    _tappedBackgroundColor = tappedBackgroundColor;
    _tappedBackgroundBrightnessOffset = 0.0f;
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (fabs(cornerRadius - _cornerRadius) < FLT_EPSILON) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.backgroundView.layer.cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.backgroundView.alpha = enabled ? 1.0 : 0.4;
}

- (CGFloat)minimumWidth {
    return self.titleLabel.frame.size.width;
}

@end
