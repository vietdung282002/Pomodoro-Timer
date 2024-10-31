//
//  ViewController.swift
//  Pomodoro Timer
//
//  Created by Tong Viet Dung on 29/10/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    
    private let foreProgressLayer = CAShapeLayer()
    private let backProgressLayer = CAShapeLayer()
    private let animation = CABasicAnimation()
    
    private var timer = Timer()
    private var isTimeStarted = false
    private var isAnimationStarted = false
    private var time = 1*60
    
    private var didApplyConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startButton.layer.cornerRadius = 12
        
        resetButton.layer.cornerRadius = 12
        resetButton.layer.borderWidth = 3
        resetButton.layer.borderColor = UIColor.white.cgColor
        
        timeLabel.text = formatTime()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didApplyConstraints {
            didApplyConstraints = true
            drawBackLayer()
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any){
        if !isTimeStarted{
            startTimer()
            drawForeProgressLayer()
            StartResumeAnimation()
            isTimeStarted = true
            startButton.setTitle("Pause", for: .normal)
        }else{
            timer.invalidate()
            isTimeStarted = false
            startButton.setTitle("Start", for: .normal)
            pauseAnimation()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: Any){
        timer.invalidate()
        time = 1*60
        isTimeStarted = false
        timeLabel.text = "01:00"
        startButton.setTitle("Start", for: .normal)
        stopAnimation()
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(){
        time -= 1
        timeLabel.text = formatTime()
    }
    
    private func formatTime() -> String{
        let minutes = Int(time)/60
        let seconds = Int(time)%60
        return String(format: "%02d:%02d", minutes,seconds)
    }
    
    private func drawBackLayer(){
        let centerX = timeView.bounds.midX
        let centerY = timeView.bounds.midY

        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: 100, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi, clockwise: true).cgPath
        
        backProgressLayer.strokeColor = UIColor(red: 251/255, green: 164/255, blue: 33/255, alpha: 1.0).cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 10
        timeView.layer.addSublayer(backProgressLayer)
    }
    
    private func drawForeProgressLayer(){
        let centerX = timeView.bounds.midX
        let centerY = timeView.bounds.midY
        
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: 100, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi, clockwise: true).cgPath
        
        foreProgressLayer.strokeColor = UIColor.white.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 10
        timeView.layer.addSublayer(foreProgressLayer)
    }
    
    private func StartResumeAnimation(){
        if !isAnimationStarted{
            startAnimation()
        }else{
            resumeAnimation()
        }
    }
    
    private func startAnimation(){
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = Double(time)
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    
    private func resetAnimation(){
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    private func resumeAnimation(){
        let pauseTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePause = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        foreProgressLayer.beginTime = timeSincePause
    }
    
    private func pauseAnimation(){
        let pauseTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.timeOffset = pauseTime
        foreProgressLayer.speed = 0.0
    }
    
    private func stopAnimation(){
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
}

