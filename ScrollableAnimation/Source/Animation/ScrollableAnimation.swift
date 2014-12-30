//
//  ScrollableAnimation.swift
//  ScrollableMovie
//
//  Created by Bruno Morgado on 18/12/14.
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

protocol ScrollableAnimation {
    var distance: Float {get set}
    var beginOffset: Float {get set}
    var offsetFunction: TweenBlock? {get set}
    
    func processAnimatable(animatable: CALayer, forOffset offset: Float)
}

protocol ScrollablePropertyAnimation: ScrollableAnimation {
    var keyPath: String {get set}
//    var additive: Bool {get set} //TODO
    
    init(keyPath: String)
}

class ScrollableBasicAnimation: ScrollablePropertyAnimation {
    var distance: Float
    var beginOffset: Float
    var offsetFunction: TweenBlock?
    var keyPath: String
    var additive: Bool
    var fromValue: NSValue?
    var toValue: NSValue?
    
    required init(keyPath: String) {
        self.beginOffset = 0.0
        self.distance = 0.0
        self.additive = false
        self.keyPath = keyPath
    }
    
    func processAnimatable(animatable: CALayer, forOffset offset: Float) {
        let interpolatorFactory = InterpolatorAbstractFactory.interpolatorFactoryForType(.BasicInterpolatorFactory)
        let interpolator = interpolatorFactory?.interpolatorForAnimation(self, animatable: animatable)
        if let interpolator = interpolator {
            interpolator.interpolateAnimation(self, forAnimatable: animatable, forOffset: offset)
        }
    }
}

class ScrollableKeyframeAnimation: ScrollablePropertyAnimation {
    var distance: Float
    var beginOffset: Float
    var offsetFunction: TweenBlock?
    var keyPath: String
    var additive: Bool
    var keyOffsets = [Float]?()
    var values = [AnyObject]?()
    var functions = [TweenBlock]?()
    
    required init(keyPath: String) {
        self.beginOffset = 0.0
        self.distance = 0.0
        self.additive = false
        self.keyPath = keyPath
        self.keyOffsets = nil
        self.values = nil
        self.functions = nil
    }
    
    func processAnimatable(animatable: CALayer, forOffset offset: Float) {
        let interpolatorFactory = InterpolatorAbstractFactory.interpolatorFactoryForType(.KeyframeInterpolatorFactory)
        let interpolator = interpolatorFactory?.interpolatorForAnimation(self, animatable: animatable)
        if let interpolator = interpolator {
            interpolator.interpolateAnimation(self, forAnimatable: animatable, forOffset: offset)
        }
    }
}

// TODO - implement delegate
//@objc protocol ScrollableAnimationDelegate {
//    func scrollableAnimationDidStart(anim: ScrollableAnimation!)
//    func scrollableAnimationDidStop(anim: ScrollableAnimation!, finished flag: Bool)
//}

extension CALayer {
    func addScrollableAnimation(anim: ScrollableAnimation!, forKey key: String!, withController controller: ScrollableAnimationController) {
        controller.registerAnimation(anim, forKey: key, forAnimatable: self)
    }
    
    func removeAllScrollableAnimationsWithController(controller: ScrollableAnimationController) {
        controller.unregisterAllAnimationsForAnimatable(self)
    }
    
    func removeScrollableAnimationForKey(key: String!, withController controller: ScrollableAnimationController) {
        controller.unregisterAnimationForAnimatable(self, forKey: key)
    }
    
    func scrollableAnimationKeysWithController(controller: ScrollableAnimationController) -> [String]? {
        return controller.animationKeysForAnimatable(self)
    }
    
    func scrollableAnimationForKey(key: String!, withController controller: ScrollableAnimationController) -> ScrollableAnimation? {
        return controller.animationForKey(key, forAnimatable: self)
    }
}