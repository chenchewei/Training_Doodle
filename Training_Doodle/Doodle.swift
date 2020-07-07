//
//  Doodle.swift
//  Training_Doodle
//
//  Created by mmslab-mini on 2020/7/7.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//
import UIKit

class DoodleContainer : UIView {

    lazy var doodle:Doodle = {
        let doodle = Doodle(frame: self.bounds)
        self.addSubview(doodle)
        return doodle
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView(frame: self.bounds)
        self.addSubview(imgView)
        self.sendSubviewToBack(imgView)
        return imgView
    }()
}

class Doodle : UIView {

    var lines = [Line]()
    var SliderValue = 5.0
    var StrokeColor = UIColor()
     
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        /* Split lines */
        lines.forEach { (line) in
            context.setStrokeColor(line.Color.cgColor)
            context.setLineWidth(CGFloat(line.Width))
            context.setLineCap(.round)
            for(index,point) in line.Points.enumerated() {
                if(index == 0) {
                    context.move(to: point)
                }
                else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        guard let convertPoint = self.superview?.superview?.convert(point, to: self) else { return }
        let rect = self.bounds
        if(rect.contains(convertPoint)){
            lines.append(Line(Width: Float(SliderValue), Color: StrokeColor, Points: []))
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        guard var LinesFinale = lines.popLast() else { return }
        guard let convertPoint = self.superview?.superview?.convert(point, to: self) else { return }

        LinesFinale.Points.append(convertPoint)
        lines.append(LinesFinale)
        setNeedsDisplay()
    }
}
