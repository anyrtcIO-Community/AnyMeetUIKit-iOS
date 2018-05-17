//
//  AMPopverViewConfiguration.h
//  LFPopOverView
//
//  Created by derek on 2018/5/2.
//  Copyright © 2018年 user. All rights reserved.
//

#ifndef AMPopverViewConfiguration_h
#define AMPopverViewConfiguration_h
// BOX GEOMETRY

//Height/width of the actual arrow
#define kArrowHeight 12.f

//padding within the box for the contentView
#define kBoxPadding 1.f

//control point offset for rounding corners of the main popover box
#define kCPOffset 1.8f

//radius for the rounded corners of the main popover box
#define kBoxRadius 4.f

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define kArrowCurvature 6.f

//Minimum distance from the side of the arrow to the beginning of curvature for the box
#define kArrowHorizontalPadding 5.f

//Alpha value for the shadow behind the PopoverView
#define kShadowAlpha 0.4f

//Blur for the shadow behind the PopoverView
#define kShadowBlur 3.f;

//Box gradient bg alpha
#define kBoxAlpha 0.6f

//Padding along top of screen to allow for any nav/status bars
#define kTopMargin 50.f

//margin along the left and right of the box
#define kHorizontalMargin 10.f

//padding along top of icons/images
#define kImageTopPadding 3.f

//padding along bottom of icons/images
#define kImageBottomPadding 3.f

// BORDER

//bool that turns off/on the border
#define kDrawBorder NO

//border color
#define kBorderColor [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:kBoxAlpha]

//border width
#define kBorderWidth 0.f


// BACKGROUND GRADIENT

//bottom color white in gradient bg
#define kGradientBottomColor [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:kBoxAlpha]

//top color white value in gradient bg
#define kGradientTopColor [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:kBoxAlpha]



#endif /* AMPopverViewConfiguration_h */
