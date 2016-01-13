//
//  SCIXavierWidget.h
//  Copyright (c) 2014 SimonComputing. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol SCIXavierWidgetProtocol <NSObject>

@required

-(void) drawFocusSymbol: (BOOL) val;
-(CGPoint) getFocusPoint;
-(void) displayStatusMsg:(NSString*) status;

@end

typedef void (^WidgetCompleted)(void);

@interface SCIXavierWidgetView : UIView <SCIXavierWidgetProtocol>

- (id)initWithFrame:(CGRect)frame withWidgetCompletedBlock:(WidgetCompleted)widgetComplete;

@property (nonatomic, weak) id <SCIXavierWidgetProtocol> _widgetProtocol;

@end
