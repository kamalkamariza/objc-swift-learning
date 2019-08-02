//
//  PayCardsRecognizer.m
//  CardRecognizer
//
//  Created by Vladimir Tchernitski on 04/12/15.
//  Copyright © 2015 Vladimir Tchernitski. All rights reserved.
//

#import "CardRecognizer.h"

#include "IFrameStorage.h"
#include "IEdgesDetector.h"
#include "IRecognitionCore.h"

#include "ITorchDelegate.h"
#include "IRecognitionCore.h"

#import "WOEdgesWrapperView.h"

#import "GPUImageVideoCamera.h"
#import "GPUImageView.h"
#import "WOTorchDelegate.h"

NSString* const WOCardNumber = @"RecognizedCardNumber";
NSString* const WOExpDate = @"RecognizedExpDate";
NSString* const WOHolderName = @"RecognizedHolderName";
NSString* const WOHolderNameRaw = @"RecognizedHolderNameRaw";
NSString* const WONumberConfidences = @"ConfidencesOfRecognizedNumber";
NSString* const WOHolderNameConfidences = @"ConfidencesOfRecognizedHolderName";
NSString* const WOExpDateConfidences = @"ConfidencesOfRecognizedExpDate";
NSString* const WOCardImage = @"AlignedCardImage";
NSString* const WODateRectImage = @"DateRectImage";
NSString* const WOPanRect = @"PanRect";
NSString* const WODateRect = @"DateRect";

NSString *const kBundleIdentifier = @"com.walletone.ios.PayCardsRecognizer";

using namespace std;

@implementation UIView (Autolayout)

- (NSLayoutConstraint *)addConstraintWithItem:(UIView *)item attribute:(NSLayoutAttribute)attr {
    return [self addConstraintWithItem:item attribute:attr toItem:self];
}

- (NSLayoutConstraint *)addConstraintWithItem:(UIView *)item attribute:(NSLayoutAttribute)attr toItem:(UIView *)toItem {
    return [self addConstraintWithItem:item attribute:attr toItem:toItem attribute:attr];
}

- (NSLayoutConstraint *)addConstraintWithItem:(UIView *)item attribute:(NSLayoutAttribute)attr1 toItem:(UIView *)toItem attribute:(NSLayoutAttribute)attr2 {
    return [self addConstraintWithItem:item attribute:attr1 toItem:toItem attribute:attr2 constant: 0.0];
}

- (NSLayoutConstraint *)addConstraintWithItem:(UIView *)item attribute:(NSLayoutAttribute)attr1 toItem:(UIView *)toItem attribute:(NSLayoutAttribute)attr2 constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:item attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:toItem attribute:attr2 multiplier:1.0 constant:constant];
    [self addConstraint:constraint];
    return constraint;
}

@end

@interface CardRecognizer () <GPUImageVideoCameraDelegate, WOTorchPlatformDelegate> {

    size_t _bufferSizeY;
    size_t _bufferSizeUV;
    
    CardsOrientation _orientation;
    
    int _captureAreaWidth;
}

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;

@property (nonatomic, strong) UIImageView *frameImageView;

@property (nonatomic, strong) UIView *labelsHolderView;

@property (nonatomic, assign) shared_ptr<IRecognitionCore> recognitionCore;

@property (nonatomic, strong) WOEdgesWrapperView *edgesWrapperView;

@property (nonatomic, strong) GPUImageView *view;

@property (nonatomic, weak) UIView *container;

@property (nonatomic, strong) UIColor *frameColor;

@end

@implementation CardRecognizer

- (instancetype _Nonnull)initWithDelegate:(id<CardRecognizerDelegate> _Nonnull)delegate container:(UIView * _Nonnull)container frameColor:(UIColor * _Nonnull)frameColor {
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
        self.container = container;
        self.frameColor = frameColor;
        
        if([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height == 480) {
            _captureAreaWidth = 16;
        } else {
            _captureAreaWidth = 32;
        }
        [self deployCameraWithMode];
    }
    
    return self;
}

- (void)dealloc {

}

- (std::string)getString:(NSString*)str {
    if (str && str.length > 0) {
        return [str UTF8String];
    }
    return "";
}

- (void)deployWithMode{
    _orientation = CardsOrientationPortrait;
    shared_ptr<ITorchDelegate> torchDelegate;
    ITorchDelegate::GetInstance(torchDelegate, (__bridge void*)self);
    IRecognitionCore::GetInstance(_recognitionCore, torchDelegate);
    
    _recognitionCore->Deploy();
}

