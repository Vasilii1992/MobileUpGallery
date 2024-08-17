
import UIKit

final class BarButtonItems {
    
   static func createBackBarButtonItem(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                            style: .plain,
                                            target: target,
                                            action: action)
        barButtonItem.tintColor = .black
        return barButtonItem
    }

    static func createActionBarButtonItem(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                            target: target,
                                            action: action)
        barButtonItem.tintColor = .black
        return barButtonItem
    }
}
