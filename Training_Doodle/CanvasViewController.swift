//
//  CanvasViewController.swift
//  Training_Doodle
//
//  Created by mmslab-mini on 2020/6/30.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class Doodle : UIView {

    var lines = [Line]()
    var SliderValue = Float()
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
        lines.append(Line(Width: SliderValue, Color: StrokeColor, Points: []))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        guard var LinesFinale = lines.popLast() else { return }
        LinesFinale.Points.append(point)
        lines.append(LinesFinale)
        setNeedsDisplay()
    }

}

class CanvasViewController: UIViewController {
    /* Received Datas */
    var img = UIImage()
    let Canvas = Doodle()
    
    @IBOutlet var DoodleImgView: UIImageView!
    @IBOutlet var PaletteCollectionTable: UICollectionView!
    @IBOutlet var Slider: UISlider!
    @IBOutlet var myView: UIView!
    
    let Palette = [UIColor.black,UIColor.blue,UIColor.brown,UIColor.cyan,UIColor.darkGray,UIColor.gray,UIColor.green,UIColor.lightGray,UIColor.magenta,UIColor.orange,UIColor.purple,UIColor.red,UIColor.white,UIColor.yellow,UIColor.systemTeal,UIColor.systemPink,UIColor.systemIndigo,UIColor.systemGray3,UIColor.systemGray4,UIColor.systemGray5,UIColor.systemGray6]   // 21
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewInit()
        DoodleImgView.image = img
        view.addSubview(Canvas)
        Canvas.backgroundColor = .clear
        Canvas.frame = CGRect(x: 0, y: 217, width: 414, height: 414) //DoodleImgView.frame or myView.frame  bugged
        Canvas.StrokeColor = UIColor.black
    }
    
    func TableViewInit() {
        let cellNib = UINib(nibName: "PaletteCollectionViewCell", bundle: nil)
        PaletteCollectionTable.register(cellNib, forCellWithReuseIdentifier: "cell")
    }
    @IBAction func UndoBtnClicked(_ sender: Any) {
        _ = Canvas.lines.popLast()
        Canvas.setNeedsDisplay()
//        print("Undo")
    }
    @IBAction func ClearBtnClicked(_ sender: Any) {
        Canvas.lines.removeAll()
        Canvas.setNeedsDisplay()
//        print("Clear")
    }
    @IBAction func SliderValueChanged(_ sender: Any) {
//        print("Changed")
        Canvas.SliderValue = Slider.value
    }
    @IBAction func SaveBtnClicked(_ sender: Any) {
        // Saving DoodleImg
        UIGraphicsBeginImageContext(Canvas.bounds.size)
        Canvas.layer.render(in: UIGraphicsGetCurrentContext()!)
        let DoodleImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // Saving BackgroundImg
        let renderer = UIGraphicsImageRenderer(size: myView.bounds.size)
        let BackgroundImage = renderer.image { (context) in
            myView.drawHierarchy(in: myView.bounds, afterScreenUpdates: true)}
        // Merge two photos
        let size = CGSize(width: 414, height: 414)
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        BackgroundImage.draw(in: areaSize)
        DoodleImg.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
        let mergedImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // Saving
        UIImageWriteToSavedPhotosAlbum(mergedImg, nil, nil, nil)
        print("Saved")
    }
    
}

extension CanvasViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Palette.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PaletteCollectionTable.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PaletteCollectionViewCell
        cell.setCell(color: Palette[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected")
        Canvas.StrokeColor = Palette[indexPath.row]
    }
}
