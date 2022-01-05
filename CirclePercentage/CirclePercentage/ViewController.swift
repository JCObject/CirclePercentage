//
//  ViewController.swift
//  CirclePercentage
//
//  Created by Leblanc on 2022/1/4.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "圆环百分比"
        view.backgroundColor = .brown
        setUpSubViews()
    }
    
    /// 设置子控件
    func setUpSubViews() {
        
        let width = view.frame.width
        let itemW: CGFloat = 120
        let itemH: CGFloat = 120
        
        // 逆时针无端点
        let p1_l = CirclePercentageView(frame: CGRect(x: width / 2 - 140, y: 100, width: itemW, height: itemH), circlePercentage: 0.7)
        view.addSubview(p1_l)
        
        // 逆时针圆形端点
        let p1_r = CirclePercentageView(frame: CGRect(x: width / 2 + 20, y: 100, width: itemW, height: itemH), circlePercentage: 0.7, lineCap: .round)
        view.addSubview(p1_r)
        
        // 顺时针无端点
        let p2_l = CirclePercentageView(frame: CGRect(x: p1_l.frame.minX, y: p1_l.frame.maxY + 50, width: itemW, height: itemH), circlePercentage: 0.7, direction: true)
        view.addSubview(p2_l)
        
        // 顺时针圆形端点
        let p2_r = CirclePercentageView(frame: CGRect(x: p1_r.frame.minX, y: p1_r.frame.maxY + 50, width: itemW, height: itemH), circlePercentage: 0.7, direction: true, lineCap: .round)
        view.addSubview(p2_r)
        
        // 逆时针圆形端点彩色圆环
        let p3_l = CirclePercentageView(frame: CGRect(x: p2_l.frame.minX, y: p2_l.frame.maxY + 50, width: itemW, height: itemH), circlePercentage: 0.7,  circleBgColor: .cyan, circleShowColor: [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.yellow.cgColor], lineCap: .round)
        view.addSubview(p3_l)
        
        // 顺时针圆形端点彩色圆环
        let p3_r = CirclePercentageView(frame: CGRect(x: p2_r.frame.minX, y: p2_r.frame.maxY + 50, width: itemW, height: itemH), circlePercentage: 0.7,  circleBgColor: .cyan, circleShowColor: [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.yellow.cgColor], direction: true, lineCap: .round)
        view.addSubview(p3_r)

    }
    
    
}