- (void)deployCameraWithMode{
    [self deployWithMode];
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.delegate = self;
    
    int bufferHeightY = 1280;
    int bytesPerRowY = 720;
    
    int bufferHeightUV = 640;
    int bytesPerRowUV = 720;
    
    _bufferSizeY = bufferHeightY * bytesPerRowY;
    _bufferSizeUV = bufferHeightUV * bytesPerRowUV;
}

- (void)stopCamera {
    [self pauseRecognizer];
    [self.videoCamera stopCameraCapture];
    [self.videoCamera setDelegate:nil];
    [self.videoCamera removeTarget:self.view];
    [self.view removeFromSuperview];
    self.view = nil;
    self.frameImageView = nil;
    self.edgesWrapperView = nil;
    self.widthConstraint = nil;
    self.heightConstraint = nil;
}

- (void)startCamera {
    [self startCameraWithOrientation:UIInterfaceOrientationPortrait];
}

- (void)startCameraWithOrientation:(UIInterfaceOrientation)orientation {
    
    [self.container addSubview:self.view];
    [self autoPinToContainer];
    
    self.videoCamera.delegate = self;
    
    [self.videoCamera addTarget:self.view];
    [self.videoCamera setFixedFocuse:0.6 completion:nil];
    
    
    [self.videoCamera startCameraCapture];
    [self setOrientation:orientation];
    [self setIsIdle:NO];
}

- (void)torchStatusDidChange:(BOOL)status {
    // TODO: trigger the alertview
//    NSUInteger delay = 5.0 * NSEC_PER_SEC;
//    NSUInteger time = dispatch_time(DISPATCH_TIME_NOW, int64(delay));
//
//    UIAlertController *alert=   [UIAlertController
//                                 alertControllerWithTitle:@""
//                                 message:@"Please hold still"
//                                 preferredStyle:UIAlertControllerStyleAlert];
//
//    [self. presentViewController:alert animated:YES
//                                               completion:nil];
//
//    dispatch_after(time, dispatch_get_main_queue(), {
//        alert.dismissWithClickedButtonIndex(-1, animated: true)
//    })
    [self.videoCamera turnTorchOn:status withValue:0.1];
}

- (void)turnTorchOn:(BOOL)on withValue:(float)value {
    [self.videoCamera turnTorchOn:on withValue:value];
}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
//    NSLog(@"DEBUG Getting output from recognizer");
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );

    void* bufferAddressY;
    void* bufferAddressUV;

    bufferAddressY = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    bufferAddressUV = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);

    DetectedLineFlags edgeFlags = DetectedLineNoneFlag;
    
    _recognitionCore->ProcessFrame(edgeFlags, bufferAddressY, bufferAddressUV, _bufferSizeY, _bufferSizeUV);

    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    [self highlightEdges:edgeFlags];
}

- (void)resumeRecognizer {
    [self setIsIdle:NO];
}

- (void)pauseRecognizer {
    [self setIsIdle:YES];
}

- (void)setIsIdle:(BOOL)isIdle {
    _recognitionCore->SetIdle(isIdle);
    _recognitionCore->ResetResult();
}

- (void)highlightEdges:(DetectedLineFlags)edgeFlags {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self->_edgesWrapperView.topEdge.alpha = edgeFlags&DetectedLineTopFlag ? 1. : 0.;
            self->_edgesWrapperView.bottomEdge.alpha = edgeFlags&DetectedLineBottomFlag ? 1. : 0.;
            self->_edgesWrapperView.leftEdge.alpha = edgeFlags&DetectedLineLeftFlag ? 1. : 0.;
            self->_edgesWrapperView.rightEdge.alpha = edgeFlags&DetectedLineRightFlag ? 1. : 0.;
            
//            self->_edgesWrapperView.topEdge.alpha = 1.;
//            self->_edgesWrapperView.bottomEdge.alpha = 1.;
//            self->_edgesWrapperView.leftEdge.alpha = 1.;
//            self->_edgesWrapperView.rightEdge.alpha = 1.;
        }];
    });
}

- (void)positionUIEdges:(cv::Rect)windowRect {
    dispatch_async(dispatch_get_main_queue(), ^{
        float coef;
        
        coef = 720 / self.container.bounds.size.width;
        self->_widthConstraint.constant = windowRect.height/coef;
        self->_heightConstraint.constant = windowRect.width/coef;
        
//        self->_widthConstraint.constant = self->_container.frame.size.width;
//        self->_heightConstraint.constant = self->_container.frame.size.height;
    });
}

