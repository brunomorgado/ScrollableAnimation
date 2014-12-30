//
//  TweenBlock.swift
//  ScrollableMovie
//
//  Created by Bruno Morgado on 19/12/14.
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

/**
* Ease methods ported from: http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
*/

typealias TweenBlock = (Double -> Double)

let TweenBlockNone: TweenBlock = { offset in
    return offset
}

let TweenBlockEaseInQuad: TweenBlock = { offset in
    return offset * offset
}

let TweenBlockEaseOutQuad: TweenBlock = { offset in
    return -offset * (offset - 2);
}

let TweenBlockEaseInOutQuad: TweenBlock = { offset in
    var varOffset = offset / 0.5
    if (varOffset < 1) {
        return 1.0 / 2 * varOffset * varOffset;
    }
    
    varOffset--;
    return -1.0 / 2 * (varOffset*(varOffset-2) - 1);
}

let TweenBlockEaseOutQuint: TweenBlock = { offset in
    var varOffset = offset - 1
    return varOffset*varOffset*varOffset*varOffset*varOffset + 1;
}

let TweenBlockEaseInExpo: TweenBlock = { offset in
    return (offset == 0) ? 0.0 : pow(2, 10 * (offset - 1));
}

let TweenBlockEaseOutExpo: TweenBlock = { offset in
    return offset == 1 ? 1 : pow(2, -10 * offset) + 1;
}

let TweenBlockEaseInOutExpo: TweenBlock = { offset in
    if( offset == 0 ) {
        return 0;
    }
    if( offset == 1 ) {
        return 1;
    }
    
    var varOffset = offset * 2
    if( varOffset < 1 ) {
        return 0.5 * pow( 2, 10 * (varOffset - 1) );
    }
    return 0.5 * ( -pow( 2, -10 * (varOffset - 1)) + 2);
}

let TweenBlockEaseOutElastic: TweenBlock = { offset in
    var s=1.70158;
    var p=0.3;
    
    if (offset == 0){
        return 0;
    }
    
    var varOffset = offset / 1.0
    if (varOffset == 1) {
        return 1.0;
    }
    
    s = p / (2 * M_PI) * asin(1.0);
    
    var value = pow(2, -10 * varOffset) * sin((varOffset * 1.0 - s) * (2 * M_PI) / p) + 1.0;
    
    return value;
}

let TweenBlockEaseOutBounce: TweenBlock = { offset in
    var varOffset = offset
    if (varOffset < (1 / 2.75)) {
        return (7.5625 * varOffset * varOffset);
    } else if (varOffset < (2/2.75)) {
        varOffset -= (1.5/2.75);
        return (7.5625 * varOffset * varOffset + 0.75);
    } else if (varOffset < (2.5/2.75)) {
        varOffset -= (2.25/2.75);
        return (7.5625 * offset * offset + 0.9375);
    } else {
        varOffset -= (2.625/2.75);
        return (7.5625 * varOffset * varOffset + 0.984375);
    }
}

// TODO:
//    let tweenBlockFromBezierCurve(var t: Double) -> Double {
//        if (t < (1 / 2.75)) {
//            return (7.5625 * t * t);
//        } else if (t < (2/2.75)) {
//            t -= (1.5/2.75);
//            return (7.5625 * t * t + 0.75);
//        } else if (t < (2.5/2.75)) {
//            t -= (2.25/2.75);
//            return (7.5625 * t * t + 0.9375);
//        } else {
//            t -= (2.625/2.75);
//            return (7.5625 * t * t + 0.984375);
//        }
//    }

