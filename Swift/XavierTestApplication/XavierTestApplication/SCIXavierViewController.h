//
//  SCIXavierViewController.h
//
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCIMetrics.h"


@protocol SCIXavierClientProtocol <NSObject>

@required
-(void) onRawMrz: (NSString*) rawMrz;
-(void) onParsedXmlFromlMrz: (NSString*) parsedXmFromlMrz;
-(void) onMrzCaptureCompleted;
-(void) onError: (NSString*) errorMessage;

@optional
-(void) onMetrics: (SCIMetrics*) metrics;

@end


@interface SCIXavierViewController : UIViewController


/**
 initWithLicenseKey - Initialize and startup the OCR previewing process
 NOTE: Please contact SimonComputing for Evaluation or Production license key
 */
-(SCIXavierViewController *) initWithLicenseKey:(NSString*) licenseEmail
                            andLicenseKey:(NSString*) licenseKey;


/**
 Shutdown the OCR previewing process and close the OCR previewing window
 */
-(void) close;


/**
 * Client application is required to implement SCIXavierClientProtocol
 */
@property (nonatomic, weak) id <SCIXavierClientProtocol> _clientProtocol;

@end
