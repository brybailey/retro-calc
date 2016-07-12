//
//  ViewController.swift
//  retro-calculator
//
//  Created by Bryan C. Bailey on 7/10/16.
//  Copyright © 2016 Bryan C. Bailey. All rights reserved.
//

import UIKit

struct Stack<Element>{
    
    var stack = [Element]()
    
    mutating func push( elem: Element ) {
        stack.append( elem )
    }
    
    mutating func pop() -> Element {
        return stack.removeLast()
    }
    
    mutating func peek() -> Element {
        return stack[stack.count - 1]
    }
    
    mutating func isEmpty() -> Bool {
        return stack.isEmpty
    }
    
}

class ViewController: UIViewController {
    
    var calcStack = Stack<Int>()
    
    var opStack = Stack<UIButton>()
    
    var runningTotal: Int!

    var numButs = [UIButton]()
    
    var opButs = [UIButton]()
    
    var numArray = [Int]()

    var timesPressed: Int!
    
    var isOperator: Bool!
    
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var plusBut: UIButton!
    @IBOutlet weak var subBut: UIButton!
    @IBOutlet weak var multBut: UIButton!
    @IBOutlet weak var divBut: UIButton!
    @IBOutlet weak var eqBut: UIButton!
    
    @IBOutlet weak var calcLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize number array
        numButs.append(zero)
        numButs.append(one); numButs.append(two); numButs.append(three)
        numButs.append(four); numButs.append(five); numButs.append(six)
        numButs.append(seven); numButs.append(eight); numButs.append(nine)
        
        
        //Initalize operations array
        opButs.append(plusBut); opButs.append(subBut); opButs.append(multBut)
        opButs.append(divBut); opButs.append(eqBut)
        
        //Number array 0-9
        for x in 0...9 {
            numArray.append(x)
        }
        
        calcLabel.text = "Press a button!"
        timesPressed = 0
        isOperator = false
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func isNumBut( which: UIButton ) -> Bool {
        if numButs.contains( which ) {
            return true
        }
        else{ return false }
        
    }
    
    func opToString( whichOp: UIButton ) -> String {
        if whichOp == plusBut {
            return "+"
        } else if whichOp == subBut {
            return "-"
        } else if whichOp == multBut {
            return "*"
        } else if whichOp == divBut {
            return "/"
        } else if whichOp == eqBut {
            return "="
        }
        else {
            return ""
        }
    }
    
    func clearText() {
        if timesPressed == 1 {
            calcLabel.text = ""
        }
    }
    @IBAction func buttonPressed( whichButton: UIButton) {
        timesPressed = timesPressed + 1
        clearText()
        if isNumBut( whichButton ) {
            if !calcStack.isEmpty() {
                if !isOperator {
                    let addToString = String( numArray[ numButs.indexOf( whichButton )! ] )
                    calcLabel.text = calcLabel.text! + addToString
                    calcStack.push( Int( String( calcStack.pop() ) + addToString )! )
                } else {
                    isOperator = false
                    calcStack.push( numArray[ numButs.indexOf( whichButton )! ] )
                    calcLabel.text = calcLabel.text! + String( calcStack.peek() )
                }
            }
            else {
                calcStack.push( numArray[ numButs.indexOf( whichButton )! ] )
                calcLabel.text = String( calcStack.peek() )
            }
        }
        else {
            if !calcStack.isEmpty() {
                isOperator = true
                opStack.push( whichButton )
                calcLabel.text = calcLabel.text! + opToString( whichButton )
            }
        }
    }
}

