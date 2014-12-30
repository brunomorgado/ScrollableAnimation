//
//  ScrollableAnimationTests.swift
//  ScrollableAnimationExample
//
//  Created by Bruno Morgado on 30/12/14.
//  Copyright (c) 2014 kocomputer. All rights reserved.
//

import UIKit
import XCTest
import ScrollableAnimationExample

class ScrollableAnimationTests: XCTestCase {
    let animationController: ScrollableAnimationController = ScrollableAnimationController()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddScrollableAnimation() {
        var mockAnimatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animationDistance = Float(300)
        let fromValue = mockAnimatable.layer.position
        let toValue = CGPointMake(mockAnimatable.layer.position.x, mockAnimatable.layer.position.y + CGFloat(animationDistance))
        let animatableExpectedPosition = toValue
    
        let translation = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        mockAnimatable.layer.addScrollableAnimation(translation, forKey: nil, withController: self.animationController)
        self.animationController.updateAnimatablesForOffset(animationDistance)
        
        XCTAssertEqual(mockAnimatable.layer.position, animatableExpectedPosition)
    }
    
    func testRemoveAllScrollableAnimations() {
        var mockAnimatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animationDistance = Float(300)
        let fromValue = mockAnimatable.layer.position
        let toValue = CGPointMake(mockAnimatable.layer.position.x, mockAnimatable.layer.position.y + CGFloat(animationDistance))
        let animatableExpectedPosition = fromValue
        
        let translation1 = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        let translation2 = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        
        mockAnimatable.layer.addScrollableAnimation(translation1, forKey: nil, withController: self.animationController)
        mockAnimatable.layer.removeAllScrollableAnimationsWithController(animationController)
        self.animationController.updateAnimatablesForOffset(animationDistance)
        
        XCTAssertEqual(mockAnimatable.layer.position, animatableExpectedPosition)
        
        mockAnimatable.layer.addScrollableAnimation(translation1, forKey: nil, withController: self.animationController)
        mockAnimatable.layer.addScrollableAnimation(translation2, forKey: nil, withController: self.animationController)
        mockAnimatable.layer.removeAllScrollableAnimationsWithController(animationController)
        self.animationController.updateAnimatablesForOffset(animationDistance)
        
        XCTAssertEqual(mockAnimatable.layer.position, animatableExpectedPosition)
    }
    
    func testRemoveScrollableAnimationForKey() {
        var mockAnimatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animationDistance = Float(300)
        let fromValue = mockAnimatable.layer.position
        let toValue = CGPointMake(mockAnimatable.layer.position.x, mockAnimatable.layer.position.y + CGFloat(animationDistance))
        let animatableExpectedPosition = fromValue
        let animationKey = "animationKey"
        
        let translation1 = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        let translation2 = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        
        mockAnimatable.layer.addScrollableAnimation(translation1, forKey: animationKey, withController: self.animationController)
        mockAnimatable.layer.removeScrollableAnimationForKey(animationKey, withController: animationController)
        self.animationController.updateAnimatablesForOffset(animationDistance)
        
        XCTAssertEqual(mockAnimatable.layer.position, animatableExpectedPosition)
        
        mockAnimatable.layer.addScrollableAnimation(translation1, forKey: animationKey, withController: self.animationController)
        mockAnimatable.layer.addScrollableAnimation(translation2, forKey: nil, withController: self.animationController)
        mockAnimatable.layer.removeScrollableAnimationForKey(animationKey, withController: animationController)
        self.animationController.updateAnimatablesForOffset(animationDistance)
        
        XCTAssertEqual(mockAnimatable.layer.position, toValue)
    }
    
    func testScrollableAnimationKeys() {
        var mockAnimatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animationDistance = Float(300)
        let fromValue = mockAnimatable.layer.position
        let toValue = CGPointMake(mockAnimatable.layer.position.x, mockAnimatable.layer.position.y + CGFloat(animationDistance))
        let animatableExpectedPosition = toValue
        let keys = ["translation1 Key", "translation2 Key", "translation3 Key"]
        
        
        let translation1 = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        mockAnimatable.layer.addScrollableAnimation(translation1, forKey: keys[0], withController: self.animationController)
        let translation2 = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        mockAnimatable.layer.addScrollableAnimation(translation2, forKey: keys[1], withController: self.animationController)
        let translation3 = self.getMockTranslationFromValue(fromValue, toValue: toValue, withDistance: animationDistance)
        mockAnimatable.layer.addScrollableAnimation(translation3, forKey: keys[2], withController: self.animationController)
        
        let animationKeys = mockAnimatable.layer.scrollableAnimationKeysWithController(animationController) as [String]!
        for key in animationKeys {
            let index = find(animationKeys, key)
            XCTAssertEqual(key, keys[index!])
        }
    }
    
    private func getMockTranslationFromValue(fromValue: CGPoint, toValue: CGPoint, withDistance distance: Float) -> ScrollableBasicAnimation {
        let translation = ScrollableBasicAnimation(keyPath: "position")
        translation.beginOffset = 0
        translation.distance = distance
        translation.fromValue = NSValue(CGPoint: fromValue)
        translation.toValue = NSValue(CGPoint: toValue)
        
        return translation
    }
}
