//
//  BasicValueInterpolator.swift
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

class BasicValueInterpolator: BasicInterpolator {
    var animatable: CALayer
    
    required init(animatable: CALayer) {
        self.animatable = animatable
    }
    
    private func interpolatedPoint(offset: Float, animation: ScrollableBasicAnimation) -> CGPoint {
        var point = CGPointZero
        
        if let animation = animation as ScrollableBasicAnimation? {
            let offsetPercentage = BasicInterpolator.getPercentageForOffset(offset, animation: animation)
            if let fromValue = animation.fromValue as NSValue? {
                if let toValue = animation.toValue as NSValue? {
                    
                    let verticalDeltaX = Double(toValue.CGPointValue().x - fromValue.CGPointValue().x)
                    let verticalDeltaY = Double(toValue.CGPointValue().y - fromValue.CGPointValue().y)
                    var valueX: Float
                    var valueY: Float
                    
                    var tween = animation.offsetFunction
                    if let tween = tween as TweenBlock? {
                        valueX = Float(fromValue.CGPointValue().x) + Float(tween(Double(offsetPercentage))) * Float(verticalDeltaX)
                        valueY = Float(fromValue.CGPointValue().y) + Float(tween(Double(offsetPercentage))) * Float(verticalDeltaY)
                    } else {
                        valueX = Float(fromValue.CGPointValue().x) + (offsetPercentage * Float(verticalDeltaX))
                        valueY = Float(fromValue.CGPointValue().y) + offsetPercentage * Float(verticalDeltaY)
                    }
                    point = CGPoint(x: CGFloat(valueX), y: CGFloat(valueY))
                }
            }
        }
        return point
    }
    
    private func interpolatedSize(offset: Float, animation: ScrollableBasicAnimation) -> CGSize {
        var size = CGSizeZero
        
        if let animation = animation as ScrollableBasicAnimation? {
            let offsetPercentage = BasicInterpolator.getPercentageForOffset(offset, animation: animation)
            if let fromValue = animation.fromValue as NSValue? {
                if let toValue = animation.toValue as NSValue? {
                    
                    let verticalDeltaWidth = Double(toValue.CGSizeValue().width - fromValue.CGSizeValue().width)
                    let verticalDeltaHeight = Double(toValue.CGSizeValue().height - fromValue.CGSizeValue().height)
                    var valueWidth: Float
                    var valueHeight: Float
                    
                    var tween = animation.offsetFunction
                    if let tween = tween as TweenBlock? {
                        valueWidth = Float(fromValue.CGSizeValue().width) + Float(tween(Double(offsetPercentage))) * Float(verticalDeltaWidth)
                        valueHeight = Float(fromValue.CGSizeValue().height) + Float(tween(Double(offsetPercentage))) * Float(verticalDeltaHeight)
                    } else {
                        valueWidth = Float(fromValue.CGSizeValue().width) + offsetPercentage * Float(verticalDeltaWidth)
                        valueHeight = Float(fromValue.CGSizeValue().height) + offsetPercentage * Float(verticalDeltaHeight)
                    }
                    size = CGSize(width: CGFloat(valueWidth), height: CGFloat(valueHeight))
                }
            }
        }
        return size
    }
}

extension BasicValueInterpolator: BasicInterpolatorProtocol {
    func interpolateAnimation(animation: ScrollableAnimation, forAnimatable animatable: CALayer, forOffset offset: Float) {
        if let animation = animation as? ScrollableBasicAnimation {
            if let fromValue = animation.fromValue as NSValue? {
                if let toValue = animation.toValue as NSValue? {
                    let type = String.fromCString(toValue.objCType) ?? ""
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
                    println("Warning!! Invalid value type when expecting NSValue")
                }
            } else {
                println("Warning!! Invalid value type when expecting NSValue")
            }
        } else {
            println("Warning!! Invalid value type when expecting NSValue")
        }
    }
}