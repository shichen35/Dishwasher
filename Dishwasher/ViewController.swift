//
//  ViewController.swift
//  Dishwasher
//
//  Created by Chen Shi on 3/13/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DishwasherCollectionViewCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.gray.cgColor
        let product = products[indexPath.row] as! [String: Any]
        let price = product["price"] as! [String: Any]
        cell.lblPrice.text = "£\(price["now"] as! String)"
        cell.lblTitle.text = product["title"] as? String
        
        let urlStr = String(format: "https:%@", product["image"] as! String)

        let url = URL(string: urlStr)
        
        cell.imageView.sd_setImage(with: url!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProductPageSegue", sender: self)
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var products:[Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        handleData()

    }

    func handleData() {
        // Set up the URL request
        let urlStr = "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20"
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        
        let dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                        self.products = json["products"] as! [Any]
                        let productsCount = json["results"] as! Int
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.title = "Dishwashers (\(productsCount))"
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }
        }
        dataTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductPageSegue" {
            let vc = segue.destination as! ProductPageViewController
            vc.productID = (products[collectionView.indexPathsForSelectedItems![0].row] as! [String: Any])["productId"] as? String
        }
    }
    
}

