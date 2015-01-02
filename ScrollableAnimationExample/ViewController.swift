//
//  ViewController.swift
//  ScrollableAnimationExample
//
//  Created by Bruno Morgado on 28/12/14.
//  Copyright (c) 2014 kocomputer. All rights reserved.
//

import UIKit

let AnimationDistance: Float = 800

class ViewController: UIViewController {
    let animationController = ScrollableAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func loadView() {
        super.loadView()
        
        let controlScrollView = UIScrollView(frame: self.view.frame)
        controlScrollView.backgroundColor = UIColor.clearColor()
        controlScrollView.delegate = self
        controlScrollView.contentSize = CGSizeMake(controlScrollView.frame.size.width, CGFloat(AnimationDistance) + 1500)
        self.view.addSubview(controlScrollView)
        
        
//        let animatable = UIView(frame: CGRectMake(0, 0, 100, 100))
//        animatable.backgroundColor = UIColor.blueColor()
//        self.view.addSubview(animatable)
//        
//        let rotation = ScrollableKeyframeAnimation(keyPath: "transform.rotation.z")
//        rotation.delegate = self
//        rotation.beginOffset = 0
//        rotation.distance = AnimationDistance
//        
//        var offsets: [Float] = [0.0, 0.5, 1.0]
//        var values: [AnyObject] = [0.0, Float(M_PI), 0.0]
//        var functions: [TweenBlock] = [TweenBlockEaseInQuad, TweenBlockEaseInQuad]
//        
//        rotation.keyOffsets = offsets
//        rotation.values = values
//        rotation.functions = functions
//        animatable.layer.addScrollableAnimation(rotation, forKey: "rotation", withController: animationController)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let animatable = UIView(frame: CGRectMake(0, 0, 100, 100))
        animatable.backgroundColor = UIColor.blueColor()
        self.view.addSubview(animatable)
        
        let rotation = ScrollableKeyframeAnimation(keyPath: "transform.rotation.x")
        rotation.delegate = self
        rotation.beginOffset = 0
        rotation.distance = AnimationDistance
        
        var offsets: [Float] = [0.0, 0.5, 1.0]
        var values: [AnyObject] = [0.0, Float(M_PI), 0.0]
        var functions: [TweenBlock] = [TweenBlockEaseInQuad, TweenBlockEaseInQuad]
        
        rotation.keyOffsets = offsets
        rotation.values = values
        rotation.functions = functions
        animatable.layer.addScrollableAnimation(rotation, forKey: "rotation", withController: animationController)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        animationController.updateAnimatablesForOffset(Float(scrollView.contentOffset.y), nil)
    }
}

extension ViewController: ScrollableAnimationDelegate {
    func scrollableAnimationDidStart(anim: ScrollableAnimation!) {
        
    }
    
    func scrollableAnimationDidStop(anim: ScrollableAnimation!) {
        
    }
}
