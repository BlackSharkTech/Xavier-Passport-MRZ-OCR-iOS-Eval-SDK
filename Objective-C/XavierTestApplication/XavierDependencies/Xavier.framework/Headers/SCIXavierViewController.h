//
//  SCIXavierViewController.h
//
//  Copyright © 2017 BlackShark Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCIImageProcessor.h"
#import "SCIProcessor.h"

@class SCIMetrics;
@class SCIMrzProcessor;
@class SCIGunSerialProcessor;

@protocol SCIXavierClientProtocol <NSObject>

@required
-(void) onRawMrz: (NSString*) rawMrz;
-(void) onParsedXmlFromlMrz: (NSString*) parsedXmFromlMrz;
-(void) onParsedJsonFromlMrz: (NSString*) parsedJsonFromlMrz;
-(void) onMrzCaptureCompleted;
-(void) onError: (NSString*) errorMessage;
-(void) onCapturedImage: (UIImage*) image;
-(void) onCapturedBarcode:(NSString*) barcode;

@optional
-(void)setPortraitMode:(BOOL) value;
-(void) onMetrics: (SCIMetrics*) metrics;
-(void) onClose;

@end


@interface SCIXavierViewController : UIViewController <SCIProcessorProtocol, SCIImageProcessorProtocol>


/**
 init
 */
-(SCIXavierViewController *) init;
-(SCIXavierViewController *) init:(BOOL)portraitMode;
-(SCIXavierViewController *) init:(BOOL)portraitMode andUseFrontCam:(BOOL)useFrontCam;


/**
 Shutdown the OCR previewing process and close the OCR previewing window
 */
-(void) close;


/**
 * Client application is required to implement SCIXavierClientProtocol
 */
@property (nonatomic, weak) id <SCIXavierClientProtocol> _clientProtocol;

@end
