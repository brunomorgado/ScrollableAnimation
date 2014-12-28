//
//  BasicInterpolatorFactory.swift
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

class BasicInterpolatorFactory: InterpolatorFactoryProtocol {
    func interpolatorForAnimation(animation: ScrollableAnimation, animatable: CALayer) -> InterpolatorProtocol? {
        if let basicAnimation = animation as? ScrollableBasicAnimation {
            var property: AnyObject
            let fromValue: AnyObject? = basicAnimation.fromValue as AnyObject?
            let toValue: AnyObject? = basicAnimation.toValue as AnyObject?
            if let fromValue: AnyObject = fromValue as AnyObject? {
                if let toValue: AnyObject = toValue as AnyObject? {
                    switch true {
                    case (fromValue is Float):
                        return BasicNumberInterpolator(animatable: animatable)
                    case (fromValue is NSValue):
                        return BasicValueInterpolator(animatable: animatable)
                    case (fromValue is CGImageRef):
                        return BasicImageInterpolator(animatable: animatable)
                    default:
                        println("Warning!! Couldn't find any appropriate interpolator for animation \(animation)")
                        return nil
                    }
                }
            }  else {
                println("Warning!! Couldn't find any appropriate interpolator for animation \(animation)")
                return nil
            }
        }
        return nil
    }
}