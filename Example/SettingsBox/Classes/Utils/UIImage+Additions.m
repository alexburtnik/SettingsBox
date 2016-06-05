//
// Created by Alex Burtnik on 6/4/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import "UIImage+Additions.h"


@implementation UIImage (Additions)

- (UIImage *) imageByCroppingToSquare {
    CGFloat squareSide = MIN(self.size.width, self.size.height);
    CGRect cropRect = CGRectMake((self.size.width - squareSide)/2, (self.size.height - squareSide)/2, squareSide, squareSide);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return cropped;
}

- (UIImage *)imageWithSize:(CGSize)newSize scale: (CGFloat) scale {
    CGRect scaledImageRect = CGRectZero;

    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );

    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;

    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;
}

- (UIImage *)imageWithSize:(CGSize)newSize {
    return [self imageWithSize:newSize scale:0];
}

@end