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

class ScrollableAnimation: NSObject {
    var distance: Float
    var beginOffset: Float
    var offsetFunction: TweenBlock?
    var delegate: AnyObject!
    var isAnimating: Bool
    
    override init() {
        self.beginOffset = 0.0
        self.distance = 0.0
        self.isAnimating = false
        super.init()
    }
    
    func processAnimatable(animatable: CALayer, forOffset offset: Float) {
        self.updateStatusForOffset(offset)
    }
    
    // MARK: - Private methods
    
    private func updateStatusForOffset(offset: Float) {
        var offsetPercentage = self.getPercentageForOffset(offset)
        if (offsetPercentage <= 0 || offsetPercentage >= 1) {
            if (isAnimating) {
                delegate?.scrollableAnimationDidStop!(self)
            }
            isAnimating = false
        } else {
            if (!isAnimating) {
                delegate?.scrollableAnimationDidStart!(self)
            }
            isAnimating = true
        }
    }
    
    // MARK: - Helper methods
    
    private func getPercentageForOffset(offset: Float) -> Float {
        return (offset - self.beginOffset) / self.distance
    }
}

class ScrollablePropertyAnimation: ScrollableAnimation {
    var keyPath: String
//    var additive: Bool {get set} //TODO
    
    init(keyPath: String) {
        self.keyPath = keyPath
        super.init()
    }
}

class ScrollableBasicAnimation: ScrollablePropertyAnimation {
    var fromValue: NSValue?
    var toValue: NSValue?

    override func processAnimatable(animatable: CALayer, forOffset offset: Float) {
        super.processAnimatable(animatable, forOffset: offset)
        let interpolatorFactory = InterpolatorAbstractFactory.interpolatorFactoryForType(.BasicInterpolatorFactory)
        let interpolator = interpolatorFactory?.interpolatorForAnimation(self, animatable: animatable)
        if let interpolator = interpolator {
            interpolator.interpolateAnimation(self, forAnimatable: animatable, forOffset: offset)
        }
    }
}

class ScrollableKeyframeAnimation: ScrollablePropertyAnimation {
    var keyOffsets = [Float]?()
    var values = [AnyObject]?()
    var functions = [TweenBlock]?()

    override func processAnimatable(animatable: CALayer, forOffset offset: Float) {
        super.processAnimatable(animatable, forOffset: offset)
        let interpolatorFactory = InterpolatorAbstractFactory.interpolatorFactoryForType(.KeyframeInterpolatorFactory)
        let interpolator = interpolatorFactory?.interpolatorForAnimation(self, animatable: animatable)
        if let interpolator = interpolator {
            interpolator.interpolateAnimation(self, forAnimatable: animatable, forOffset: offset)
        }
    }
}

// TODO - implement delegate
@objc protocol ScrollableAnimationDelegate {
    optional func scrollableAnimationDidStart(anim: ScrollableAnimation!)
    optional func scrollableAnimationDidStop(anim: ScrollableAnimation!)
}

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