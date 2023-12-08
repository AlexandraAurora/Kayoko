//
//  ImageUtil.m
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import "ImageUtil.h"

@implementation ImageUtil
/**
 * Checks whether an image has an alpha channel or not.
 *
 * @param image The image object.
 *
 * @return Whether the image has an alpha channel or not.
 */
+ (BOOL)imageHasAlpha:(UIImage *)image {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo([image CGImage]);
    return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

/**
 * Rotates an image up and returns it.
 *
 * @param image The image to rotate.
 *
 * @return The rotated image.
 */
+ (UIImage *)getRotatedImageFromImage:(UIImage *)image {
    if ([image imageOrientation] == UIImageOrientationUp) {
        return image;
    }

    UIGraphicsBeginImageContext([image size]);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage* rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
}

/**
 * Scales an image to a given size.
 *
 * @param image The image to scale.
 * @param newSize The size to scale the image to.
 *
 * @return The scaled image.
 */
+ (UIImage *)getImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
