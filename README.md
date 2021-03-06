# SFBottomSheet

[![Version][version]](http://cocoapods.org/pods/SFBottomSheet/)
![Platform][platform]
![License](https://img.shields.io/cocoapods/l/TDBadgedCell.svg?style=flat-square)
<!-- [![Build Status][travis-image]][travis-url]
 -->

**SFBottomSheet** is an implementation of custom modal presentation style for thumb-friendly interactive views anchored to the bottom of the screen


## How to Install

```sh
pod 'SFBottomSheet'
```
```sh
import SFBottomSheet
```


## For developers

Each SFBottomSheet accepts a child view controller that must conform to ``SFBottomSheetChildControllerProtocol``. Through this protocol each child view controller describes how to be represented.

```swift
public protocol SFBottomSheetChildControllerProtocol where Self: UIViewController {
    
    var bottomSheetAppearance: BottomSheetChildAppearance { get set }
    var didRequestCloseAction: (() -> Void)? { get set }
    
}
```

SFBottomSheet also accepts a custom configuration that must conform to ``SFBottomSheetConfigurable``

```swift
public protocol SFBottomSheetConfigurable {
    
    var backgroundColor: UIColor { get }
    
    // MARK: Container
    
    var containerLeadingDefaultConstraint: CGFloat { get }
    var containerTrailingDefaulConstraint: CGFloat { get }
    var containerViewCornerRadius: CGFloat { get }
    
    // MARK: Draggable
    
    var draggableContainerHeightConstraint: CGFloat { get }
    var draggableContainerBottomConstraint: CGFloat { get }
    var draggableHeightConstraint : CGFloat { get }
    var draggableWidthConstraint: CGFloat { get }
    var draggableBackgroundColor: UIColor { get }
    var draggableAlpha: CGFloat { get }
    var draggableCornerRadius: CGFloat { get }
    var draggableMaskedCorners: CACornerMask { get }
    
}
```
**Attention**: If is not provided, the default one will be used.

```swift
public struct SFBottomSheetConfigurator: SFBottomSheetConfigurable {
    
    // MARK: Content
    
    public var backgroundColor: UIColor = UIColor(red: 0,
                                                             green: 0,
                                                             blue: 0,
                                                             alpha: 0.4)
    public var containerLeadingDefaultConstraint: CGFloat = 16
    public var containerTrailingDefaulConstraint: CGFloat = 16
    
    // MARK: Container
    
    public var containerViewCornerRadius: CGFloat = 16
        
    // MARK: Draggable
    
    public var draggableContainerHeightConstraint: CGFloat = 30
    public var draggableContainerBottomConstraint: CGFloat = 0
    public var draggableHeightConstraint: CGFloat = 5
    public var draggableWidthConstraint: CGFloat = 40
    public var draggableBackgroundColor: UIColor = .white
    public var draggableAlpha: CGFloat = 1
    public var draggableCornerRadius: CGFloat = 2
    public var draggableMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    
}
```


## How to Use

* With default configuration: 
```swift
let childViewController: SFBottomSheetChildControllerProtocol = SFBottomSheetChildViewController()
guard let bottomSheetViewController = SFBottomSheetViewController.createScene(child: childViewController,
                                                                        didFinishWithoutSelection: nil) else { return }
bottomSheetViewController.modalPresentationStyle = .overFullScreen
bottomSheetViewController.modalTransitionStyle = .crossDissolve
present(bottomSheetViewController, animated: true)
```

* With custom configuration:
```swift
let childViewController: SFBottomSheetChildControllerProtocol = SFBottomSheetChildViewController()
var let configuration: SFBottomSheetConfigurable = CustomConfiguration()
configuration.draggableAlpha = 0.7
configuration.contentViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
guard let bottomSheetViewController = SFBottomSheetViewController.createScene(child: childViewController,
                                                                        configuration: configuration,
                                                                        didFinishWithoutSelection: nil) else { return }
bottomSheetViewController.modalPresentationStyle = .overFullScreen
bottomSheetViewController.modalTransitionStyle = .crossDissolve
present(bottomSheetViewController, animated: true)
```

_For more examples and usage, please refer to the [Wiki][wiki]._


## Extra Informations

* If you have any trouble open a **[Issue](https://github.com/scalefocus/SFBottomSheet/issues)**
* If you want to contribute to the project, make a **[Pull Request](https://github.com/scalefocus/SFBottomSheet/pulls)** and explain what your change does.
## Release History

* 0.0.1
    * Initial setup
* 0.0.2
    * Updated .podspec source_files
* 0.0.3
    * Updated SFBottomSheetViewController createScene func protection level
* 0.0.4
    * Updated .podspec resource_bundles and fix SFBottomSheetViewController instantiation
* 0.0.6
    * Updated .podspec and provide SFBottomSheetConfigurable public init 
* 0.0.7
    * Fixing child trailing constraint by updating SFBottomSheetChildControllerProtocol
* 0.0.8
    * Updated the calculation of a content size
* 0.0.9
    * Updated .podspec
* 0.0.10
    * Updated .podspec

## Meta

Aleksandar Gyuzelov – [@ScaleFocus](https://github.com/scalefocus) – aleksandar.gyuzelov@scalefocus.com

Distributed under the MIT license. See ``LICENSE`` for more information.


## Contributing

1. Fork it (<https://github.com/scalefocus/SFBottomSheet/fork>)
2. Create your feature branch (`git checkout -b feature/branch-name`)
3. Commit your changes (`git commit -am 'Descriptive commit message'`)
4. Push to the branch (`git push origin feature/branch-name`)
5. Create a new Pull Request


## Contributors

* [Aleksandar Gyuzelov](aleksandar.gyuzelov@scalefocus.com)
* [Ivan Georgiev](ivan.georgiev@scalefocus.com)
* [Dimitar Petrov](dimitar.petrov@scalefocus.com)

<!-- Markdown link & img dfn's -->
[version]: https://img.shields.io/cocoapods/v/SFBottomSheet
[platform]: https://img.shields.io/cocoapods/p/SFBottomSheet?color=red
[license]: https://img.shields.io/cocoapods/l/SFBottomSheet?color=blue
[wiki]: https://github.com/scalefocus/SFBottomSheet/wiki