//
//  WeightViewController.swift
//  Mandarin
//
//  Created by Oleg on 11/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class WeightViewController: CategoryViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var weightHeaderLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var unitOfWeight: String = ""
    var nameWeightHeaderText: String = ""
    var podCategory_id: String = ""
    var contentWeightProduct = Set<String>()
    var contentWeightProductWithoutDuplicates = [String]()//Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightHeaderLabel.text = nameWeightHeaderText
        
        let param: Dictionary = ["salt" : "d790dk8b82013321ef2ddf1dnu592b79", "category_id" : "\(podCategory_id)"]
        UserRequest.getWeightCategory(param as [String : AnyObject], completion: {[weak self] json in
            json.forEach { _, json in
                let weight = json["weight"].string ?? ""
                self?.contentWeightProduct.insert(weight)
                self?.contentWeightProductWithoutDuplicates = (self?.contentWeightProduct.sorted {$0 < $1} ?? [])
            }
            self?.collectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentWeightProductWithoutDuplicates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weigthCell", for: indexPath) as? WeightCollectionViewCell
        cell?.weightUnitsLabelOne.text = "\(contentWeightProductWithoutDuplicates[indexPath.row]) " + self.unitOfWeight
        
        //output icon: liter or kg
        if (self.unitOfWeight == "liter") {
            cell?.iconWeightImageViev.image =  UIImage(named: "but")
        } else {
            cell?.iconWeightImageViev.image =  UIImage(named: "weight")
        }
        return cell ?? UICollectionViewCell()
    }
    
    
    //MARK: Segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let listOfProductsByWeightViewController = Storyboard.ListOfWeightProducts.instantiate()
        listOfProductsByWeightViewController.nameListsOfProductsHeaderText = nameWeightHeaderText
        //for compare in ListsOfProductVC
        listOfProductsByWeightViewController.weightOfWeightVC = contentWeightProductWithoutDuplicates[indexPath.row]
        listOfProductsByWeightViewController.idPodcategory = podCategory_id
        listOfProductsByWeightViewController.unitOfWeightForListOfProductsByWeightVC = self.unitOfWeight
        
        guard let containerViewController = UINavigationController.main.viewControllers.first as? ContainerViewController else { return }
        containerViewController.addController(listOfProductsByWeightViewController)
    }
    
}


