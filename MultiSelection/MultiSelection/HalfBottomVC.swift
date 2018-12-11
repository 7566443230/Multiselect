//
//  HalfBottomVC.swift
//  MultiSelection
//
//  Created by mac on 29/09/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import HGRippleRadarView

class HalfBottomVC: UIViewController {

    @IBOutlet weak var PopView: UIView!
    @IBOutlet weak var RadarViewOutlet: RadarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PopView.layer.cornerRadius = 5
        PopView.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.clear
        self.RadarViewSetUp()
    }
    
    func RadarViewSetUp(){
        
        RadarViewOutlet?.dataSource = self
        RadarViewOutlet?.delegate = self
        
        let animals = [
            Animal(title:"bird",color:.lightBlue,imageName:"bird"),Animal(title:"cat",color:.lightBlue,imageName:"cat"),
            Animal(title:"cat",color:.lightGray,imageName:"catttle"),Animal(title:"dog",color:.lightGray,imageName:"dog"),
            Animal(title:"sheep",color:.lightBlack,imageName:"tiger"),Animal(title:"tiger",color:.lightBlack,imageName:"rat"),
            Animal(title:"epnt",color:.darkYellow,imageName:"elephant"),Animal(title:"hipop",color:.lightPink,imageName: "lion"),
            Animal(title:"lion",color:.lightPink,imageName:"hippopotamus"),Animal(title:"Rat",color:.darkYellow,imageName:"sheep"),
        ]
        
        let items = animals.map { Item(uniqueKey: $0.title, value: $0) }
        RadarViewOutlet.add(items: items)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.40)
        view.isOpaque = false
    }
    
    @IBAction func DismissPopVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension HalfBottomVC: RadarViewDataSource {
    
    func radarView(radarView: RadarView, viewFor item: Item, preferredSize: CGSize) -> UIView {
        let animal = item.value as? Animal
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)
        let imageView = UIImageView(frame: frame)
        
        guard let imageName = animal?.imageName else { return imageView }
        let image =  UIImage(named: imageName)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }
}

extension HalfBottomVC: RadarViewDelegate {
    
    func radarView(radarView: RadarView, didSelect item: Item) {
        //let view = radarView.view(for: item)
        //enlarge(view: view)
        guard let animal = item.value as? Animal else { return }
        print("Did Selected",animal)
    }
    
    func radarView(radarView: RadarView, didDeselect item: Item) {
        //let view = radarView.view(for: item)
        //reduce(view: view)
        guard let animal = item.value as? Animal else { return }
        print("De- Select",animal)
    }
    
    func radarView(radarView: RadarView, didDeselectAllItems lastSelectedItem: Item) {
        //let view = radarView.view(for: lastSelectedItem)
        //reduce(view: view)
        print("DidDeselectAllItemS")
    }
    
}

