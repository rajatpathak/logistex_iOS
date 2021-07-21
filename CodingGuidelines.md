# kaya-health-ios-1378

```
/**
*
*@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
*@author     : Shiv Charan Panjeta < shiv@toxsl.com >
*
* All Rights Reserved.
* Proprietary and confidential :  All information contained herein is, and remains
* the property of ToXSL Technologies Pvt. Ltd. and its partners.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/
```
Project Names
```
• Project Names Must be Capitalized Strings 
    Preffered: 
        DemoProject
    NotPreffered : 
        Demo Project or demo_project or DEMO PROJECT

```
Naming Guidelines :

```

• Names must be descriptive. Avoid abbreviations and acronyms. You should be able to read the code out loud, over the phone.
• If an abbreviation or acronym is used, it must be in the form of an accepted name that is generally well-known.
• Class and Protocol names must be descriptive.
    eg: HomeVC , CommentsVC , HomeVM, HomeModel, HomeTVC, PopToBackProtocol
    
    /* 
    * @Class -> HomeVC is Home View Controller
    * @class -> HomeVM is Home Class ViewModel
    * @class -> HomeModel is Class Model
    * @class -> HomeTVC is Home Class TableViewCell
    * Protocol ->PopToBackProtocol is Home Class Protocol to perform some Functionality
    */
    
• For setter methods, lead with the word set. Getter methods are the item being returned, with no prefix. For all other methods lead with a verb, not a noun or adjective.
    Button Actions Must be defined like the below
    eg: setProfileSuccess(_:), actionTappedPhoto(_:)

• Begin names of factory methods with “make”, 
    e.g. x.makeIterator().

    /**
    * @obj      -> x is a Class Object
    * @method   ->  makeIterator() is Class Method
    */

• Begin names Objects and Outlets

    Preffered:
       let objHomeVM = HomeVM()
       @IBOutlet weak var lblSubTotal: UILabel!
       @IBOutlet weak var vwDeliveryCharges: UIView!
       @IBOutlet weak var btnMenu: UIButton!
       @IBOutlet weak var txtFldPassword: UITextField!
       
    NotPreffered:
       @IBOutlet weak var txtPassword: UITextField!
       @IBOutlet weak var buttonMenu: UIButton!
       @IBOutlet weak var subTotalLabel: UILabel!
       
       /**
       * @class    - HomeVM is a Class Name
       * @obj      - objHomeVM is HomeVM Class Object
       */
```
Code Styling: 
```
• Use Xcode's automatic indention.
• Break lines only after a punctuator: [ , . ; : { } ( [ = < > ? ! + - * / % ~ ^ | & == != <= >= += -= *= /= %= ^= |= &= << >> || &&]

• For complex conditionals in if statements, linebreaks should be immediately before || and/or &&, so that new lines of the conditional start with the || or &&. This makes it obvious that the new line must be a continuation of the previous line and not a separate statement. Insert parentheses around conditional parts as necessary to satisfy the break-only-after-a-punctuator requirement and make order of operations obvious.

• Put one space between arithmetic and assignment operators and other symbols:

    Preffered:  let total = count + 2
    
    Not Preffered: let total =count+2

• For array and dictionary literals, unless the literal is very short, it should be split into multiple lines, with the opening symbols on their own line, each item or key-value pair on its own line, and the closing symbol on its own line. The last item or key-value pair should have a trailing comma to facilitate future insertion/editing. Xcode will handle alignment sanely.


    Preffered: let objectArr = [
                            object1,
                            object2,
                            object3
                            ]
                            
    Less Preffered: let objectArr = [
                            object1, object2, object3 
                            ]                        
```

Parameters:

```
• func move(from start: Int, to end: Int)
/**
* @var      -> from and to are the varibales which defines the value to pass 
* @param    -> start and end are parameter
*/

• Argument Labels eg: performMove(from: x, to: y)

/**
*
* @values -> x and y are some integer type values which are provided 
* @function -> performMove is the name of function
*/

```
Class Prefixes : 

```
• Swift types are automatically namespaced by the module that contains them and you should not add a class prefix such as RW. If two names from different modules collide you can disambiguate by prefixing the type name with the module name. However, only specify the module name when there is possibility for confusion which should be rare.

    eg: import SomeModuleFrameWork
    
    let objSomeModule  = SomeModule()
        let myResult = objSomeModule.UsefulClass()

    /**
    * @obj -> objSomeModule is Class Object
    * @class -> SomeModule() is Class name 
    * @framework -> SomeModuleFrameWork is Reference Framework
    * @Variable  -> myResult is my Vaiable in which i am saving the Result
    */

```

Variables :

