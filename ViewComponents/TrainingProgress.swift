//
//  CircularProgressView.swift
//  United cloud
//
//  Created by Bojan Vujnovic on 30.1.23..
//  Copyright © 2023 United Cloud. All rights reserved.
//

import UIKit

@IBDesignable final class TrainingProgress: UIView {

    private enum Constants {
        static let arcWidth: CGFloat = 35
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var monthlyEnteryLabel: UILabel!
    var numerOfTrainings: Int = 20
    var counter: Int = 10
    var progressColor: UIColor = UIColor.blue
    var trackColor: UIColor = UIColor.opaqueSeparator
    var progressLayer = CAShapeLayer()


    

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // needs to be set here for Storyboard / IB
    }

    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2 + Constants.arcWidth)
        let radius = max(bounds.width - Constants.arcWidth, bounds.height - Constants.arcWidth)

        let startAngle: CGFloat = .pi
        let endAngle: CGFloat = 2 * .pi

        let path = UIBezierPath(arcCenter: center, radius: radius / 2 - Constants.arcWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        path.lineWidth = Constants.arcWidth
        path.lineCapStyle = .round
        trackColor.setStroke()
        path.stroke()

        let perTraining = 1 / CGFloat(numerOfTrainings)
        let progressEnd = perTraining * CGFloat(counter)
        addProgressLayer(progressLayer: progressLayer, path: path.cgPath, progressEnd: progressEnd)
        //progressLayer.strokeEnd += 0.5

    }

    func addProgressLayer(progressLayer: CAShapeLayer, path: CGPath,progressEnd: CGFloat) {
        progressLayer.path = path
        progressLayer.strokeColor = UIColor.systemRed.cgColor
        progressLayer.lineWidth = Constants.arcWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = progressEnd
        progressLayer.isOpaque = false
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
    }

    //    func setProgressWithAnimation(duration: TimeInterval, value: Double) {
    //        let animation = CABasicAnimation(keyPath: Constants.strokeEndKey)
    //        animation.duration = duration
    //        animation.fromValue = fromValue < value ? fromValue : value
    //        animation.toValue = value
    //        self.fromValue = value
    //        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    //        self.progressLayer.strokeEnd = CGFloat(value)
    //        self.progressLayer.add(animation, forKey: Constants.animateCircleKey)
    //    }
}


extension UIView {
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
