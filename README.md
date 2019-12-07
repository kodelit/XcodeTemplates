To learn more about Clean Swift and the VIP cycle, read:

http://clean-swift.com/clean-swift-ios-architecture

There is a sample app available at:

https://github.com/Clean-Swift/CleanStore

Licence: [MIT](LICENSE)

---
# Clean Swift Template

This template derives from implementation by Raymond Law from page [clean-swift.com](http://clean-swift.com), but is slightly modified/customised.

To install the Clean Swift Xcode templates, run: `install`

## Generating template

Template is generated from `Source`. The directory contains:

- *Assembler.xctemplate* - **not included in original Clean Swift Xcode Templates**
- *Presenter.xctemplate*
- *Interactor.xctemplate*
- *Worker.xctemplate*
- *Router.xctemplate*
- *Models.xctemplate*
- *ViewController.xctemplate*

	and

- *`SOURCE_FILE_TOP_COMMENT.swift`*



`install` script generates templates from the `Source` and puts them in the `Output` directory

### View Controller.xctemplate

`Source` contains only one view controller source file `Source/View Controller.xctemplate/UIViewController/___FILEBASENAME___ViewController.swift`.

But there are 3 template classes generated in `Output/View Controller.xctemplate` based on the file:

- UIViewController
- UITableViewController
- UICollectionViewController

### Scene.xctemplate

*Scene.xctemplate* is generated automatically and composed with templates:

- *ViewController.xctemplate*
- *Assembler.xctemplate* - **not included in original Clean Swift Xcode Templates**
- *Presenter.xctemplate*
- *Interactor.xctemplate*
- *Worker.xctemplate*
- *Router.xctemplate*
- *Models.xctemplate*

	so you can modify only templates above, the __*Scene*__ template `.swift` source files are going to be updated automatically during installation with the *install* script (and **every change** on them **will be overridden**)

### `SOURCE_FILE_TOP_COMMENT.swift`

Contains common header (comment) for every Swfit source file.