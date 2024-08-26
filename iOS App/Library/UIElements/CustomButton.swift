import UIKit

final class CustomButton: UIButton {    
    
    init(title: String? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = isEnabled ? .systemBlue : .systemGray4
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.isEnabled {
            UIView.animate(withDuration: 0.1) {
                self.transform = .init(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.isEnabled {
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
}
