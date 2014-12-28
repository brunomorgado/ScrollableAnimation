//
//  KeyframeInterpolatorFactory.swift
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

class KeyframeInterpolatorFactory: InterpolatorFactoryProtocol {
    func interpolatorForAnimation(animation: ScrollableAnimation, animatable: CALayer) -> InterpolatorProtocol? {
        if let keyframeAnimation = animation as? ScrollableKeyframeAnimation {
            
            let values = keyframeAnimation.values as [AnyObject]?
            let property: AnyObject = values![0]
            
            switch true {
            case (property is Float):
                return KeyframeNumberInterpolator(animatable: animatable)
            case (property is NSValue):
                return KeyframeValueInterpolator(animatable: animatable)
            case (property is CGImageRef):
                return KeyframeImageInterpolator(animatable: animatable)
            default:
                println("Warning!! Couldn't find any appropriate interpolator for keyPath \(keyframeAnimation.keyPath)")
                return nil
            }
        }
        return nil
    }
}
