//
//  CanvasViewController.swift
//  Training_Doodle
//
//  Created by mmslab-mini on 2020/6/30.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    /* Received Datas */
    var img = UIImage()
    
    @IBOutlet var doodleContainer: DoodleContainer!
//    @IBOutlet var doodle: Doodle!   // View for display image and doodling
    @IBOutlet var PaletteCollectionTable: UICollectionView!
    @IBOutlet var Slider: UISlider!
    
    let Palette = [UIColor.blue,UIColor.cyan,UIColor.systemTeal,UIColor.green,UIColor.orange,UIColor.purple,UIColor.red,UIColor.magenta,UIColor.systemPink,UIColor.yellow,UIColor.systemIndigo,UIColor.black,UIColor.darkGray,UIColor.gray,UIColor.lightGray,UIColor.systemGray3,UIColor.systemGray4,UIColor.systemGray5,UIColor.systemGray6,UIColor.white]   // 21
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionViewInit()
        CanvasInit()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        doodleContainer.imageView.image = img   // Image chose from previous ViewController
    }

    func CollectionViewInit() {
        let cellNib = UINib(nibName: "PaletteCollectionViewCell", bundle: nil)
        PaletteCollectionTable.register(cellNib,forCellWithReuseIdentifier: "cell")
        PaletteCollectionTable.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    func CanvasInit() {
        doodleContainer.doodle.backgroundColor = .clear
        doodleContainer.doodle.StrokeColor = UIColor.black
    }
    @IBAction func UndoBtnClicked(_ sender: Any) {
        _ = doodleContainer.doodle.lines.popLast()
        doodleContainer.doodle.setNeedsDisplay()
//        print("Undo")
    }
    @IBAction func ClearBtnClicked(_ sender: Any) {
        doodleContainer.doodle.lines.removeAll()
        doodleContainer.doodle.setNeedsDisplay()
//        print("Clear")
    }
    @IBAction func SliderValueChanged(_ sender: Any) {
//        print("Changed")
        doodleContainer.doodle.SliderValue = Double(Slider.value)
    }
    @IBAction func SaveBtnClicked(_ sender: Any) {
        // Saving DoodleImg
        UIGraphicsBeginImageContext(doodleContainer.doodle.bounds.size)
        doodleContainer.doodle.layer.render(in: UIGraphicsGetCurrentContext()!)
        let DoodleImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // Saving BackgroundImg
        let renderer = UIGraphicsImageRenderer(size: doodleContainer.doodle.bounds.size)
        let BackgroundImage = renderer.image { (context) in
            doodleContainer.doodle.drawHierarchy(in: doodleContainer.doodle.bounds, afterScreenUpdates: true)}
        // Merge two photos
        let size = CGSize(width: 414, height: 414)
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        BackgroundImage.draw(in: areaSize)
        DoodleImg.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
        let mergedImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // Saving
        UIImageWriteToSavedPhotosAlbum(mergedImg, nil, nil, nil)
//        print("Saved")
    }
}

extension CanvasViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Palette.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PaletteCollectionTable.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = Palette[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected")
        doodleContainer.doodle.StrokeColor = Palette[indexPath.row]
    }
}