- (void)setOrientation:(UIInterfaceOrientation)orientation {
    
    NSInteger _orientationRawValue = _orientation;
    NSInteger orientationRawValue = orientation;
    
    cv::Rect windowRect = _recognitionCore->CalcWorkingArea(cv::Size(1280, 720), _captureAreaWidth);
    
    if (_orientationRawValue == orientationRawValue) {
        return [self positionUIEdges:windowRect];
    }
    
    _orientation = (CardsOrientation)orientation;
    
    AVCaptureConnection *connection = [self.videoCamera videoCaptureConnection];
    
    switch (orientation) {
        case CardsOrientationPortrait:
            connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            [self.view setInputRotation:kGPUImageNoRotation atIndex:0];
            break;
        case CardsOrientationUpsideDown:
//            connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
//            [self.view setInputRotation:kGPUImageNoRotation atIndex:0];
            break;
        case CardsOrientationLandscapeRight:
//            connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//            [self.view setInputRotation:kGPUImageRotateRight atIndex:0];
            break;
        case CardsOrientationLandscapeLeft:
//            connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//            [self.view setInputRotation:kGPUImageRotateRight atIndex:0];
            break;
        default:
            break;
    }
    
//    _recognitionCore->SetOrientation((CardsOrientation)orientation);
    
    [self positionUIEdges:windowRect];
}

- (NSBundle *)bundle {
    return [NSBundle bundleWithIdentifier:kBundleIdentifier];
}

- (NSString *)pathToResource:(NSString *)fileName {
    NSString *path = [[self bundle] pathForResource:fileName ofType:nil];
    
    if ([self fileExistsInProject:path]) {
        return path;
    }
    return nil;
}

- (BOOL)fileExistsInProject:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

- (void)autoPinToContainer {
    [self.container addConstraintWithItem:self.view attribute:NSLayoutAttributeTop];
    [self.container addConstraintWithItem:self.view attribute:NSLayoutAttributeRight];
    [self.container addConstraintWithItem:self.view attribute:NSLayoutAttributeBottom];
    [self.container addConstraintWithItem:self.view attribute:NSLayoutAttributeLeft];
}

@end

@implementation CardRecognizer (CardDataDrawer)

- (CGFloat)fontSize:(CGFloat)base {
    CGFloat scale = self.labelsHolderView.bounds.size.width / 374;
    CGFloat fontSize = base * scale;
    return fontSize;
}

@end

@implementation CardRecognizer (UIInitializations)

- (UIView *)view {
    if (_view) {
        return _view;
    }
    
    _view = [[GPUImageView alloc] initWithFrame:self.container.bounds];
    _view.translatesAutoresizingMaskIntoConstraints = NO;
    _view.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    [_view addSubview:self.frameImageView];
    
    [_view addConstraintWithItem:self.frameImageView attribute:NSLayoutAttributeCenterX];
    [_view addConstraintWithItem:self.frameImageView attribute:NSLayoutAttributeCenterY];
    
    [_view addSubview:self.edgesWrapperView];
    
    [_view addConstraintWithItem:self.edgesWrapperView attribute:NSLayoutAttributeWidth toItem:self.frameImageView];
    [_view addConstraintWithItem:self.edgesWrapperView attribute:NSLayoutAttributeHeight toItem:self.frameImageView];
    
    [_view addConstraintWithItem:self.edgesWrapperView attribute:NSLayoutAttributeCenterX];
    [_view addConstraintWithItem:self.edgesWrapperView attribute:NSLayoutAttributeCenterY];
    
    _widthConstraint = [_view addConstraintWithItem:self.frameImageView attribute:NSLayoutAttributeWidth toItem:nil attribute: NSLayoutAttributeNotAnAttribute];
    _heightConstraint = [_view addConstraintWithItem:self.frameImageView attribute:NSLayoutAttributeHeight toItem:nil attribute: NSLayoutAttributeNotAnAttribute];
    
    return _view;
}

- (UIImageView *)frameImageView {
    if (_frameImageView) {
        return _frameImageView;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:[self pathToResource:@"PortraitFrame.png"]];
    
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [self.frameColor set];
    [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _frameImageView = [[UIImageView alloc] initWithImage: newImage];
    _frameImageView.contentMode = UIViewContentModeScaleToFill;
    _frameImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return _frameImageView;
}

- (WOEdgesWrapperView *)edgesWrapperView {
    if (_edgesWrapperView) {
        return _edgesWrapperView;
    }
    
    _edgesWrapperView = [[WOEdgesWrapperView alloc] initWithColor:self.frameColor];
    
    return _edgesWrapperView;
}

- (UIView *)labelsHolderView {
    if (_labelsHolderView) {
        return _labelsHolderView;
    }
    
    _labelsHolderView = [[UIView alloc] init];
    _labelsHolderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return _labelsHolderView;
}

@end
