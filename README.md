ScrollableAnimation [![](http://img.shields.io/badge/iOS-8.0%2B-lightgrey.svg)]()
=====

Swift library for creating keyPath animations based on an offset instead of time.

ScrollableAnimation was built to mimic the normal way of animating layers with a property-based CAAnimation defined by a keyPath with the main difference being that the X axis of the animation timeline is an 'offset' instead of 'time'.

### Setup

Just copy ScrollableAnimation folder to your iOS 8 project;

### Usage

Create an animation controller for a particular context.

```swift
let animationController = ScrollableAnimationController()
```

Create an animation and add it to the layer you want to animate, passing along the animation controller.

```swift
let animatable = UIView(frame: CGRectMake(0, 0, 100, 100))
animatableSuperView.addSubview(animatable)
```

```swift
let rotation = ScrollableKeyframeAnimation(keyPath: "transform.rotation.z")
rotation.beginOffset = 0
rotation.distance = 600
rotation.keyOffsets = [0.0, 0.5, 1.0]
rotation.values = [0.0, Float(M_PI), 0.0]
rotation.functions = [TweenBlockEaseInQuad, TweenBlockEaseInQuad]
animatable.layer.addScrollableAnimation(rotation, forKey: "rotationAnimation", withController: animationController)
```
Note that instead of 'beginTime' the ScrollableAnimation has a 'beginOffset' and instead of 'duration' it has 'distance'. In this example these values refer to the contentSize of a control scrollView.

You can use any keyPath as you would in a CAPropertyAnimation and you can add multiple animations to one layer.

Finally feed the animation controller with the offset values. You can get these values from a UIScrollView, UISlider, or any other custom control.

```swift
func scrollViewDidScroll(scrollView: UIScrollView) {
     animationController.updateAnimatablesForOffset(Float(scrollView.contentOffset.y))
}
```

### Improvements

- Implement 'additive' functionality for ScrollableAnimation.

- Implement ScrollableAnimationDelegate.

- Optimize contents-based animations with texture atlases.

### License

The MIT License (MIT)

Copyright (c) 2014 Bruno Morgado

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

