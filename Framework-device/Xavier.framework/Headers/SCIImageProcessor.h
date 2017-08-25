//
//  ImageProcessor.h
//
//  Copyright © 2017 BlackShark Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SCIImageProcessorProtocol <NSObject>

@required
-(void) onParsedMrzTextBlob: (NSString*) parsedMrzTextBlob cleanedImage:(UIImage*) image;
-(void) onStartImageOcr;
-(void) onUnrecognizedMRZBlob;

@optional

@end

@interface SCIImageProcessor : NSObject

-(void) stop;

-(void)start;

@property (nonatomic, weak) id <SCIImageProcessorProtocol> _imageProcessorProtocol;


@end