```
• Write variable names in camelCase, with the first word in lower case:
   
   Preffered: let numberOfThings = 0 or var noOfThings = 0
   Not Preffered :  let NumberOfThings = 0, let NumberofThings = 0, let  NUMBEROFTHINGS = 0
   
• File-level static variables (not local ones) are the only exception. Start them with a capital letter
    eg: static let KGetValue = "Value"
    
• Form names from the 26 upper and lower case English letters (A...Z, a...z) and the 10 digits (0...9). Avoid use of international characters because they may not read well or be understood everywhere. Do not use emoji.

• If you have to use a non-descriptive variable name, keep a very limited scope and provide comments that explain what that specific block of code is doing. Especially avoid generic variable names like 'tmp', 'data', 'obj', 'res', etc.

```
AppDelegate Usage:

```
• Do not use the AppDelegate class for anything except AppDelegate-related activities (launching the app, closing the app, and responding to UIApplicationDelegate messages). Utility methods and global variables do not belong in the AppDelegate. Put utility methods in their own classes or categories/extensions. If necessary, global variables/constants can be exported/exposed from a specific class or singleton or other context—anything but in the AppDelegate.

```
Delegates

```
• When creating custom delegate methods, an unnamed first parameter should be the delegate source. (UIKit contains numerous examples of this.)

    eg: func namePickerView(_ namePickerView: UIPickerView, didSelectName name: String)
    eg: func namePickerViewShouldReload(_ namePickerView: UIPickerView) -> Bool
    
    /**
    * @method - namePickerView and namePickerViewShouldReload are my method names
    * @params - namePickerView, name is Parameter
    * @reference - didSelectName is Reference Variable
    */
    

```
Optionals: 

```

• Declare variables and function return types as optional with ? where a nil value is acceptable.

    eg: textContainer?.textLabel?.setNeedsDisplay()

• Use optional binding when it's more convenient to unwrap once and perform multiple operations:

    if let textContainer = textContainer {
        // do many things with textContainer
    }

```
Use Type Inferred Context
```
Preferred:

    let selector = #selector(viewDidLoad)
    view.backgroundColor = .red
    let toView = context.view(forKey: .to)
    let view = UIView(frame: .zero)
    
Not Preferred:

    let selector = #selector(ViewController.viewDidLoad)
    view.backgroundColor = UIColor.red
    let toView = context.view(forKey: UITransitionContextViewKey.to)
    let view = UIView(frame: CGRect.zero)

```

Protocol Conformance: 

```
• In particular, when adding protocol conformance to a model, prefer adding a separate extension for the protocol methods. This keeps the related methods grouped together with the protocol and can simplify instructions to add a protocol to a class with its associated methods.
    
    Preferred:
    
        class MyViewController: UIViewController {
        // class stuff here
        }
    
        // MARK: - UITableViewDataSource
        extension MyViewController: UITableViewDataSource {
        // table view data source methods
        }
    
        // MARK: - UIScrollViewDelegate
        extension MyViewController: UIScrollViewDelegate {
        // scroll view delegate methods
        }
    
    Not Preferred:
    
        class MyViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
        // all methods
        }

• Since the compiler does not allow you to re-declare protocol conformance in a derived class, it is not always required to replicate the extension groups of the base class. This is especially true if the derived class is a terminal class and a small number of methods are being overridden. When to preserve the extension groups is left to the discretion of the author.

For UIKit view controllers, consider grouping lifecycle, custom accessors, and IBAction in separate class extensions.


```
Unused Code

```
• Unused (dead) code, including Xcode template code and placeholder comments should be removed. An exception is when your tutorial or book instructs the user to use the commented code.

• Aspirational methods not directly associated with the tutorial whose implementation simply calls the superclass should also be removed. This includes any empty/unused UIApplicationDelegate methods.

    Preffered: 
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Database.contacts.count
        }
    
    Not Preferred:
    
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->     Int {
        // #warning Incomplete implementation, return the number of rows
            return Database.contacts.count
        }

```
Minimal Imports : 

```
• Import only the modules a source file requires. For example, don't import UIKit when importing Foundation will suffice. Likewise, don't import Foundation if you must import UIKit.

    Not Preffered: 
        import UIKit
        import Foundation
        var view: UIView
        var deviceModels: [String]
    
    Preffered
        import Foundation
        var deviceModels: [String]

```
Spacing

```
• Method braces and other braces (if/else/switch/while etc.) always open on the same line as the statement but close on a new line.
• Tip: You can re-indent by selecting some code (or Command-A to select all) and then Control-I (or Editor ▸ Structure ▸ Re-Indent in the menu). 

Preferred:
    if user.isHappy {
        // Do something
    } else {
        // Do something else
    }
Not Preferred:

    if user.isHappy
    {
        // Do something
    }
    else {
        // Do something else
    }

• There should be exactly one blank line between methods to aid in visual clarity and organization. Whitespace within methods should separate functionality, but having too many sections in a method often means you should refactor into several methods.

```
Use of Self: 

