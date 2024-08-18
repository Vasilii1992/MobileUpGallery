
import UIKit

final class AuthorizationButton {
    
    static func createAuthorizationButton(title: String) -> UIButton {

           let button = UIButton(type: .system)
           button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           button.setTitle(title, for: .normal)
           button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
           button.layer.cornerRadius = 15
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
    }
}

