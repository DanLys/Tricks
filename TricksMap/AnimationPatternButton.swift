//
//  AnimationPatternButton.swift
//  TricksMap
//
//  Created by Danil Lyskin on 19.09.2023.
//

import UIKit

public final class AnimationPatternButton: UIButton {
    private enum Constants {
        static let animationVector = CGPoint(x: 1, y: 0)
        static let fps: TimeInterval = 1 / 60
    }

    public var animationVector = Constants.animationVector
    public var fps: TimeInterval = Constants.fps {
        didSet {
            self.timer = Timer.scheduledTimer(timeInterval: self.fps,
                                              target: self,
                                              selector: #selector(self.updatePhase),
                                              userInfo: nil,
                                              repeats: true)
        }
    }

    private var phase: CGSize = .zero
    private lazy var timer = Timer.scheduledTimer(timeInterval: self.fps,
                                                  target: self,
                                                  selector: #selector(self.updatePhase),
                                                  userInfo: nil,
                                                  repeats: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        self.timer.fire()
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()

        self.timer.invalidate()
    }

    public override func draw(_ rect: CGRect) {
        self.drawPattern()
        super.draw(rect)
    }

    private func drawPattern() {
        guard let color = self.backgroundColor?.cgColor else { return }

        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setPatternPhase(self.phase)
        context?.setFillColor(color)
        context?.fill(self.bounds)
        context?.restoreGState()
    }

    @objc private func updatePhase() {
        guard let color = self.backgroundColor?.cgColor,
              color.pattern != nil else { return }

        self.phase = CGSize(width: self.phase.width + self.animationVector.x,
                            height: self.phase.height + self.animationVector.y)
        self.setNeedsDisplay()
    }
}