```
• For conciseness, avoid using self since Swift does not require it to access an object's properties or invoke its methods.
• Use self only when required by the compiler (in @escaping closures, or in initializers to disambiguate properties from arguments). In other words, if it compiles without self then omit it.

```
Computed Properties

```

• For conciseness, if a computed property is read-only, omit the get clause. The get clause is required only when a set clause is provided.

Preferred:
    var diameter: Double {
        return radius * 2
    }
Not Preferred:
    var diameter: Double {
        get {
            return radius * 2
        }
    }

```
Types : 

```
• Always use Swift's native types and expressions when available. Swift offers bridging to Objective-C so you can still use the full set of methods as needed.

Preferred:

    let width = 120.0                                    // Double
    let widthString = "\(width)"                         // String

Less Preferred:
    let width = 120.0                                    // Double
    let widthString = (width as NSNumber).stringValue    // String

Not Preferred:
    let width: NSNumber = 120.0                          // NSNumber
    let widthString: NSString = width.stringValue        // NSString
```
Internationalization: 

```
• Always use NSLocalizedString for user-facing strings. Even if your project is never localized, the advantages of NSLocalizedString outweigh the few extra keystrokes required.

```
Documentation : 

```
• Provide documentation of public methods, properties, classes, structs, enums, functions, types, and constants.

    /**
    *  A concise description of the functionality.
    *
    *  @param title     Describe what value should be passed in.
    *  @param message   Left-align param documentation.
    *  @param number    If there is a default value, explain.
    *
    *  @return Describe the return value of the method. 
    */

    eg: func exampleMethodWithTitle (title: String, message: String, number: String) -> UILabel {}

```
Code Organization: 

```
• Group IBAction methods together under // MARK: - IBActions
• Use // MARK: - [section] to mark the beginning of each logical group throughout the code. Doing this will make searching through the code for a specific method much simpler.
• Keep initialization logic at the top of the method when possible.
• Use vertical spacing to group similar logic in a method.

```
Code Signing and Provisioning Profile Selection :

```
• In each target's Build Settings, the Code Signing Identities should always be generic, such as "iPhone Developer" and "Automatic". This allows the build server to select the right cert and key keychain at build time.

```
Scripts: 

```
• Run script phases should be renamed to more specifically describe what the phase does. For any run script phase script beyond a couple lines, it is preferable to have the body of the run script phase call out to an external file, as it's easier to edit an external file and the diffs are easier to handle (Xcode mashes the whole body of a run script phase onto a single line in the project file).

```
App Transport Security :

```
• In iOS 9, Apple introduced App Transport Security to encourage secure networking. In practice, this means that HTTP (as opposed to HTTPS) requests are blocked unless the app requests an exception to allow them. 

```
Special Instructions: 

```
• Label tuple members and name closure parameters where they appear in your API.
    
    eg: func getDataUsingParameters (dictionary: NSDictionary) -> (isSuccess: Bool, isValuable: Bool)
    
```
Memory Management

```
• Code (even non-production, tutorial demo code) should not create reference cycles. Analyze your object graph and prevent strong cycles with weak and unowned references. Alternatively, use value types (struct, enum) to prevent cycles altogether.

```

Access Control

```
• Full access control annotation in tutorials can distract from the main topic and is not required. Using private and fileprivate appropriately, however, adds clarity and promotes encapsulation. Prefer private to fileprivate; use fileprivate only when the compiler insists.

• Use access control as the leading property specifier. The only things that should come before access control are the static specifier or attributes such as @IBAction, @IBOutlet and @discardableResult.

```
Control Flow

```
• Prefer the for-in style of for loop over the while-condition-increment style.

    for _ in 0..<3 {
        print("Hello three times")
    }
    
    for index in (0...3).arrReversed {
        print(index)
    }
```
Ternary Operator

```
• The Ternary operator, ?: , should only be used when it increases clarity or code neatness. A single condition is usually all that should be evaluated. Evaluating multiple conditions is usually more understandable as an if statement or refactored into instance variables. In general, the best use of the ternary operator is during assignment of a variable and deciding which value to use.

    let value = 5
    result = value != 0 ? x : y
    
    let isHorizontal = true
    result = isHorizontal ? x : y

```
Date Validation

```
• Need to add expiry date validation check on both sides backend and  app. Every build will be valid for next 21 days . After 21 days, build should be stop to run with showing alert. Whenever app goes to the app store then remove expiry date validation.

