//
//  QBJustButton.h
//  QBJustButton
//
//  Created by quan bui on 2021/05/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE @interface QBJustButton : UIControl

/** Create instance of button with text*/
- (instancetype)initWithTitle:(NSString *)text;

/** The text in center of the button*/
@property (nonatomic, copy) IBInspectable NSString *text;

/** The color of the button text - Default .white*/
@property (nonatomic, strong) IBInspectable UIColor *textColor;

/** The font of button label text*/
@property (nonatomic, strong) UIFont *textFont;

/** The radius of the button corners - Default 4.0f*/
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/** Animation alpha when tapped to button - Default 1.0f*/
@property (nonatomic, assign) IBInspectable CGFloat tappedTitleAlpha;

/** The background color when button tapped - Default nil*/
@property (nonatomic, strong, nullable) IBInspectable UIColor *tappedBackgroundColor;

/** The scale of the button during animation - Default 0.96f*/
@property (nonatomic, assign) IBInspectable CGFloat tappedButtonScale;

/** The duration of tapped animation - Default 0.4f*/
@property (nonatomic, assign) CGFloat tappedAnimationDuration;

/** Set font size*/
@property (nonatomic, assign) IBInspectable CGFloat textPointSize;

/** Brightness offset of background color when button is tapped*/
@property (nonatomic, assign) IBInspectable CGFloat tappedBackgroundBrightnessOffset;

/** The attributed string to use for button title*/
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;

@property (nonatomic, readonly) CGFloat minimumWidth;

/** Button tapped handler*/
@property (nonatomic, copy) void (^tap)(void);

@end

NS_ASSUME_NONNULL_END
