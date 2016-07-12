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
    
    mutating func clear() {
        stack.removeAll()
    }
    
}

class ViewController: UIViewController {
    
    var calcStack = Stack<Int>()
    
    var opStack = Stack<UIButton>()
    
    var runningTotal: Int!

    var numButs = [UIButton]()
    
    var opButs = [UIButton]()
    
    var numArray = [Int]()
    
    var isOperator: Bool!
    
    var timeToClear: Int!
    
    var timeToOperate: Bool!
    
    var justOperated: Bool!
    
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
    @IBOutlet weak var clearBut: UIButton!
    
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
        timeToClear = 0
        isOperator = false
        justOperated = false
        timeToOperate = false
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
    
    func operate( ) -> Int {

        let whichOp = opStack.pop()
        var result: Int = 0
        if whichOp == plusBut {
            result = calcStack.pop() + calcStack.pop()
        } else if whichOp == subBut {
            let subSecond = calcStack.pop()
            result = calcStack.pop() - subSecond
        } else if whichOp == multBut {
            result = calcStack.pop() * calcStack.pop()
        } else if whichOp == divBut {
            let divSecond = calcStack.pop()
            if divSecond == 0 {
                result = 0
            } else {
            result = calcStack.pop() / divSecond
            }
        }
        return result
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
        if timeToClear == 1 {
            calcLabel.text = ""
        }
    }
    
    
    func ableOps( enable: Bool ) {
        eqBut.enabled = enable
        plusBut.enabled = enable
        subBut.enabled = enable
        divBut.enabled = enable
        multBut.enabled = enable
    }
    func clear () {
        calcStack.clear()
        opStack.clear()
        timeToClear = 1
        clearText()
        justOperated = false
    }
    @IBAction func clearButtonPressed(sender: AnyObject) {
        clear()
    }
    @IBAction func buttonPressed( whichButton: UIButton) {
        timeToClear = timeToClear + 1
        clearText()
        print( calcStack )
        if isNumBut( whichButton ) {
            if !calcStack.isEmpty() {
                if justOperated == true {
                    /*calcStack.clear()
                    opStack.clear()
                    clearText()*/
                    clear()
                calcStack.push( numArray[ numButs.indexOf( whichButton )! ] )
                    calcLabel.text = String( calcStack.peek() )
                    //timeToOperate = false
                    //justOperated = false
                }
                else if !isOperator {
                    let addToString = String( numArray[ numButs.indexOf( whichButton )! ] )
                    calcLabel.text = calcLabel.text! + addToString
                    calcStack.push( Int( String( calcStack.pop() ) + addToString )! )
                    //calcLabel.text = calcLabel.text! + String( calcStack.peek() )
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
            ableOps( true )
        }
        else {
            if !calcStack.isEmpty() {
                if whichButton == eqBut {
                    calcStack.push( operate() )
                    calcLabel.text = String( calcStack.peek() )
                    justOperated = true
                    timeToOperate = false
                }
                else if timeToOperate == true {
                    calcStack.push( operate() )
                    opStack.push( whichButton )
                    calcLabel.text = String( calcStack.peek() ) + opToString( opStack.peek() )
                    ableOps( false )
                    isOperator = true
                } else {
                    justOperated = false
                    timeToOperate = true
                    isOperator = true
                    opStack.push( whichButton )
                    let nextOp = opToString( opStack.peek () )
                    calcLabel.text = calcLabel.text! + nextOp
                    ableOps( false )
                }
               
            }
        }
    }
}

