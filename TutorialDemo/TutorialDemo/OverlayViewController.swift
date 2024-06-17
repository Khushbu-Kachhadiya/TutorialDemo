//
//  OverlayViewController.swift
//  TutorialDemo
//
//  Created by Developer1 on 27/03/24.
//

import UIKit

class OverlayViewController: UIViewController {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    var focusView = FocusView()
    
//    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        focusView = FocusView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        focusView.opacity = 0.7
        self.view.addSubview(focusView)
        
//        view.backgroundColor = .darkGray
        
        // let's add six different color rectangles as the "background"
//        let colors: [UIColor] = [
//            .systemRed, .systemGreen, .systemBlue,
//            .systemBrown, .systemYellow, .systemCyan,
//        ]
//        let vStack = UIStackView()
//        vStack.axis = .vertical
//        vStack.distribution = .fillEqually
//        var i: Int = 0
//        for _ in 0..<3 {
//            let hStack = UIStackView()
//            hStack.distribution = .fillEqually
//            for _ in 0..<2 {
//                let v = UIView()
//                v.backgroundColor = colors[i % colors.count]
//                hStack.addArrangedSubview(v)
//                i += 1
//            }
//            vStack.addArrangedSubview(hStack)
//        }
//
//        vStack.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(vStack)
//
//        label.font = .systemFont(ofSize: 30.0, weight: .bold)
//        label.textColor = .white
//        label.textAlignment = .center
//        label.text = "Example"
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(label)
//
//        focusView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(focusView)
//
//        // start with it hidden and transparent
//        focusView.isHidden = true
//        focusView.alpha = 0.0
//
//        NSLayoutConstraint.activate([
//
////            vStack.topAnchor.constraint(equalTo: view.topAnchor),
////            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
////
////            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80.0),
//
//            focusView.topAnchor.constraint(equalTo: view.topAnchor),
//            focusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            focusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            focusView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//        ])
        
    }
    //1st way
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !focusView.isActive() {
            let touch = touches.first
            let p = touch!.location(in: self.view)
            let selectedView = view.hitTest(p, with: nil)
            // Create a FocusView
            focusView.focusOnView(theView: selectedView!, focusType: .Circle, focusStyle: .Fade)
        } else {
            focusView.removeFocus()
        }
    }
    
    //2nd way
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        // we may want to make sure the focusView is on top of all other views
////        view.bringSubviewToFront(focusView)
//        focusView.isHidden = false
//        focusView.alpha = 1.0
//
//        // set the focusView's "see-through" oval rect
//        // it can be set with a hard-coded rect, or
//        //  for this example, we'll use the label frame
//        //  expanded by 80-points horizontally, 60-points vertically
//        focusView.ovalRect = lbl.frame.insetBy(dx: -40.0, dy: -30.0)
////        focusView.ovalRect = btn.frame.insetBy(dx: -40.0, dy: -30.0)
//
//
//        if focusView.isHidden {
//            focusView.isHidden = false
//            UIView.animate(withDuration: 0.3, animations: {
//                self.focusView.alpha = 1.0
//            })
//        } else {
////            UIView.animate(withDuration: 0.3, animations: {
////                self.focusView.alpha = 0.0
////            }, completion: { _ in
////                self.focusView.isHidden = true
////            })
//        }
//    }
}


//1st way
public class FocusView: UIView {
    
    public enum FocusType {
        case Square
        case Circle
    }
    
    public enum FocusStyle {
        case Fade
        case Blur
    }
    
    public var type: FocusType = .Circle
    public var style: FocusStyle = .Blur
    private var fillLayer: CAShapeLayer?
    private var active: Bool!
    
    // Translucency Properties
    public var opacity: Float = 0.5
    public var color: UIColor = UIColor.black
    
    // Blur Properties
    public var blurStyle: UIBlurEffect.Style = .dark
    private var blur: UIVisualEffectView?
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        active = false
        self.isUserInteractionEnabled = false
    }
    
    public func focusOnView(theView:UIView,
                            focusType type:FocusType = FocusType.Circle,
                            focusStyle style:FocusStyle = FocusStyle.Fade,
                            focusPadding padding:CGFloat = 0.0) {
        self.type = type
        self.style = style
        let rect = theView.superview!.convert(theView.frame, to: self)
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        var focusPath: UIBezierPath?
        switch type {
        case .Circle:
            let diagonal = sqrt(pow(rect.width, 2) + pow(rect.height, 2))
            let radius = diagonal / 2 + padding
            focusPath = UIBezierPath(roundedRect: CGRect(x: rect.midX - radius, y: rect.midY - radius, width: 2*radius, height: 2*radius), cornerRadius: CGFloat(radius))
        case .Square:
            focusPath = UIBezierPath(rect: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height))
        }
        if let focusPath = focusPath {
            path.append(focusPath)
            path.usesEvenOddFillRule = true
            fillLayer = CAShapeLayer()
            fillLayer!.path = path.cgPath
            fillLayer!.fillRule = CAShapeLayerFillRule.evenOdd
            switch style {
            case .Fade:
                fillLayer!.fillColor = color.cgColor
                fillLayer!.opacity = opacity
                self.layer.addSublayer(fillLayer!)
            case .Blur:
                blur = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
                blur!.frame = self.frame
                self.addSubview(blur!)
                blur!.layer.mask = fillLayer!
            }
            active = true
        }
        
    }
    
    public func removeFocus() {
        if isActive() {
            if style == .Blur {
                blur!.removeFromSuperview()
                blur = nil
            }
            fillLayer!.removeFromSuperlayer()
            fillLayer = nil
            active = false
        }
    }
    
    public func isActive() -> Bool {
        return self.active
    }
    
    
}

