//
//  KeyframeValueInterpolator.swift
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

class KeyframeValueInterpolator: KeyframeInterpolator {
    var animatable: CALayer
    
    required init(animatable: CALayer) {
        self.animatable = animatable
    }
    
    private func interpolatedPoint(offset: Float, animation: ScrollableKeyframeAnimation) -> CGPoint {
        var point = CGPointZero
        
        let offsetPercentage = KeyframeInterpolator.getPercentageForOffset(offset, animation: animation)
        let currentValuesInterval = KeyframeInterpolator.getValuesIntervalForOffsetPercentage(offsetPercentage, animation: animation)
        if let animationValues = animation.values as? [NSValue] {
            
            var value = animationValues[0]
            
            if (offsetPercentage <= 0) {
                point = animationValues[0].CGPointValue()
            } else if (offsetPercentage > 1) {
                point = animationValues[animationValues.count - 1].CGPointValue()
            } else {
                let verticalDeltaX = Double(animationValues[currentValuesInterval + 1].CGPointValue().x - animationValues[currentValuesInterval].CGPointValue().x)
                let verticalDeltaY = Double(animationValues[currentValuesInterval + 1].CGPointValue().y - animationValues[currentValuesInterval].CGPointValue().y)
                
                var tween = TweenBlockNone
                if let functions = animation.functions {
                    let tween = functions[currentValuesInterval]
                }
                
                let intervalOffsetPercentage = Double(KeyframeInterpolator.getPercentageRelativeToInterval(currentValuesInterval, forOffset: offset, animation: animation))
                let valueX = Double(animationValues[currentValuesInterval].CGPointValue().x) + (tween(intervalOffsetPercentage) * verticalDeltaX)
                let valueY = Double(animationValues[currentValuesInterval].CGPointValue().y) + (tween(intervalOffsetPercentage) * verticalDeltaY)
                
                point = CGPoint(x: valueX, y: valueY)
            }
        } else {
            println("Warning!! Invalid value type when expecting [NSValue]")
        }
        return point
    }
    
    private func interpolatedSize(offset: Float, animation: ScrollableKeyframeAnimation) -> CGSize {
        var size = CGSizeZero
        
        let offsetPercentage = KeyframeInterpolator.getPercentageForOffset(offset, animation: animation)
        let currentValuesInterval = KeyframeInterpolator.getValuesIntervalForOffsetPercentage(offsetPercentage, animation: animation)
        if let animationValues = animation.values as? [NSValue] {
            
            var value = animationValues[0]
            
            if (offsetPercentage <= 0) {
                size = animationValues[0].CGSizeValue()
            } else if (offsetPercentage > 1) {
                size = animationValues[animationValues.count - 1].CGSizeValue()
            } else {
                let verticalDeltaWidth = Double(animationValues[currentValuesInterval + 1].CGSizeValue().width - animationValues[currentValuesInterval].CGSizeValue().width)
                let verticalDeltaHeight = Double(animationValues[currentValuesInterval + 1].CGSizeValue().height - animationValues[currentValuesInterval].CGSizeValue().height)
                
                var tween = TweenBlockNone
                if let functions = animation.functions {
                    let tween = functions[currentValuesInterval]
                }
                
                let intervalOffsetPercentage = Double(KeyframeInterpolator.getPercentageRelativeToInterval(currentValuesInterval, forOffset: offset, animation: animation))
                let valueWidth = Double(animationValues[currentValuesInterval].CGSizeValue().width) + (tween(intervalOffsetPercentage) * verticalDeltaWidth)
                let valueHeight = Double(animationValues[currentValuesInterval].CGSizeValue().height) + (tween(intervalOffsetPercentage) * verticalDeltaHeight)
                
                size = CGSize(width: valueWidth, height: valueHeight)
            }
        } else {
            println("Warning!! Invalid value type when expecting [NSValue]")
        }
        return size
    }
}

extension KeyframeValueInterpolator: KeyframeInterpolatorProtocol {
    func interpolateAnimation(animation: ScrollableAnimation, forAnimatable animatable: CALayer, forOffset offset: Float) {
        if let animation = animation as? ScrollableKeyframeAnimation {
            if let animationValues = animation.values as? [NSValue] {
                
                var value = animationValues[0]
                
                let type = String.fromCString(value.objCType) ?? ""
                switch true {
                case type.hasPrefix("{CGPoint"):
                    let point = self.interpolatedPoint(offset, animation: animation)
                    self.animatable.setValue(NSValue(CGPoint: point), forKeyPath: animation.keyPath)
                    
                case type.hasPrefix("{CGSize"):
                    let size = self.interpolatedSize(offset, animation: animation)
                    self.animatable.setValue(NSValue(CGSize: size), forKeyPath: animation.keyPath)
                default:
                    return
                }
            } else {
                println("Warning!! Invalid value type when expecting [NSValue]")
            }
        }
    }
}