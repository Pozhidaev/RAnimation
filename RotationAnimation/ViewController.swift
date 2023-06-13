//
//  ViewController.swift
//  RotationAnimation
//
//  Created by Sergey Pozhidaev on 07.03.2019.
//  Copyright © 2019 Sergey Pozhidaev. All rights reserved.
//

import UIKit

final class ViewController: UIViewController
{
    //MARK: - IBOutlet

    @IBOutlet private weak var startGradientAngleSlider: UISlider!
    @IBOutlet private weak var startAngleSlider: UISlider!
    @IBOutlet private weak var horizontalAngleSlider: UISlider!
    @IBOutlet private weak var layersSpaceSlider: UISlider!
    @IBOutlet private weak var layersCountSlider: UISlider!

    @IBOutlet private weak var startGradientAngleLabel: UILabel!
    @IBOutlet private weak var startAngleLabel: UILabel!
    @IBOutlet private weak var horizontalAngleLabel: UILabel!
    @IBOutlet private weak var layersSpaceLabel: UILabel!
    @IBOutlet private weak var layersCountLabel: UILabel!

    @IBOutlet private weak var placeholderView: UIView!
    @IBOutlet private weak var smallPlaceholderView: UIView!

    @IBOutlet private weak var configTable: UITableView!
    
    @objc private var indicatorView: SDIndicator!
    @objc private var smallIndicatorView: SDIndicator!

    //MARK: - Private variables

    private let formatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    private var animate = false
    private var currentConfig = SDIndicatorConfig.defaultConfig { didSet {
        indicatorView.config = currentConfig
        smallIndicatorView.config = currentConfig
        updateSliders()
        updateLabels()
    } }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler))
        view.addGestureRecognizer(pinchRecognizer)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        view.addGestureRecognizer(panRecognizer)
        
        setupIndicatorView()
        setupSmallIndicatorView()
        
        currentConfig = Configs.configurations[0].1
        configTable.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        
//        var config = indicatorView.config
//        config.startAngle = 0.0
//        config.animationDuration = 10.0
//        currentConfig = config
    }

    //MARK: - IBActions

    @IBAction func startGradientAngleSliderChangeValue(_ sender: UISlider)
    {
        var config = currentConfig
        config.startGradientAngle = CGFloat(sender.value)
        currentConfig = config
    }
    
    @IBAction func startAngleSliderChangeValue(_ sender: UISlider)
    {
        var config = currentConfig
        config.startAngle = CGFloat(sender.value)
        currentConfig = config
    }
   
    @IBAction func horizontalAngleSliderChangeValue(_ sender: UISlider)
    {
        var config = currentConfig
        config.horizontalAngle = CGFloat(sender.value)
        currentConfig = config
    }
    
    @IBAction func layersSpaceSliderChangeValue(_ sender: UISlider)
    {
        let scaleY = sender.value / 10.0
        placeholderView.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(scaleY))
    }
    
    @IBAction func layersCountSliderChangeValue(_ sender: UISlider)
    {
        var config = currentConfig
        config.layersCount = Int(sender.value)
        currentConfig = config
    }

    @IBAction func startButtonPressed(_ sender: UIButton)
    {
        indicatorView.startAnimation()
        smallIndicatorView.startAnimation()
    }

    @IBAction func stopButtonPressed(_ sender: UIButton)
    {
        indicatorView.stopAnimation()
        smallIndicatorView.stopAnimation()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton)
    {
        placeholderView.transform = CGAffineTransformIdentity
    }
    
    //MARK: - Recognizer Actions
    
    @objc func pinchHandler(_ sender: UIPinchGestureRecognizer)
    {
        let scaleY = sender.velocity > 0 ? 1.05 : 0.95
        placeholderView.transform = CGAffineTransformScale(placeholderView.transform, 1.0, scaleY)
    }
    
    @objc func panHandler(_ sender: UIPanGestureRecognizer)
    {
        var config = currentConfig
        config.horizontalAngle = config.horizontalAngle + CGFloat(sender.velocity(in: view).y / 5000.0)
        config.startAngle = config.startAngle + CGFloat(sender.velocity(in: view).x / 5000.0)
        currentConfig = config
    }
    
    //MARK: - Private methods
    
    private func setupIndicatorView()
    {
        indicatorView = SDIndicator()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            indicatorView.topAnchor.constraint(equalTo: placeholderView.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor),
        ])
    }
    
    private func setupSmallIndicatorView()
    {
        smallIndicatorView = SDIndicator()
        smallIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        smallPlaceholderView.addSubview(smallIndicatorView)

        NSLayoutConstraint.activate([
            smallIndicatorView.leadingAnchor.constraint(equalTo: smallPlaceholderView.leadingAnchor),
            smallIndicatorView.trailingAnchor.constraint(equalTo: smallPlaceholderView.trailingAnchor),
            smallIndicatorView.topAnchor.constraint(equalTo: smallPlaceholderView.topAnchor),
            smallIndicatorView.bottomAnchor.constraint(equalTo: smallPlaceholderView.bottomAnchor),
        ])
    }
    
    private func updateLabels()
    {
        startGradientAngleLabel.text = formatter.string(from: indicatorView.config.startGradientAngle as NSNumber)
        startAngleLabel.text = formatter.string(from: indicatorView.config.startAngle as NSNumber)
        horizontalAngleLabel.text = formatter.string(from: indicatorView.config.horizontalAngle as NSNumber)
        layersCountLabel.text = formatter.string(from: indicatorView.config.layersCount as NSNumber)
    }
    
    private func updateSliders()
    {
        startGradientAngleSlider.value = Float(currentConfig.startGradientAngle)
        startAngleSlider.value = Float(currentConfig.startAngle)
        horizontalAngleSlider.value = Float(currentConfig.horizontalAngle)
        layersCountSlider.value = Float(currentConfig.layersCount)

        startGradientAngleLabel.text = formatter.string(from: startGradientAngleSlider.value as NSNumber)
        startAngleLabel.text = formatter.string(from: startAngleSlider.value as NSNumber)
        horizontalAngleLabel.text = formatter.string(from: horizontalAngleSlider.value as NSNumber)
        layersCountLabel.text = formatter.string(from: layersCountSlider.value as NSNumber)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Configs.configurations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let configName = Configs.configurations[indexPath.row].0
        cell.textLabel?.text = configName
        cell.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentConfig = Configs.configurations[indexPath.row].1
    }
}
