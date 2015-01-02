//
//  InterpolatorTests.swift
//  ScrollableAnimationExample
//
//  Created by Bruno Morgado on 01/01/15.
//  Copyright (c) 2015 kocomputer. All rights reserved.
//

import UIKit
import XCTest

class InterpolatorTests: XCTestCase {
    let animationController: ScrollableAnimationController = ScrollableAnimationController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInterpolatorFactory() {
        var mockAnimatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animationDistance = Float(300)
        var fromValue1 = mockAnimatable.layer.position
        var toValue1 = CGPointMake(mockAnimatable.layer.position.x, mockAnimatable.layer.position.y + CGFloat(animationDistance))
        let animatableExpectedPosition = fromValue1
        
        var basicAnimation = self.getMockBasicTranslationFromValue(fromValue1, toValue: toValue1, offsetFunction: TweenBlockEaseOutBounce, withDistance: animationDistance)
        
        /*****
        
        BasicInterpolator
        
        *****/
        
        // BasicValueInterpolator
        var interpolatorFactory = InterpolatorAbstractFactory.interpolatorFactoryForType(.BasicInterpolatorFactory)
        var interpolator = interpolatorFactory?.interpolatorForAnimation(basicAnimation, animatable: mockAnimatable.layer)
        if let interpolator = interpolator {
            XCTAssertTrue(interpolator is BasicValueInterpolator)
        } else {
            XCTAssertTrue(false)
        }
        
        // BasicNumberInterpolator
        let fromValue2 = Float(1.0)
        let toValue2 = Float(0.0)
        
        basicAnimation = self.getMockBasicOpacityAnimationFromValue(fromValue2, toValue: toValue2, offsetFunction: TweenBlockEaseInQuad, withDistance: animationDistance)
        
        interpolator = interpolatorFactory?.interpolatorForAnimation(basicAnimation, animatable: mockAnimatable.layer)
        if let interpolator = interpolator {
            XCTAssertTrue(interpolator is BasicNumberInterpolator)
        } else {
            XCTAssertTrue(false)
        }
        
        /*****
        
        KeyframeInterpolator
        
        *****/
        
        // KeyframeValueInterpolator
        let values1: [AnyObject] = [NSValue(CGPoint: CGPointZero),NSValue(CGPoint: CGPointZero)]
        let keyOffsets1 = [Float(0.0),Float(1.0)]
        
        var keyFrameAnimation = self.getMockKeyframeTranslationWithValues(values1, keyOffsets: keyOffsets1, functions: nil, withDistance: animationDistance)
        
        interpolatorFactory = InterpolatorAbstractFactory.interpolatorFactoryForType(.KeyframeInterpolatorFactory)
        interpolator = interpolatorFactory?.interpolatorForAnimation(keyFrameAnimation, animatable: mockAnimatable.layer)
        if let interpolator = interpolator {
            XCTAssertTrue(interpolator is KeyframeValueInterpolator)
        } else {
            XCTAssertTrue(false)
        }
        
        // KeyframeNumberInterpolator
        let values2 = [Float(0.0), Float(1.0)]
        let keyOffsets2 = [Float(0.0), Float(1.0)]
        
        keyFrameAnimation = self.getMockKeyframeOpacityAnimationWithValues(values2, keyOffsets: keyOffsets2, functions: nil, withDistance: animationDistance)
        
        interpolator = interpolatorFactory?.interpolatorForAnimation(keyFrameAnimation, animatable: mockAnimatable.layer)
        if let interpolator = interpolator {
            XCTAssertTrue(interpolator is KeyframeNumberInterpolator)
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testBasicNumberInterpolator () {
        let animation = self.getMockBasicOpacityAnimationFromValue(1.0, toValue: 0.0, offsetFunction: TweenBlockEaseInQuad, withDistance: 800)
        let animatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        animatable.layer.addScrollableAnimation(animation, forKey: "opacityAnimation", withController: animationController)
        
        let completionExpectation1 = expectationWithDescription("finished1")
        let completionExpectation2 = expectationWithDescription("finished2")
        let completionExpectation3 = expectationWithDescription("finished3")
        let completionExpectation4 = expectationWithDescription("finished4")
        
        animationController.updateAnimatablesForOffset(animation.beginOffset - 100) {
            XCTAssertEqual(animatable.layer.opacity, animation.fromValue as Float)
            completionExpectation1.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.beginOffset) {
            XCTAssertEqual(animatable.layer.opacity, animation.fromValue as Float)
            completionExpectation2.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance) {
            XCTAssertEqual(animatable.layer.opacity, animation.toValue as Float)
            completionExpectation3.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance + 100) {
            XCTAssertEqual(animatable.layer.opacity, animation.toValue as Float)
            completionExpectation4.fulfill()
        }

        waitForExpectationsWithTimeout(2, { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testBasicValueInterpolator () {
        let animatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animation = self.getMockBasicTranslationFromValue(animatable.layer.position, toValue: CGPointMake(animatable.layer.position.x, animatable.layer.position.y + 100), offsetFunction: TweenBlockEaseOutElastic, withDistance: 800)
        
        animatable.layer.addScrollableAnimation(animation, forKey: "translationAnimation", withController: animationController)
        
        let completionExpectation1 = expectationWithDescription("finished1")
        let completionExpectation2 = expectationWithDescription("finished2")
        let completionExpectation3 = expectationWithDescription("finished3")
        let completionExpectation4 = expectationWithDescription("finished4")
        
        animationController.updateAnimatablesForOffset(animation.beginOffset - 100) {
            XCTAssertEqual(animatable.layer.position, animation.fromValue!.CGPointValue())
            completionExpectation1.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.beginOffset) {
            XCTAssertEqual(animatable.layer.position, animation.fromValue!.CGPointValue())
            completionExpectation2.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance) {
            XCTAssertEqual(animatable.layer.position, animation.toValue!.CGPointValue())
            completionExpectation3.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance + 100) {
            XCTAssertEqual(animatable.layer.position, animation.toValue!.CGPointValue())
            completionExpectation4.fulfill()
        }

        waitForExpectationsWithTimeout(2, { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testKeyframeNumberInterpolator () {
        let animatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animation = self.getMockKeyframeOpacityAnimationWithValues([Float(0.0), Float(1.0)], keyOffsets: [Float(0.0), Float(1.0)], functions: [TweenBlockEaseOutExpo], withDistance: 800)

        animatable.layer.addScrollableAnimation(animation, forKey: "opacity", withController: animationController)
        
        let completionExpectation1 = expectationWithDescription("finished1")
        let completionExpectation2 = expectationWithDescription("finished2")
        let completionExpectation3 = expectationWithDescription("finished3")
        let completionExpectation4 = expectationWithDescription("finished4")
        
        animationController.updateAnimatablesForOffset(animation.beginOffset - 100) {
            XCTAssertEqual(animatable.layer.opacity, animation.values![0] as Float)
            completionExpectation1.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.beginOffset) {
            XCTAssertEqual(animatable.layer.opacity, animation.values![0] as Float)
            completionExpectation2.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance) {
            XCTAssertEqual(animatable.layer.opacity, animation.values![animation.values!.count - 1] as Float)
            completionExpectation3.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance + 100) {
            XCTAssertEqual(animatable.layer.opacity, animation.values![animation.values!.count - 1] as Float)
            completionExpectation4.fulfill()
        }

        waitForExpectationsWithTimeout(2, { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testKeyframeValueInterpolator () {
        let animatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        let animation = self.getMockKeyframeTranslationWithValues([NSValue(CGPoint: animatable.layer.position),NSValue(CGPoint: CGPointMake(animatable.layer.position.x, animatable.layer.position.y + 200))], keyOffsets: [Float(0.0),Float(1.0)], functions: [TweenBlockEaseOutExpo], withDistance: 800)
        
        animatable.layer.addScrollableAnimation(animation, forKey: "position", withController: animationController)
        
        let completionExpectation1 = expectationWithDescription("finished1")
        let completionExpectation2 = expectationWithDescription("finished2")
        let completionExpectation3 = expectationWithDescription("finished3")
        let completionExpectation4 = expectationWithDescription("finished4")
        
        animationController.updateAnimatablesForOffset(animation.beginOffset - 100) {
            XCTAssertEqual(animatable.layer.position, animation.values![0].CGPointValue())
            completionExpectation1.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.beginOffset) {
            XCTAssertEqual(animatable.layer.position, animation.values![0].CGPointValue())
            completionExpectation2.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance) {
            XCTAssertEqual(animatable.layer.position, animation.values![animation.values!.count - 1].CGPointValue())
            completionExpectation3.fulfill()
        }
        
        animationController.updateAnimatablesForOffset(animation.distance + 100) {
            XCTAssertEqual(animatable.layer.position, animation.values![animation.values!.count - 1].CGPointValue())
            completionExpectation4.fulfill()
        }
        
        waitForExpectationsWithTimeout(2, { error in
            XCTAssertNil(error, "Error")
        })
    }

    // MARK: - Helper methods
    
    private func getMockBasicTranslationFromValue(fromValue: CGPoint, toValue: CGPoint, offsetFunction: TweenBlock, withDistance distance: Float) -> ScrollableBasicAnimation {
        let animation = ScrollableBasicAnimation(keyPath: "position")
        animation.beginOffset = 0
        animation.distance = distance
        animation.fromValue = NSValue(CGPoint: fromValue)
        animation.toValue = NSValue(CGPoint: toValue)
        animation.offsetFunction = offsetFunction
        return animation
    }
    
    private func getMockBasicOpacityAnimationFromValue(fromValue: Float, toValue: Float, offsetFunction: TweenBlock, withDistance distance: Float) -> ScrollableBasicAnimation {
        let animation = ScrollableBasicAnimation(keyPath: "opacity")
        animation.beginOffset = 0
        animation.distance = distance
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.offsetFunction = offsetFunction
        return animation
    }
    
    private func getMockKeyframeTranslationWithValues(values: [AnyObject]?, keyOffsets: [Float]?, functions: [TweenBlock]?, withDistance distance: Float) -> ScrollableKeyframeAnimation {
        let animation = ScrollableKeyframeAnimation(keyPath: "position")
        animation.beginOffset = 0
        animation.distance = distance
        animation.values = values
        animation.keyOffsets = keyOffsets
        animation.functions = functions
        return animation
    }
    
    private func getMockKeyframeRotationWithValues(values: [AnyObject]?, keyOffsets: [Float]?, functions: [TweenBlock]?, withDistance distance: Float) -> ScrollableKeyframeAnimation {
        let animation = ScrollableKeyframeAnimation(keyPath: "transform.rotation.x")
        animation.beginOffset = 0
        animation.distance = distance
        animation.values = values
        animation.keyOffsets = keyOffsets
        animation.functions = functions
        return animation
    }
    
    private func getMockKeyframeOpacityAnimationWithValues(values: [AnyObject]?, keyOffsets: [Float]?, functions: [TweenBlock]?, withDistance distance: Float) -> ScrollableKeyframeAnimation {
        let animation = ScrollableKeyframeAnimation(keyPath: "opacity")
        animation.beginOffset = 0
        animation.distance = distance
        animation.values = values
        animation.keyOffsets = keyOffsets
        animation.functions = functions
        return animation
    }
}
