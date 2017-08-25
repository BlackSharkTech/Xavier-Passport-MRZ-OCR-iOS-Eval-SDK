//
//  SCIXavierWidget.h
//  Copyright © 2017 BlackShark Tech. All rights reserved.
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

- (id)init: (UIView*) previewBoxView
        andParentFrameRect:(CGRect)frameRect
        withWidgetCompletedBlock:(WidgetCompleted) widgetCompleteCallback;

@property (nonatomic, weak) id <SCIXavierWidgetProtocol> _widgetProtocol;

@end
