import UIKit

public protocol ReusableView: AnyObject {

    static var reuseIdentifier: String { get }
}

public extension ReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol ReusableViewNibLoading: ReusableView {

    static var nib: UINib { get }
}

public extension ReusableViewNibLoading {

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
