//
//  ScrollableAnimationController.swift
//  ScrollableAnimationTemp
//
//  Created by Bruno Morgado on 26/12/14.
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

class AnimatableItem: NSObject {
    var animatable: CALayer
    var animations = [ScrollableAnimationItem]()
    init(animatable: CALayer) {
        self.animatable = animatable
    }
}

class ScrollableAnimationItem: NSObject {
    var animation: ScrollableAnimation
    var key: String?
    init(animation: ScrollableAnimation, key: String?) {
        self.animation = animation
        self.key = key
    }
}

class ScrollableAnimationController: NSObject {
    private var animatables = [AnimatableItem]()
    
    func registerAnimation(animation: ScrollableAnimation, forKey key: String?, forAnimatable animatable: CALayer) {
        objc_sync_enter(self)
        let animationItem = ScrollableAnimationItem(animation: animation, key: key)
        let animatableItem = AnimatableItem(animatable: animatable)
        if (animatables.isEmpty) {
            animatableItem.animations = [animationItem]
            animatables.append(animatableItem)
        } else {
            let animatablesCount = animatables.count
            for index in 0..<animatablesCount {
                let actualAnimatable = animatables[index].animatable
                if (animatable == actualAnimatable) {
                    animatables[index].animations.append(animationItem)
                } else if (index == animatablesCount - 1) {
                    animatableItem.animations = [animationItem]
                    animatables.append(animatableItem)
                }
            }
        }
        objc_sync_exit(self)
    }
    
    func unregisterAllAnimationsForAnimatable(animatable: CALayer) {
        objc_sync_enter(self)
        for animatableItem in animatables {
            if (animatable == animatableItem.animatable) {
                animatableItem.animations.removeAll(keepCapacity: false)
            }
        }
        objc_sync_exit(self)
    }
    
    func unregisterAnimationForAnimatable(animatable: CALayer, forKey key: String!) {
        objc_sync_enter(self)
        for animatableItem in animatables {
            for animationItem in animatableItem.animations {
                if (animationItem.key == key) {
                    if let index = find(animatableItem.animations, animationItem) {
                        animatableItem.animations.removeAtIndex(index)
                    }
                }
            }
        }
        objc_sync_exit(self)
    }
    
    func animationKeysForAnimatable(animatable: CALayer) -> [String]? {
        var keys = [String]()
        objc_sync_enter(self)
        for animatableItem in animatables {
            if (animatableItem.animatable == animatable) {
                for animationItem in animatableItem.animations {
                    if let key = animationItem.key {
                        keys.append(key)
                    }
                }
            }
        }
        objc_sync_exit(self)
        if keys.isEmpty {
            return nil
        } else {
            return keys
        }
    }
    
    func animationForKey(animationKey: String!, forAnimatable animatable: CALayer) -> ScrollableAnimation? {
        var returnAnimation: ScrollableAnimation? = nil
        objc_sync_enter(self)
        for animatableItem in animatables {
            if (animatableItem.animatable == animatable) {
                for animationItem in animatableItem.animations {
                    if let key = animationItem.key {
                        if (key == animationKey) {
                            returnAnimation = animationItem.animation
                        }
                    }
                }
            }
        }
        objc_sync_exit(self)
        return returnAnimation
    }
    
    func updateAnimatablesForOffset(offset: Float) {
        objc_sync_enter(self)
        for animatableItem in animatables {
            let animationItems = animatableItem.animations
            for animationItem in animationItems {
                animationItem.animation.processAnimatable(animatableItem.animatable, forOffset: offset)
            }
        }
        objc_sync_exit(self)
    }
}