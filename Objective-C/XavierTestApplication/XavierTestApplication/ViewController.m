//
//  ViewController.m
//
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


/**
 * ViewController implementation
 */
@implementation ViewController

SCIXavierViewController *_xavierViewController;

/**
 * viewDidLoad
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.viewController = self;

    _xavierViewController = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self rotateForLabel];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self rotateForLabel];
}


/**
 * startBtnClick
 */
- (IBAction)startBtnClick:(id)sender {
    
    [self clearTextView];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        [self startCapture];
    } else {
        [self startCaptureLandscape];
    }
    
}


/**
 * startCapture
 */
- (void) startCapture
{
    // NOTE: Need to contact SimonComputing Inc. (www.SimonComputing.com) for the License Key
    // and update the plist accordingly
    _xavierViewController = [[SCIXavierViewController alloc] init];
    
    _xavierViewController._clientProtocol = self;
    
    [self presentViewController:_xavierViewController animated:NO completion:^{
        NSLog(@"Xavier View Controller is started");
    }];
    
}

/**
 * startCapture in Landscape mode
 */
- (void) startCaptureLandscape
{
    // NOTE: Need to contact SimonComputing Inc. (www.SimonComputing.com) for the License Key
    // and update the plist accordingly
    _xavierViewController = [[SCIXavierViewController alloc] init:false];
    _xavierViewController._clientProtocol = self;
    
    [self presentViewController:_xavierViewController animated:NO completion:^{
        NSLog(@"Xavier View Controller is started");
    }];
    
}


/**
 * onRawMrz - SCIXavierClientProtocol implementation
 */
-(void) onRawMrz: (NSString*) rawMrz
{
    NSLog(@"\n=====> onRawMrz() - %@", rawMrz);
    
    [self insertToTextView :@"Raw MRZ:\n"];
    [self insertToTextView :@"========\n"];
    
    [self insertToTextView :rawMrz];
    [self insertToTextView :@"\n"];
  
}


/**
 * onMrzCaptureCompleted - SCIXavierClientProtocol implementation
 */
-(void) onMrzCaptureCompleted
{
    NSLog(@"\n=====> onMrzCaptureCompleted()");
    
}


/**
 * onError - SCIXavierClientProtocol implementation
 */
-(void) onError: (NSString*) errorMessage
{
    NSLog(@"\n=====> onError() - %@", errorMessage);
    
    [self insertToTextView :@"Error:\n"];
    [self insertToTextView :@"======\n"];
    
    [self insertToTextView :errorMessage];
}


/**
 * onParsedXmlFromlMrz - SCIXavierClientProtocol implementation
 */
-(void) onParsedXmlFromlMrz: (NSString*) parsedXmFromlMrz
{
    NSLog(@"\n\n=====> onParsedXmlFromlMrz() - %@", parsedXmFromlMrz);
    
    [self insertToTextView :@"XML from MRZ:\n"];
    [self insertToTextView :@"===========\n"];
    
    [self insertToTextView :parsedXmFromlMrz];
    [self insertToTextView :@"\n"];
}


/**
 * onMetrics - SCIXavierClientProtocol implementation
 */
-(void) onMetrics: (SCIMetrics*) metrics
{
    NSLog(@"\n\n=====> onMetrics()");

    [self insertToTextView :@"Metrics:\n"];
    [self insertToTextView :@"======\n"];
    
    [self insertToTextView :@"Total OCR time: "];
    [self insertToTextView :[NSString stringWithFormat:@"%f", metrics.endOfWidget - metrics.startOfWidget]];
    [self insertToTextView :@" (secs)\n"];
    
    [self insertToTextView :@"Number of MRZ candidates found: "];
    [self insertToTextView :[NSString stringWithFormat:@"%i", metrics.numberOfCandidates]];
    [self insertToTextView :@"\n"];

    [self insertToTextView :@"Number of scans: "];
    [self insertToTextView :[NSString stringWithFormat:@"%i", metrics.numberOfScans]];
    [self insertToTextView :@"\n"];
    
    [self insertToTextView :@"Image analysis average duration: "];
    [self insertToTextView :[NSString stringWithFormat:@"%f", metrics.imageAnalysis]];
    [self insertToTextView :@" (secs)\n"];
    [self insertToTextView :@"\n"];
    
}



/**
 * insertToTextView
 */
- (void) insertToTextView: (NSString *) insertingString
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        NSRange range = self.resultTextView.selectedRange;
        NSString * currentString = [self.resultTextView.text substringToIndex:range.location];
        self.resultTextView.scrollEnabled = YES;
        
        self.resultTextView.text = [NSString stringWithFormat: @"%@%@", currentString, insertingString];

        range.location += [insertingString length];
        self.resultTextView.selectedRange = range;
        self.resultTextView.scrollEnabled = YES;
    });
}


/**
 * clearTextView
 */
- (void) clearTextView
{
    [self.resultTextView setText:@""];
}

- (void) rotateForLabel
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        [self.startBtn setTitle:@"Portrait Capture" forState:UIControlStateNormal];
    } else {
        [self.startBtn setTitle:@"Landscape Capture" forState:UIControlStateNormal];
    }
}


@end
