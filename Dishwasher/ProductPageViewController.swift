//
//  ProductPageViewController.swift
//  Dishwasher
//
//  Created by Chen Shi on 3/13/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import UIKit

class ProductPageViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var productID: String?
    var imageURLs: [String] = []
    var features: [[String: String]] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblGuarantee: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleData()
        // Do any additional setup after loading the view.
    }
    
    func handleData() {
        // Set up the URL request
        let urlStr = "https://api.johnlewis.com/v1/products/\(productID!)?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
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
                        let productName = json["title"] as! String
                        self.imageURLs = ((json["media"] as! [String: Any])["images"] as! [String: Any])["urls"] as! [String]
                        self.features = (((json["details"] as! [String: Any])["features"] as! [Any])[0] as! [String: Any])["attributes"] as! [[String: String]]
                        let htmlStr = (json["details"] as! [String: Any])["productInformation"] as! String
                        let price = (json["price"] as! [String: Any])["now"] as! String
                        let offer = json["displaySpecialOffer"] as! String
                        let guarantees = (json["additionalServices"] as! [String: Any])["includedServices"] as! [String]
                        var guarantee = ""
                        for i in guarantees {
                            guarantee.append("\(i)\n")
                        }
                        DispatchQueue.main.async {
                            self.title = productName
                            self.lblPrice.text = "£\(price)"
                            self.lblOffer.text = offer
                            
                            self.lblGuarantee.text = guarantee
                            self.tableView.reloadData()
                            self.webView.loadHTMLString(htmlStr, baseURL: nil)
                            self.setup()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let currentPageOffset = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:currentPageOffset,y:0), animated: true)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { (_) in
            self.setup()
        }
    }
    
    func setup() {
        scrollView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        scrollView.invalidateIntrinsicContentSize()
        let scrollViewWidth:CGFloat = scrollView.frame.width
        let scrollViewHeight:CGFloat = scrollView.frame.height
        print(scrollViewWidth)
        print(scrollViewHeight)
        var i: CGFloat = 0
        for imageURL in imageURLs {
            let image = UIImageView(frame: CGRect(x:scrollViewWidth * i, y:0,width:scrollViewWidth, height:scrollViewHeight))
            image.contentMode = UIViewContentMode.scaleAspectFit
            let urlStr = "https:\(imageURL)"
            let url = URL(string: urlStr)
            image.sd_setImage(with: url)
            scrollView.addSubview(image)
            i += 1
        }

        scrollView.contentSize = CGSize(width:scrollViewWidth * i, height:scrollViewHeight)
        let currentPageOffset = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:currentPageOffset,y:0), animated: false)
        pageControl.numberOfPages = imageURLs.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        pageControl.currentPage = Int(currentPage);
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Product specification"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = features[indexPath.row]["name"]
        cell?.detailTextLabel?.text = features[indexPath.row]["value"]
        return cell!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
