//
//  MrzProcessor.h
//
//  Copyright © 2017 BlackShark Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SCIProcessorProtocol <NSObject>

@required
-(void) onNumberOfMrzCandidates: (int) numMrzCandidates;
-(void) onPreviewedMrz: (NSString*) previewedMrz atRow:(int) rowNum;
-(void) onCapturedMrz: (NSString*) capturedMrz;
-(void) onCapturedImage: (UIImage*) image;
-(void) onUnrecognizedMrzLines;
@end


@interface SCIMrzProcessor : NSObject
- (SCIMrzProcessor *) init;
-(void) start;
-(void) processMrzTextBlob: (NSString*) mrzBlob;
-(void) stop;

@property (nonatomic, weak) id <SCIProcessorProtocol> _mrzProcessorProtocol;

@end

@interface SCIGunSerialProcessor : NSObject
- (SCIGunSerialProcessor *) init;
-(void) start;
-(void) processMrzTextBlob: (NSMutableDictionary*) blobImagePair;
-(void) stop;

@property (nonatomic, weak) id <SCIProcessorProtocol> _gunSerialProcessorProtocol;

@end
