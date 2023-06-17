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
        imageView.image = UIImage(named: "background")
        return imageView
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "25:00"
        label.textColor = .systemOrange
        label.font = UIFont.boldSystemFont(ofSize: 42)
        return label
    }()

    private lazy var controlButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 42), forImageIn: .normal)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(timerLabel)
        view.addSubview(controlButton)
    }

    private func setupConstraints() {
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            let height = UIScreen.main.bounds.height
            make.top.equalTo(height * 0.4)
        }

        controlButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.bottom).offset(24)
        }
    }

    // MARK: - Timer

    @objc func buttonTapped(sender: UIButton!) {
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
        timerLabel.textColor = .systemOrange
        controlButton.tintColor = .systemOrange
    }

    func setRelaxTimeColors() {
        timerLabel.textColor = .systemGreen
        controlButton.tintColor = .systemGreen
    }

    func createTimer() -> Timer {
        var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            counter -= 1
            if counter < 0 {
                if isWorkTime {
                    isWorkTime = false
                    self.setRelaxTimeColors()
                    counter = 5
                } else {
                    isWorkTime = true
                    self.setWorkTimeColors()
                    counter = 25
                }

            }
            self.timerLabel.text = "\(counter):00"
        }
        return timer
    }
    
}
