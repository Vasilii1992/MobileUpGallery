
import Foundation

protocol WebViewControllerDelegate: AnyObject {
    func didReceiveAccessToken(_ token: String)
    func didCancelAuthorization()
}
