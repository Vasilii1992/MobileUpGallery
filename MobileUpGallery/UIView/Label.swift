
import UIKit

final class Label: UILabel {
    
    var labelText: String
    var fontSize: CGFloat
    var weight: UIFont.Weight
    var color: UIColor
    var alignment: NSTextAlignment

    init(labelText: String = "",
         fontSize: CGFloat,
         weight: UIFont.Weight,
         color: UIColor = .black,
         alignment: NSTextAlignment = .left) {
        
        self.labelText = labelText
        self.fontSize = fontSize
        self.weight = weight
        self.color = color
        self.alignment = alignment
        
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.text = labelText
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
        self.numberOfLines = 2
        self.textAlignment = alignment
    }
}
