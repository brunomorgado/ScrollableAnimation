//
//  KeyframeInterpolator.swift
//  ScrollableMovie
//
//  Created by Bruno Morgado on 23/12/14.
//  Copyright (c) 2014 kocomputer. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

class KeyframeInterpolator: NSObject {
    
    // MARK: - Helper methods
    
    class func getPercentageForOffset(offset: Float, animation: ScrollableKeyframeAnimation) -> Float {
        return (offset - animation.beginOffset) / animation.distance
    }
    
    class func getPercentageRelativeToInterval(interval: Int, forOffset offset: Float, animation: ScrollableKeyframeAnimation) -> Float {
        if let keyOffsets = animation.keyOffsets {
            let offsetPercentage = KeyframeInterpolator.getPercentageForOffset(offset, animation: animation) - keyOffsets[interval]
            let horizontalDelta = keyOffsets[interval + 1] - keyOffsets[interval]
            return offsetPercentage / horizontalDelta;
        } else {
            println("Warning!! animation: \(animation) doesn't have keyOffsets")
            return 0
        }
    }
    
    class func getValuesIntervalForOffsetPercentage(offsetPercentage: Float, animation: ScrollableKeyframeAnimation) -> Int {
        if let keyOffsets = animation.keyOffsets {
            if (offsetPercentage < 0) {
                return 0;
            } else if (offsetPercentage > 1) {
                return keyOffsets.count - 1;
            }
            else {
                for (index, o) in enumerate(keyOffsets) {
                    if (offsetPercentage >= keyOffsets[index] && offsetPercentage <= keyOffsets[index + 1]) {
                        return index;
                    }
                }
            }
            return 0;
        } else {
            println("Warning!! animation: \(animation) doesn't have keyOffsets")
            return 0;
        }
    }
}

protocol KeyframeInterpolatorProtocol: InterpolatorProtocol {
    func interpolateAnimation(animation: ScrollableAnimation, forAnimatable animatable: CALayer, forOffset offset: Float)
}
