//
//  FilterCompositor.swift
//  LeonGit
//
//  Created by Leon.yan on 2/14/16.
//  Copyright © 2016 com.roimulia. All rights reserved.
//

import UIKit
import CoreImage
import AVFoundation

class FilterCompositor: NSObject, AVVideoCompositing {
    
    var renderContext : AVVideoCompositionRenderContext?
    var filter : CIFilter?
    var filter1 : CIFilter?
    var filterIndex : Int = 0
    var ciContext : CIContext?
    
    override init() {
        print("hello! filter!")
    }
    
    internal var sourcePixelBufferAttributes: [String : AnyObject]? {
        return [
            kCVPixelBufferPixelFormatTypeKey as String : NSNumber(unsignedInt: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange),
            kCVPixelBufferOpenGLCompatibilityKey as String : NSNumber(bool: true)
        ]
    }
    
    internal var requiredPixelBufferAttributesForRenderContext: [String : AnyObject] {
        return [
            kCVPixelBufferPixelFormatTypeKey as String : NSNumber(unsignedInt: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange),
            kCVPixelBufferOpenGLCompatibilityKey as String : NSNumber(bool: true)
        ]
    }
    
    func renderContextChanged(newRenderContext: AVVideoCompositionRenderContext) {
        renderContext = newRenderContext
    }
    
    func startVideoCompositionRequest(asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        guard let source = asyncVideoCompositionRequest.sourceFrameByTrackID(1) else {
            asyncVideoCompositionRequest.finishCancelledRequest()
            return
        }
        
        let pixel = renderContext!.newPixelBuffer()
        let ciimage = CIImage(CVPixelBuffer: source)
        
        var ciFilter : CIFilter
        
        if filterIndex == 0 {
            if filter == nil {
                filter = CIFilter(name: "CIPhotoEffectInstant")
            }
            ciFilter = filter!
        } else {
            if filter1 == nil {
                filter1 = CIFilter(name: "CIPhotoEffectMono")
            }
            ciFilter = filter1!
        }
        
        ciFilter.setValue(ciimage, forKey: kCIInputImageKey)
        
        if ciContext == nil {
            let eaglContext = EAGLContext(API: .OpenGLES2)
            ciContext = CIContext(EAGLContext: eaglContext!)
        }
        ciContext!.render(ciFilter.outputImage!, toCVPixelBuffer: pixel!)
        asyncVideoCompositionRequest.finishWithComposedVideoFrame(pixel!)
    }
}
