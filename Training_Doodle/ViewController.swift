//
//  ViewController.swift
//  Training_Doodle
//
//  Created by mmslab-mini on 2020/6/29.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var EditPhotoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EditPhotoBtn.isHidden = true
    }
    /* Choose Photo */
    @IBAction func PhotoSelectBtnClicked(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            let imgPickerController = UIImagePickerController()
            imgPickerController.sourceType = .photoLibrary
            imgPickerController.delegate = self
            imgPickerController.allowsEditing = true
            present(imgPickerController, animated: true)
        }
    }
    /* Jump and Send Photo to CanvasVC */
    @IBAction func EditPhotoBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let CanvasVC = storyboard.instantiateViewController(withIdentifier: "Canvas") as! CanvasViewController
        CanvasVC.img = imgView.image!
        self.navigationController?.pushViewController(CanvasVC, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            imgView.image = image
            EditPhotoBtn.isHidden = false
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
