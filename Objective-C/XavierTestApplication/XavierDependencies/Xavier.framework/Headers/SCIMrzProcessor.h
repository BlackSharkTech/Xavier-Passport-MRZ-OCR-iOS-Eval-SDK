//
//  MrzProcessor.h
//
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SCIMrzProcessorProtocol <NSObject>

@required
-(void) onNumberOfMrzCandidates: (int) numMrzCandidates;
-(void) onPreviewedMrz: (NSString*) previewedMrz atRow:(int) rowNum;
-(void) onCapturedMrz: (NSString*) capturedMrz;
-(void) onUnrecognizedMrzLines;

@end


@interface SCIMrzProcessor : NSObject
- (SCIMrzProcessor *) init;
-(void) start;
-(void) processMrzTextBlob: (NSString*) mrzBlob;
-(void) stop;

@property (nonatomic, weak) id <SCIMrzProcessorProtocol> _mrzProcessorProtocol;

@end
