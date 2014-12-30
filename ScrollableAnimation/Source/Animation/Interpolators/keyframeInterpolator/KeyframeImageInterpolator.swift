//
//  KeyframeImageInterpolator.swift
//  ScrollableMovie
//
//  Created by Bruno Morgado on 25/12/14.
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

class KeyframeImageInterpolator: KeyframeInterpolator {
    var animatable: CALayer
    
    required init(animatable: CALayer) {
        self.animatable = animatable
    }
    
    private func imageFrameForOffset(offset: Float, animation: ScrollableKeyframeAnimation) -> CGImageRef? {
        let offsetPercentage = KeyframeInterpolator.getPercentageForOffset(offset, animation: animation)
        let currentFrame: Int? = self.computeCurrentFrameForOffsetPercentage(offsetPercentage, animation: animation)
        
        if let images = animation.values as? [CGImageRef] {
            if let currentFrame = currentFrame{
                if ((currentFrame >= images.count) || (currentFrame < 0)) {
                    return nil
                }
                return images[currentFrame]
            }
        }
        return nil
    }
    
    private func computeCurrentFrameForOffsetPercentage(offsetPercentage: Float, animation: ScrollableKeyframeAnimation) -> Int? {
        if let images = animation.values as? [CGImageRef] {
            var frameNumber: Int = Int(Float(images.count) * offsetPercentage)
            
            if (frameNumber < 0) {
                frameNumber = 0
            } else if (frameNumber >= images.count) {
                frameNumber = images.count - 1
            }
            return frameNumber
        }
        return nil
    }
}

extension KeyframeImageInterpolator: KeyframeInterpolatorProtocol {
    func interpolateAnimation(animation: ScrollableAnimation, forAnimatable animatable: CALayer, forOffset offset: Float) {
        if let animation = animation as? ScrollableKeyframeAnimation {
            if let animationValues = animation.values as? [CGImageRef] {
                let imageFrame = self.imageFrameForOffset(offset, animation: animation)
                self.animatable.setValue(imageFrame, forKeyPath: animation.keyPath)
            } else {
                println("Warning!! Invalid value type when expecting [NSValue]")
            }
        }
    }
}