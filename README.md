# Ariel

## The Protocol : Ariel

+ Requirements: 
  + `var views: [String: Any]`
  + `var metrics: [String: Any]`
+ Protocol Extension methods
  + `H(String) { // adjust layout priority here }`
  + `V(String) { // adjust layout priority here }`
  + `J(NSLayoutConstraint, UILayoutPriority=.required)`
  + `G([NSLayoutConstraint])`
+ Superclass
  + `ArielViewController`
  + `ArielView`

## Essence Visual Format

Here's an example:

```swift
class ViewController : ArielViewController {
    let buttonSignIn = UIButton()
    let buttonRegister = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		view.addSubview(buttonSignIn)
        view.addSubview(buttonRegister)
        
        // setTitle, setTitleColor...
        
        H("|-30-[buttonSignIn]-30-|")
        H("|-20-[buttonRegister]-20-|")
        V("|-80-[buttonSignIn]-20-[buttonRegister]")
    }
}
```



With Apple's Auto Layout, the code would look like this:

```swift
// In viewDidLoad
buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
buttonRegister.translatesAutoresizingMaskIntoConstraints = false

let views: [String: Any] = 
	["buttonSignIn": buttonSignIn, "buttonRegister": buttonRegister]

NSLayoutConstraint.activate(
    NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[buttonSignIn]-30-|", metrics: nil, views: views))
NSLayoutConstraint.activate(
    NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[buttonRegister]-20-|", metrics: nil, views: views))
NSLayoutConstraint.activate(
    NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[buttonSignIn]-20-[buttonRegister]", metrics: nil, views: views))
```



## Introduce LayoutPriority Operator

```swift
precedencegroup LayoutPriorityGroup {
    associativity: left
}

infix operator |> : LayoutPriorityGroup

@discardableResult
public func |>(lhs: UIView, rhs: UIView) -> UIView{
    lhs.setContentHuggingPriority(UILayoutPriority(rawValue: rhs.contentHuggingPriority(for: .horizontal).rawValue-1), for: .horizontal)
    return rhs
}

infix operator <| : LayoutPriorityGroup

@discardableResult
public func <|(lhs: UIView, rhs: UIView) -> UIView {
    lhs.setContentHuggingPriority(UILayoutPriority(rawValue: rhs.contentHuggingPriority(for: .horizontal).rawValue+1), for: .horizontal)
    return rhs
}
```

Example,

```swift
H("|-20-[labelName]-20-[fieldName]-10-[btnCheck]-20-|") 
{ labelName <| fieldName |> btnCheck } // line 2
```

![Result](/Users/tung/Desktop/Ariel/Resources/example1.png)

## Layout Methods on UIView

