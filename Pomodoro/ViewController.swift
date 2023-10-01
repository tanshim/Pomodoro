//
//  ViewController.swift
//  Pomodoro
//
//  Created by Sultan on 12.06.2023.
//

import UIKit
import SnapKit

var isWorkTime = true
var isStarted = false
var isRunning = false
var counter = 25
var remainingCounter = 0
var timer: Timer = Timer()

class ViewController: UIViewController {

    // MARK: - Outlets

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradient1")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "25:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 42)
        return label
    }()

    private lazy var controlButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 42), forImageIn: .normal)
        return button
    }()

    private lazy var progressBar: CircularProgressView =  {
        let progressView = CircularProgressView(frame: CGRect(x: -90, y: -35, width: 180, height: 180), lineWidth: 5, rounded: false)
        progressView.trackColor = .white
        progressView.progressColor = UIColor(red: 0.98, green: 0.48, blue: 0.13, alpha: 1.00)
        return progressView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(timerLabel)
        view.addSubview(controlButton)
        view.addSubview(progressBar)
    }

    private func setupConstraints() {
        let height = UIScreen.main.bounds.height
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(height * 0.4)
        }
        controlButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.bottom).offset(24)
        }
        progressBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.top)
        }
    }

    // MARK: - Timer logic

    @objc func buttonTapped() {
        if !isStarted {
            timer = createTimer()
            isStarted = true
            isRunning = true
            self.controlButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            if isRunning {
                self.controlButton.setImage(UIImage(systemName: "play"), for: .normal)
                pauseTimer()
                isRunning = false
            } else {
                self.controlButton.setImage(UIImage(systemName: "pause"), for: .normal)
                resumeTimer()
                isRunning = true
            }
        }
    }

    func pauseTimer() {
        remainingCounter = counter
        timer.invalidate()
    }

    func resumeTimer() {
        counter = remainingCounter
        timer = createTimer()
    }

    func setWorkTimeColors() {
        progressBar.progressColor = UIColor(red: 0.98, green: 0.48, blue: 0.13, alpha: 1.00)
        backgroundImageView.image = UIImage(named: "gradient1")
    }

    func setRelaxTimeColors() {
        progressBar.progressColor = UIColor(red: 0.43, green: 0.66, blue: 0.89, alpha: 1.00)
        backgroundImageView.image = UIImage(named: "gradient3")
    }

    func createTimer() -> Timer {
        var progressPercent: Float = isWorkTime ? 0.04 : 0.1
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            counter -= 1
            if counter < 0 {
                self.progressBar.progress = 0
                if isWorkTime {
                    isWorkTime = false
                    self.setRelaxTimeColors()
                    counter = 9
                    progressPercent = 0.1
                } else {
                    isWorkTime = true
                    self.setWorkTimeColors()
                    counter = 24
                    progressPercent = 0.04
                }
            }
            self.progressBar.progress += progressPercent
            self.timerLabel.text = "\(counter):00"
        }
        return timer
    }

}
