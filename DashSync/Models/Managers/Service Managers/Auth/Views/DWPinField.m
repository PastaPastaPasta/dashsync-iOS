//
//  Created by Andrew Podkovyrin
//  Copyright © 2019 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DWPinField.h"

#import "DWNumberKeyboardInputViewAudioFeedback.h"
#import "UIColor+DSStyle.h"

NS_ASSUME_NONNULL_BEGIN

// TODO: pin length should be defined in DSAuthenticationManager
static NSUInteger const PIN_FIELDS_COUNT = 4;

static CGFloat const PIN_FIELD_SIZE_DEFAULT = 50.0;
static CGFloat const PIN_FIELD_SIZE_SMALL = 44.0;

static CGFloat const PIN_DOT_SIZE = 9.0;
static CGFloat const PADDING = 10.0;

static CALayer *PinFieldLayer() {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor ds_pinBackgroundColor].CGColor;
    layer.cornerRadius = 8.0;
    layer.masksToBounds = YES;

    return layer;
}

static CALayer *PinDotLayer(CGFloat fieldSize) {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor ds_pinInputDotColor].CGColor;
    CGRect rect = CGRectMake((fieldSize - PIN_DOT_SIZE) / 2.0,
                             (fieldSize - PIN_DOT_SIZE) / 2.0,
                             PIN_DOT_SIZE,
                             PIN_DOT_SIZE);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    layer.path = path.CGPath;
    layer.opacity = 0.0;

    return layer;
}

@interface DWPinField ()

@property (readonly, nonatomic, assign) CGFloat fieldSize;
@property (readonly, nonatomic, strong) NSMutableArray<NSString *> *value;

@property (readonly, nonatomic, strong) NSCharacterSet *supportedCharacters;

@property (readonly, nonatomic, copy) NSArray<CALayer *> *backgroundLayers;
@property (readonly, nonatomic, copy) NSArray<CALayer *> *dotLayers;

@end

@implementation DWPinField

- (instancetype)initWithStyle:(DWPinFieldStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _fieldSize = style == DWPinFieldStyle_Default ? PIN_FIELD_SIZE_DEFAULT : PIN_FIELD_SIZE_SMALL;

        _value = [NSMutableArray array];

        _supportedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];

        self.userInteractionEnabled = NO;

        // hide any assistant items on the iPad
        UITextInputAssistantItem *inputAssistantItem = self.inputAssistantItem;
        inputAssistantItem.leadingBarButtonGroups = @[];
        inputAssistantItem.trailingBarButtonGroups = @[];

        CGFloat x = 0.0;
        NSMutableArray<CALayer *> *backgroundLayers = [NSMutableArray array];
        NSMutableArray<CALayer *> *dotLayers = [NSMutableArray array];
        for (NSUInteger i = 0; i < PIN_FIELDS_COUNT; i++) {
            CALayer *backgroundLayer = PinFieldLayer();
            backgroundLayer.frame = CGRectMake(x, 0.0, _fieldSize, _fieldSize);
            [self.layer addSublayer:backgroundLayer];
            [backgroundLayers addObject:backgroundLayer];

            CALayer *dotLayer = PinDotLayer(_fieldSize);
            dotLayer.frame = CGRectMake(0.0, 0.0, _fieldSize, _fieldSize);
            [backgroundLayer addSublayer:dotLayer];
            [dotLayers addObject:dotLayer];

            x += CGRectGetWidth(backgroundLayer.frame) + PADDING;
        }
        _backgroundLayers = [backgroundLayers copy];
        _dotLayers = [dotLayers copy];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    const NSUInteger count = PIN_FIELDS_COUNT;
    return CGSizeMake(self.fieldSize * count + PADDING * (count - 1), self.fieldSize);
}

- (NSString *)text {
    return [self.value componentsJoinedByString:@""];
}

- (void)clear {
    [self.value removeAllObjects];

    for (NSUInteger i = 0; i < PIN_FIELDS_COUNT; i++) {
        CALayer *backgroundLayer = self.backgroundLayers[i];
        backgroundLayer.backgroundColor = [UIColor ds_pinBackgroundColor].CGColor;

        CALayer *dotLayer = self.dotLayers[i];
        dotLayer.opacity = 0.0;
    }
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (nullable UIView *)inputView {
    CGRect inputViewRect = CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0);
    DWNumberKeyboardInputViewAudioFeedback *inputView =
        [[DWNumberKeyboardInputViewAudioFeedback alloc] initWithFrame:inputViewRect];
    return inputView;
}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.value.count > 0;
}

