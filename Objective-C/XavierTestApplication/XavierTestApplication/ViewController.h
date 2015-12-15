//
//  ViewController.h
//
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Xavier/SCIXavierViewController.h>
#import <Xavier/SCIMetrics.h>

@interface ViewController : UIViewController <SCIXavierClientProtocol>

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@end
