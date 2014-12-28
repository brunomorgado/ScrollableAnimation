//
//  KeyframeNumberInterpolator.swift
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

class KeyframeNumberInterpolator: KeyframeInterpolator {
    var animatable: CALayer
    
    required init(animatable: CALayer) {
        self.animatable = animatable
    }
}

extension KeyframeNumberInterpolator: KeyframeInterpolatorProtocol {
    func interpolateAnimation(animation: ScrollableAnimation, forAnimatable animatable: CALayer, forOffset offset: Float) {
        if let animation = animation as? ScrollableKeyframeAnimation {
            let offsetPercentage = KeyframeInterpolator.getPercentageForOffset(offset, animation: animation)
            let currentValuesInterval = KeyframeInterpolator.getValuesIntervalForOffsetPercentage(offsetPercentage, animation: animation)
            if let animationValues = animation.values as? [Float] {
                var number = animationValues[0] as Float
                if (offsetPercentage <= 0) {
                    number = animationValues[0]
                } else if (offsetPercentage > 1) {
                    number = animationValues[animationValues.count - 1]
                } else {
                    let verticalDelta = Double(animationValues[currentValuesInterval + 1] - animationValues[currentValuesInterval])
                    
                    var tween = TweenBlockNone
                    if let functions = animation.functions {
                        tween = functions[currentValuesInterval]
                    }
                    
                    let intervalOffsetPercentage = Double(KeyframeInterpolator.getPercentageRelativeToInterval(currentValuesInterval, forOffset: offset, animation: animation))
                    number = Float(animationValues[currentValuesInterval]) + Float(tween(intervalOffsetPercentage) * verticalDelta)
                }
                self.animatable.setValue(number, forKeyPath: animation.keyPath)
            } else {
                println("Warning!! Invalid value type when expecting [Float]")
            }
        }
    }
}