- (void)deleteBackward {
    NSUInteger count = self.value.count;
    if (count > 0) {
        [self.value removeLastObject];

        NSUInteger index = count - 1;

        CALayer *backgroundLayer = self.backgroundLayers[index];
        backgroundLayer.backgroundColor = [UIColor ds_pinBackgroundColor].CGColor;

        CALayer *dotLayer = self.dotLayers[index];
        dotLayer.opacity = 0.0;
    }
}

- (void)insertText:(NSString *)text {
    // validate input if user has a hardware keyboard
    if (![self isInputStringValid:text]) {
        return;
    }

    if (self.value.count >= PIN_FIELDS_COUNT) {
        return;
    }

    [self.value addObject:text];

    NSUInteger index = self.value.count - 1;

    CALayer *backgroundLayer = self.backgroundLayers[index];
    backgroundLayer.backgroundColor = [UIColor ds_dashBlueColor].CGColor;

    CALayer *dotLayer = self.dotLayers[index];
    dotLayer.opacity = 1.0;

    if (self.value.count == PIN_FIELDS_COUNT) {
        [self.delegate pinFieldDidFinishInput:self];
    }
}

#pragma mark - UITextInput

// Since we don't need to support cursor and selection implementation of UITextInput is a dummy

- (nullable UITextRange *)selectedTextRange {
    return nil;
}

- (void)setSelectedTextRange:(nullable UITextRange *)selectedTextRange {
}

- (nullable UITextRange *)markedTextRange {
    return nil;
}

- (UITextPosition *)beginningOfDocument {
    return [[UITextPosition alloc] init];
}

- (UITextPosition *)endOfDocument {
    return [[UITextPosition alloc] init];
}

- (id<UITextInputTokenizer>)tokenizer {
    return [[UITextInputStringTokenizer alloc] initWithTextInput:self];
}

- (nullable NSDictionary<NSAttributedStringKey, id> *)markedTextStyle {
    return nil;
}

- (void)setMarkedTextStyle:(nullable NSDictionary<NSAttributedStringKey, id> *)markedTextStyle {
}

- (nullable id<UITextInputDelegate>)inputDelegate {
    return nil;
}

- (void)setInputDelegate:(nullable id<UITextInputDelegate>)inputDelegate {
}

- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction {
    return UITextWritingDirectionNatural;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

- (nullable UITextRange *)characterRangeAtPoint:(CGPoint)point {
    return nil;
}

- (nullable UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction {
    return nil;
}

- (nullable UITextPosition *)closestPositionToPoint:(CGPoint)point {
    return nil;
}

- (nullable UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range {
    return nil;
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other {
    return NSOrderedSame;
}

- (CGRect)firstRectForRange:(UITextRange *)range {
    return CGRectZero;
}

- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition {
    return 0;
}

- (nullable UITextPosition *)positionFromPosition:(UITextPosition *)position
                                      inDirection:(UITextLayoutDirection)direction
                                           offset:(NSInteger)offset {
    return nil;
}

- (nullable UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset {
    return nil;
}

- (nullable UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction {
    return nil;
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text {
}

- (NSArray<UITextSelectionRect *> *)selectionRectsForRange:(UITextRange *)range {
    return nil;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range {
}

- (void)setMarkedText:(nullable NSString *)markedText selectedRange:(NSRange)selectedRange {
}

- (nullable NSString *)textInRange:(UITextRange *)range {
    return nil;
}

- (nullable UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition
                                     toPosition:(UITextPosition *)toPosition {
    return nil;
}

- (void)unmarkText {
}

#pragma mark - Private

- (BOOL)isInputStringValid:(NSString *)text {
    if (!text) {
        return NO;
    }

    if (text.length != 1) {
        return NO;
    }

    BOOL isDigit = isdigit([text characterAtIndex:0]);

    return isDigit;
}

@end

NS_ASSUME_NONNULL_END
