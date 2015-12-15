//
//  ImageProcessor.h
//
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SCIImageProcessorProtocol <NSObject>

@required
-(void) onParsedMrzTextBlob: (NSString*) parsedMrzTextBlob;
-(void) onStartImageOcr;
-(void) onUnrecognizedMRZBlob;
@optional

@end

@interface SCIImageProcessor : NSObject

-(void) stop;

-(void)start;

@property (nonatomic, weak) id <SCIImageProcessorProtocol> _imageProcessorProtocol;


@end
