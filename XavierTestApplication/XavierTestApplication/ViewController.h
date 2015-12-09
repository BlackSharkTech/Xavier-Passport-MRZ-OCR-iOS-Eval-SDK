//
//  ViewController.h
//
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SCIXavierViewController.h"


@interface ViewController : UIViewController <SCIXavierClientProtocol>

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@end
