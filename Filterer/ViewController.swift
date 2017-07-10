//
//  ViewController.swift
//  Filterer
//
//  Created by ShenZhenyuan on 1/18/16.
//  Copyright © 2016 ShenZhenyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var filteredImage: UIImage?
    var originalImage: UIImage?
    var showFilteredImage: Bool?
    var filterName: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var sliderMenu: UIView!
    @IBOutlet weak var bottomMenu: UIView!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    
   
    @IBOutlet weak var grayscaleButton: UIButton!
    @IBOutlet weak var gaussianButton: UIButton!
    @IBOutlet weak var contrastButton: UIButton!
    @IBOutlet weak var brightnessButton: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func onFilter(_ sender: UIButton) {
        hideSliderMenu()
        if(filterButton.isSelected){
            hideSecondaryMenu()
            filterButton.isSelected = false
            compareButton.isUserInteractionEnabled = false
        }else{
            showSecondaryMenu()
            filterButton.isSelected = true
            compareButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func onChangeValue(_ sender: AnyObject) {
        let temp = MyInstaFilter(inputImg: originalImage!)
        let intensity = Double(slider.value)
        filteredImage = temp.imgFilter(mode: filterName!, intensity: intensity)
        imageView.image = filteredImage
        showFilteredImage = true
    }
    
    
    @IBAction func onGrayScale(_ sender: UIButton) {
        if grayscaleButton.isSelected{
            grayscaleButton.isSelected = false
        }else{
            hideSliderMenu()
            gaussianButton.isSelected = false
            contrastButton.isSelected = false
            brightnessButton.isSelected = false
            
            let temp = MyInstaFilter(inputImg: originalImage!)
            filterName = "rgb2gray"
            filteredImage = temp.imgFilter(mode: filterName!)
            imageView.image = filteredImage
            showFilteredImage = true
            grayscaleButton.isSelected = true
        }
    }
    
    @IBAction func onGaussianBlur(_ sender: UIButton) {
        if gaussianButton.isSelected {
            gaussianButton.isSelected = false
            
        }else{
            grayscaleButton.isSelected = false
            contrastButton.isSelected = false
            brightnessButton.isSelected = false
            
            slider.minimumValue = 0.0
            slider.maximumValue = 3.0
            slider.value = 0.8
            
            let intensity = Double(slider.value)
            gaussianButton.isSelected = true
            
            let temp = MyInstaFilter(inputImg: originalImage!)
            filterName = "gaussianFilter"
            filteredImage = temp.imgFilter(mode: filterName!, intensity: intensity)
            imageView.image = filteredImage
            showFilteredImage = true
            
            showSliderMenu()
            
        }
    }
    
    @IBAction func onContrastAdjust(_ sender: UIButton) {
        if contrastButton.isSelected{
            hideSliderMenu()
            contrastButton.isSelected = false
        }else{
            grayscaleButton.isSelected = false
            gaussianButton.isSelected = false
            brightnessButton.isSelected = false
            
            slider.minimumValue = 0.0
            slider.maximumValue = 100.0
            slider.value = 50
            
            let intensity = Double(slider.value)
            contrastButton.isSelected = true
            
            filterName = "contrastAdjust"
            let temp = MyInstaFilter(inputImg: originalImage!)
            filteredImage = temp.imgFilter(mode: filterName!, intensity: intensity)
            imageView.image = filteredImage
            showFilteredImage = true
            
            showSliderMenu()
        }
    }
    
    @IBAction func onBrightnessAdjust(_ sender: UIButton) {
        if brightnessButton.isSelected{
            hideSliderMenu()
            brightnessButton.isSelected = false
        }else{
            grayscaleButton.isSelected = false
            gaussianButton.isSelected = false
            contrastButton.isSelected = false
            
            
            slider.minimumValue = 0.0
            slider.maximumValue = 5.0
            slider.value = 1.5
            
            let intensity = Double(slider.value)
            brightnessButton.isSelected = true
            let temp = MyInstaFilter(inputImg: originalImage!)
            filterName = "brightnessAdjust"
            filteredImage = temp.imgFilter(mode: filterName!, intensity: intensity)
            imageView.image = filteredImage
            showFilteredImage = true
            
            showSliderMenu()
        }
    }
    
    @IBAction func onCompare(_ sender: UIButton) {
        if compareButton.isSelected{
            compareButton.isSelected = false
        }
        else {
            compareButton.isSelected = true
        }
        toggleBetweenImage()
    }
    
    func toggleBetweenImage(){
        if showFilteredImage! {
            let crossFade = CABasicAnimation(keyPath:"contents")
            crossFade.duration = 1.0
            crossFade.fromValue = imageView.image!.cgImage
            crossFade.toValue = originalImage!.cgImage
            self.imageView.layer.add(crossFade, forKey:"animateContents")

            self.imageView.image = self.originalImage
            showFilteredImage = false
        }
        else{
            let crossFade = CABasicAnimation(keyPath:"contents")
            crossFade.duration = 1.0
            crossFade.toValue = imageView.image!.cgImage
            crossFade.fromValue = originalImage!.cgImage
            self.imageView.layer.add(crossFade, forKey:"animateContents")
            

            self.imageView.image = self.filteredImage
            showFilteredImage = true
        }
    }
    
    func showSliderMenu(){
        view.addSubview(sliderMenu)
    
        let bottomConstraint = sliderMenu.bottomAnchor.constraint(equalTo: secondaryMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 1.0
        
    }
    
    
    func showSecondaryMenu(){
        view.addSubview(secondaryMenu)
        
        
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let height = 0.25*view.frame.width
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.secondaryMenu.alpha = 1.0
        }) 
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleBetweenImage()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleBetweenImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !filterButton.isSelected {
            compareButton.isUserInteractionEnabled = false
        }
        originalImage = imageView.image // save the original image as the default image
        filteredImage = originalImage
        compareButton.isSelected = false
        showFilteredImage = false
        
        // enable user interaction so it will receive touch events
        imageView.isUserInteractionEnabled = true
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
//        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        
    
    }
    
    func imageTapped(_ img: AnyObject)
    {
        // Your action
        imageView.image = filteredImage
        
    }

    @IBAction func onNewPhoto(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
        
    }
    
    func showAlbum(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            filteredImage = image
            compareButton.isSelected = false
            showFilteredImage = false
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShare(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["check out our really cool app ", imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
    }
    
    func hideSliderMenu(){
        UIView.animate(withDuration: 1, animations: {
            self.sliderMenu.alpha = 0
        }) 
        
        UIView.animate(withDuration: 1, animations: {
            self.sliderMenu.alpha = 0
            }, completion: { completed in
                if completed == true{
                    self.sliderMenu.removeFromSuperview()
                }
        })
    }
    func hideSecondaryMenu(){
        UIView.animate(withDuration: 1, animations: {
            self.secondaryMenu.alpha = 0
        }) 
        
        UIView.animate(withDuration: 1, animations: {
            self.secondaryMenu.alpha = 0
            }, completion: { completed in
                if completed == true{
                    self.secondaryMenu.removeFromSuperview()
                }
        })
    }


}

