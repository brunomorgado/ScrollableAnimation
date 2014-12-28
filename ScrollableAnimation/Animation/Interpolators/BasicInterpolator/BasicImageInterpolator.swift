//
//  BasicImageInterpolator.swift
//  ScrollableMovie
//
//  Created by Bruno Morgado on 25/12/14.
//  Copyright (c) 2014 kocomputer. All rights reserved.
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
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

class BasicImageInterpolator: BasicInterpolator {
    var animatable: CALayer
    
    required init(animatable: CALayer) {
        self.animatable = animatable
    }
}

extension BasicImageInterpolator: BasicInterpolatorProtocol {
    func interpolateAnimation(animation: ScrollableAnimation, forAnimatable animatable: CALayer, forOffset offset: Float) {
//        if let animation = animation as? ScrollableBasicAnimation {
//            let offsetPercentage = BasicInterpolator.getPercentageForOffset(offset, animation: animation)
//            if let fromValue = animation.fromValue as Float? {
//                if let toValue = animation.toValue as Float? {
//                    var number = animation.toValue as Float
//                    
//                    let verticalDelta = Double(toValue - fromValue)
//                    
//                    var tween = animation.offsetFunction
//                    if let tween = tween as TweenBlock? {
//                        number = Float(tween(Double(offsetPercentage))) * Float(verticalDelta)
//                    } else {
//                        number = offsetPercentage * Float(verticalDelta)
//                    }
//                    self.animatable.layer.setValue(number, forKeyPath: animation.keyPath)
//                }
//            }
//        }
    }
}