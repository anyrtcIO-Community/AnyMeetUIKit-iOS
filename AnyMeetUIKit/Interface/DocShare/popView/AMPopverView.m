//
//  AMPopverView.m
//  LFPopOverView
//
//  Created by derek on 2018/5/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import "AMPopverView.h"
#import "AMPopverViewConfiguration.h"

#define CFTYPECAST(exp) (exp)

@interface AMPopverView()
@property (nonatomic, weak) id<AMPopverViewDelegate> delegate;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation AMPopverView
- (void)dealloc {
    
}
+ (AMPopverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView delegate:(id<AMPopverViewDelegate>)delegate {
    AMPopverView *popoverView = [[AMPopverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withContentView:cView];
    popoverView.delegate = delegate;
    return popoverView;
}
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView {
    
    //NSLog(@"point:%f,%f", point.x, point.y);
    
    self.contentView = cView;
    parentView = view;

    topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    
    [self setupLayout:point inView:view];
    
    // Make the view small and transparent before animation
#warning modify　by derek self.alpha = 0.0f;会影响父视图改为如下
//    self.alpha = 0.0f;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
//    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
//
//    // animate into full size
//    // First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
//    // This two-stage animation creates a little "pop" on open.
//    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.alpha = 0.3f;
//        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.transform = CGAffineTransformIdentity;
//        } completion:nil];
//    }];
}

-(void)setupLayout:(CGPoint)point inView:(UIView*)view
{
    CGPoint topPoint = [topView convertPoint:point fromView:view];
    
    arrowPoint = topPoint;
    
    CGRect topViewBounds = topView.bounds;
    
    float contentHeight = self.contentView.frame.size.height;
    float contentWidth = self.contentView.frame.size.width;
    
    float padding = kBoxPadding;
    
    float boxHeight = contentHeight + 2.f*padding;
    float boxWidth = contentWidth + 2.f*padding;
    
    float xOrigin = 0.f;
    
    //Make sure the arrow point is within the drawable bounds for the popover.
    if (arrowPoint.x + kArrowHeight > topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding) {//Too far to the right
        arrowPoint.x = topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding - kArrowHeight;
        //NSLog(@"Correcting Arrow Point because it's too far to the right");
    } else if (arrowPoint.x - kArrowHeight < kHorizontalMargin + kBoxRadius + kArrowHorizontalPadding) {//Too far to the left
        arrowPoint.x = kHorizontalMargin + kArrowHeight + kBoxRadius + kArrowHorizontalPadding;
        //NSLog(@"Correcting Arrow Point because it's too far to the left");
    }
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    xOrigin = floorf(arrowPoint.x - boxWidth*0.5f);
    
    //Check to see if the centered xOrigin value puts the box outside of the normal range.
    if (xOrigin < CGRectGetMinX(topViewBounds) + kHorizontalMargin) {
        xOrigin = CGRectGetMinX(topViewBounds) + kHorizontalMargin;
    } else if (xOrigin + boxWidth > CGRectGetMaxX(topViewBounds) - kHorizontalMargin) {
        //Check to see if the positioning puts the box out of the window towards the left
        xOrigin = CGRectGetMaxX(topViewBounds) - kHorizontalMargin - boxWidth;
    }
    
    float arrowHeight = kArrowHeight;
    
    float topPadding = kTopMargin;
    
    above = YES;
    
    if (topPoint.y - contentHeight - arrowHeight - topPadding < CGRectGetMinY(topViewBounds)) {
        //Position below because it won't fit above.
        above = NO;
        
        boxFrame = CGRectMake(xOrigin, arrowPoint.y + arrowHeight, boxWidth, boxHeight);
    } else {
        //Position above.
        above = YES;
        
        boxFrame = CGRectMake(xOrigin, arrowPoint.y - arrowHeight - boxHeight, boxWidth, boxHeight);
    }
    CGRect contentFrame = CGRectMake(boxFrame.origin.x + padding, boxFrame.origin.y + padding, contentWidth, contentHeight);
    self.contentView.frame = contentFrame;
    
    //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
    //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
    //implicitly set the frame for the view, which we do not want.
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / topViewBounds.size.width, arrowPoint.y / topViewBounds.size.height);
    self.frame = topViewBounds;
    [self setNeedsDisplay];
    
    [self addSubview:self.contentView];
    [topView addSubview:self];
    
    //Add a tap gesture recognizer to the large invisible view (self), which will detect taps anywhere on the screen.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.cancelsTouchesInView = NO; // Allow touches through to a UITableView or other touchable view, as suggested by Dimajp.
    [self addGestureRecognizer:tap];
    
    self.userInteractionEnabled = YES;
}
#pragma mark - public methods
- (void)dismiss
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated
{
    if (!animated)
    {
        [self dismissComplete];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0.1f;
            self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
            [self dismissComplete];
        }];
    }
}

- (void)dismissComplete
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverViewDidDismiss:)]) {
        [self.delegate popoverViewDidDismiss:self];
    }
    
    [self removeFromSuperview];
}
#pragma mark - User Interaction

- (void)tapped:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.contentView];
    BOOL found = NO;
    if (CGRectContainsPoint(self.contentView.bounds, point)) {
        found = YES;
        //NSLog(@"popover box contains point, ignoring user input");
    }
    
    if (!found) {
        [self dismiss:NO];
    }
}

#pragma mark - Drawing Routines

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Build the popover path
    CGRect frame = boxFrame;
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float radius = kBoxRadius; //Radius of the curvature.
    
    float cpOffset = kCPOffset; //Control Point Offset.  Modifies how "curved" the corners are.
    
    
    /*
     LT2            RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
     |               |
     |    popover    |
     |               |
     LB2⌞_______________⌟RB1
     LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//LT1
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
    
    //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
    //In this case, the arrow is located between LT2 and RT1
    if (!above) {
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin) controlPoint2:arrowPoint];//actual arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//RB2
    
    //If the popover is positioned above the arrowPoint, then we know that the arrow must be on the bottom of the popover.
    //In this case, the arrow is located somewhere between LB1 and RB2
    if (above) {
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMax)];//right side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMax) controlPoint2:arrowPoint];//arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMax) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMax)];
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//LB2
    [popoverPath closePath];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor colorWithWhite:0.0f alpha:kShadowAlpha];
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = kShadowBlur;
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)kGradientTopColor.CGColor,
                               (id)kGradientBottomColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFTYPECAST(CFArrayRef)gradientColors), gradientLocations);
    
    
    //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
    float bottomOffset = (above ? kArrowHeight : 0.f);
    float topOffset = (!above ? kArrowHeight : 0.f);
    
    //Draw the actual gradient and shadow.
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [popoverPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    //Draw border if we need to
    //The border is done last because it needs to be drawn on top of everything else
    if (kDrawBorder) {
        [kBorderColor setStroke];
        popoverPath.lineWidth = kBorderWidth;
        [popoverPath stroke];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
