//
//  CirclePercentageView.swift
//  CirclePercentage
//
//  Created by Leblanc on 2022/1/4.
//

import UIKit

class CirclePercentageView: UIView {

    /** 环形百分比，传小数， 0-1之间的值，包含0和1 */
    var percentage: CGFloat = 0.0
    /** 中心文本 */
    var textLabel: UILabel!
    /** 环形的宽，默认10 */
    var circleWidth: CGFloat = 10.0
    /** 圆环百分比之外的颜色 */
    var circleBgColor: UIColor = .white
    /** 圆环百分比之内的颜色 */
    var circleShowColor: [CGColor] = [UIColor.black.cgColor, UIColor.black.cgColor]
    /** 绘制方向，true为顺时针，false为逆时针 */
    var direction: Bool = false
    /** 圆环端点样式常量：kCALineCapButt（无端点）、kCALineCapRound（圆形端点）、kCALineCapSquare（方形端点，样式上和kCGLineCapButt是一样的，但是比kCGLineCapButt长一点）*/
    var lineCap: CAShapeLayerLineCap = .butt
    /** 显示文本字体 */
    var fontSize: UIFont = UIFont.boldSystemFont(ofSize: 20)
    /** 显示文本颜色 */
    var textColor: UIColor = .black
    /** 进度条的layer层（可做私有属性） */
    private var foreLayer: CAShapeLayer!
    
    
    /// 私有化指定初始化器
    /// - Parameter frame: frame
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 便捷初始化器
    /// - Parameters:
    ///   - frame: view frame
    ///   - circleWidth: 圆环宽度
    ///   - circlePercentage: 环形百分比，传小数， 0-1之间的值，包含0和1
    ///   - circleBgColor: 圆环百分比之外的颜色
    ///   - circleShowColor: 圆环百分比之内的颜色，数组形式，传两个相同颜色，是一个颜色；传多个不同颜色，为彩色圆环
    ///   - direction: 绘制方向，true为顺时针，false为逆时针
    ///   - lineCap: 圆环端点样式常量
    ///   - fontSize: 显示文本字体
    ///   - textColor: 显示文本颜色
    convenience init(frame: CGRect,
                     circleWidth: CGFloat? = 10,
                     circlePercentage: CGFloat? = 0,
                     circleBgColor: UIColor? = .white,
                     circleShowColor: [CGColor]? = [UIColor.black.cgColor, UIColor.black.cgColor],
                     direction: Bool? = false,
                     lineCap: CAShapeLayerLineCap? = .butt,
                     fontSize: UIFont? = UIFont.boldSystemFont(ofSize: 20),
                     textColor: UIColor? = .black) {
        
        self.init(frame: frame)
        self.circleWidth = circleWidth!
        self.percentage = circlePercentage!
        self.circleBgColor = circleBgColor!
        self.circleShowColor = circleShowColor!
        self.direction = direction!
        self.lineCap = lineCap!
        self.fontSize = fontSize!
        self.textColor = textColor!
        
        setUpSubViews()
    }
    
    /// 设置子控件
    func setUpSubViews() {
        
        // 背景圆环（灰色背景）
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        shapeLayer.lineWidth = circleWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = circleBgColor.cgColor
        
        // 画出曲线（贝塞尔曲线）
        // arcCenter: 圆心
        // radius：半径
        // startAngle：起点角度
        // endAngle：终点角度
        // clockwise：绘制方向是否为顺时针；bool类型，true为顺时针，false为逆时针
        let center: CGPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let startAngle = direction == true ? CGFloat(-0.5 * Double.pi) : CGFloat(1.5 * Double.pi)
        let endAngle = direction == true ? CGFloat(1.5 * Double.pi) : CGFloat(-0.5 * Double.pi)
        let bezierPath: UIBezierPath = UIBezierPath(arcCenter: center, radius: (frame.size.width - circleWidth) / 2, startAngle: startAngle, endAngle: endAngle, clockwise: direction)
        // 将曲线添加到layer层
        shapeLayer.path = bezierPath.cgPath
        // 添加蒙版
        self.layer.addSublayer(shapeLayer)
        
        // 渐变色 加蒙版 显示蒙版区域
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        // 设置渐变颜色
        gradientLayer.colors = circleShowColor
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.addSublayer(gradientLayer) // 将渐变色添加带layer的子视图

        // 进度条的layer层
        foreLayer = CAShapeLayer()
        foreLayer.frame = bounds
        foreLayer.fillColor = UIColor.clear.cgColor
        foreLayer.lineWidth = circleWidth
        foreLayer.strokeColor = UIColor.red.cgColor
        foreLayer.strokeEnd = 0
        // 设置断点样式
        foreLayer.lineCap = lineCap
        foreLayer.path = bezierPath.cgPath
        foreLayer.strokeEnd = percentage
        // 修改渐变layer层的遮罩, 关键代码
        gradientLayer.mask = self.foreLayer

        // 中心文本
        textLabel = UILabel(frame: CGRect(x: circleWidth, y: circleWidth, width: frame.width - circleWidth * 2, height: frame.width - circleWidth * 2))
        textLabel.text = String(format: "%.f", (percentage * 100))
        textLabel.font = fontSize
        textLabel.textColor = textColor
        textLabel.textAlignment = NSTextAlignment.center
        addSubview(textLabel)
        
    }
    
    
    /// 通过整数设置圆环百分比，传入0-100
    /// - Parameter circlePercentage: 百分比
    ///   - isPercentage: 是否显示百分号，默认否
    func setCirclePercentageWithInteger(_ circlePercentage: Int, _ isPercentage: Bool = false) {
        percentage = CGFloat(circlePercentage)
        if isPercentage {
            textLabel.text = "\(circlePercentage)%"
        } else {
            textLabel.text = String(circlePercentage)
        }
        // 视图改变的关键代码
        foreLayer?.strokeEnd = percentage / 100
    }
    
    
    /// 通过小数设置圆环百分比，传入0-1，保留两位小数
    /// - Parameter circlePercentage: 百分比
    ///   - isPercentage: 是否显示百分号，默认否
    func setCirclePercentageWithDecimal(_ circlePercentage: CGFloat, _ isPercentage: Bool = false) {
        percentage = circlePercentage
        let text = String(format: "%.2f", (circlePercentage * 100))
        if isPercentage {
            textLabel.text = "\(text)%"
        } else {
            textLabel.text = text
        }
        // 视图改变的关键代码
        foreLayer?.strokeEnd = percentage
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
