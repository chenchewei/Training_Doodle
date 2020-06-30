//
//  CanvasViewController.swift
//  Training_Doodle
//
//  Created by mmslab-mini on 2020/6/30.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class Doodle : UIView {
    
    var lines = [[CGPoint]]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        

        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(7)
        context.setLineCap(.round)
        /* Split lines */
        lines.forEach { (line) in
            for(index,point) in line.enumerated() {
                if(index == 0) {
                    context.move(to: point)
                }
                else {
                    context.addLine(to: point)
                }
            }
        }
        
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        guard var LinesFinale = lines.popLast() else { return }
        LinesFinale.append(point)
        lines.append(LinesFinale)
        setNeedsDisplay()
    }
    
}


class CanvasViewController: UIViewController {
    /* Received Datas */
    var img = UIImage()
    let Canvas = Doodle()
    
    @IBOutlet var DoodleImgView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DoodleImgView.image = img
        view.addSubview(Canvas)
        Canvas.backgroundColor = .clear
        Canvas.frame = CGRect(x: 0, y: 175, width: 414, height: 414) //DoodleImgView.frame   bugged

    }
    @IBAction func UndoBtnClicked(_ sender: Any) {
        _ = Canvas.lines.popLast()
        Canvas.setNeedsDisplay()
    }
    @IBAction func ClearBtnClicked(_ sender: Any) {
        Canvas.lines.removeAll()
        Canvas.setNeedsDisplay()
    }
    
}
