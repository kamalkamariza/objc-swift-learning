//
//  RecognitionCore.h
//  CardRecognizer
//
//  Created by Vladimir Tchernitski on 12/01/16.
//  Copyright © 2016 Vladimir Tchernitski. All rights reserved.
//

#ifndef RecognitionCore_h
#define RecognitionCore_h


#include <atomic>
#include "IRecognitionCore.h"
#include "IFrameStorage.h"

class IEdgesDetector;
class IRecognitionResult;
class IServiceContainer;
class INumberRecognizer;
class IDateRecognizer;
class ITorchManager;
class ITorchDelegate;
class INameRecognizer;


class CRecognitionCore : public IRecognitionCore
{
    
public:
    CRecognitionCore(const shared_ptr<ITorchDelegate>& torchDelegate);
    
    virtual ~CRecognitionCore();
    
public:
    
    virtual void Deploy();
    
    virtual void SetOrientation(CardsOrientation orientation);
    
    virtual bool IsIdle() const;
    virtual void SetIdle(bool isIdle);
    virtual void ResetResult();
    
    virtual void SetTorchStatus(bool status);
    
    virtual cv::Rect CalcWorkingArea(cv::Size frameSize, int captureAreaWidth);
    
    virtual void ProcessFrame(DetectedLineFlags& edgeFlags, void* bufferY, void* bufferUV, size_t bufferSizeY, size_t bufferSizeUV);

private:
    cv::Mat CaptureView();
    void ProcessFrameThreaded();
    void RecognizeNumber();
    void Recognize();
    void FinishRecognition();
    
private:
    
    shared_ptr<IServiceContainer> _serviceContainerPtr;
    
    weak_ptr<IFrameStorage> _frameStorage;
    weak_ptr<IEdgesDetector> _edgesDetector;
    
    weak_ptr<IDateRecognizer> _dateRecognizer;
    weak_ptr<INumberRecognizer> _numberRecognizer;
    weak_ptr<INameRecognizer> _nameRecognizer;
    weak_ptr<ITorchManager> _torchManager;
    
    atomic<bool> _isIdle;
    atomic<bool> _isBusy;
    
    cv::Mat _currentFrame;
    vector<ParametricLine> _edges;
    size_t _bufferSizeY;
    
    CardsOrientation _orientation;
        
    bool _deployed;
};

#endif /* RecognitionCore_h */
