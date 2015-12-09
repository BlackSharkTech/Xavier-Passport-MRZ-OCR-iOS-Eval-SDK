//
//  SCImetrics.h
//
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//

@interface SCIMetrics : NSObject
{
    
    double _startOfWidget;
    double _endOfWidget;
    double _startOfCandidate;
    double _endOfCandidate;
    int _numberOfCandidates;
    int _numberOfScans;
    double _imageAnalysis;
    double _scrubbing;
    
}

@property(nonatomic, readwrite) double startOfWidget;
@property(nonatomic, readwrite) double endOfWidget;
@property(nonatomic, readwrite) double startOfCandidate;
@property(nonatomic, readwrite) double endOfCandidate;
@property(nonatomic, readwrite) int numberOfCandidates;
@property(nonatomic, readwrite) int numberOfScans;
@property(nonatomic, readwrite) double imageAnalysis;
@property(nonatomic, readwrite) double scrubbing;


-(void)clear;

+(SCIMetrics *)sharedInstance;

+(double) getNow;

@end

@protocol SCIMetricsProtocol <NSObject>


@optional
-(void) onMetrics: (SCIMetrics*) metrics;

@end