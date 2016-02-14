//
//  LGInstruction.swift
//  LeonGit
//
//  Created by Leon.yan on 2/14/16.
//  Copyright © 2016 com.roimulia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class LGInstruction: NSObject, AVVideoCompositionInstructionProtocol
{

    var _timeRange : CMTimeRange = kCMTimeRangeZero
    internal var timeRange: CMTimeRange {
        return _timeRange
    }
    
    internal var enablePostProcessing: Bool {
        return true
    }
    
    internal var containsTweening: Bool {
        return true
    }
    
    internal var requiredSourceTrackIDs: [NSValue]? {
        return [NSNumber(integer: 1)]
    }
    
    /* If for the duration of the instruction, the video composition result is one of the source frames, this property should
    return the corresponding track ID. The compositor won't be run for the duration of the instruction and the proper source
    frame will be used instead. The dimensions, clean aperture and pixel aspect ratio of the source buffer will be
    matched to the required values automatically */
    internal var passthroughTrackID: CMPersistentTrackID {
        return kCMPersistentTrackID_Invalid
    }
}
