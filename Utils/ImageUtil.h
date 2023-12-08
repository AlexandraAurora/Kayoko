//
//  ImageUtil.h
//  Kayoko
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>

@interface ImageUtil : NSObject
+ (BOOL)imageHasAlpha:(UIImage *)image;
+ (UIImage *)getRotatedImageFromImage:(UIImage *)image;
+ (UIImage *)getImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
