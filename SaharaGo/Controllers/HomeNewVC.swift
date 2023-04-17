//
//  HomeNewVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 14/10/22.
//

import UIKit

class HomeNewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var productCollView: UICollectionView!
    @IBOutlet weak var multimediaCollView: UICollectionView!
    
    var multimediaImgArr = ["multimedia_two", "multimedia_one"]
    var productImgArr = ["marketplace_two", "marketplace_three", "marketplace_one"]

    var isFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.setCartBadge()
    }
    
    func setCartBadge() {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    @objc func updateCartBadge(_ notification: Notification) {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    @IBAction func bannerActions(_ sender: UIButton) {
        
        if sender.tag == 101 {
            let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
            vc.delegate = self
            vc.isFrom = "Multimedia"
            UserDefaults.standard.set("Multimedia", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
            self.present(vc, animated: true, completion: nil)
                
        } else {
            country = "Nigeria"
            UserDefaults.standard.set("nigeria.png", forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG)
            UserDefaults.standard.set("rgba(0,131,78,1)", forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE)
            UserDefaults.standard.set("Nigeria", forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY)
            let productsVC = DIConfigurator.shared.getProductsVC()
            productsVC.isFrom = "MarketPlace"
            UserDefaults.standard.set("Products", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
            self.navigationController?.pushViewController(productsVC, animated: true)
        }
        
    }
    
    @IBAction func onClickCart(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let cartVC = DIConfigurator.shared.getCartVC()
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func onClickWishlist(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let wishlistVC = DIConfigurator.shared.getWishlistVC()
            self.navigationController?.pushViewController(wishlistVC, animated: true)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.multimediaCollView {
            return self.multimediaImgArr.count
        } else {
            return self.productImgArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.multimediaCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewBannerCollCell", for: indexPath) as! HomeNewBannerCollCell
            
            cell.cellImg.image = UIImage.init(named: "\(self.multimediaImgArr[indexPath.row])")

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewBannerProductsCollCell", for: indexPath) as! HomeNewBannerProductsCollCell
            
            cell.cellImg.image = UIImage.init(named: "\(self.productImgArr[indexPath.row])")
            
            return cell
        }
        

        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let collectionHeight = collectionView.bounds.height
        return CGSize(width: collectionWidth, height: collectionHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension HomeNewVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let productsVC = DIConfigurator.shared.getProductsVC()
        productsVC.isFrom = "Multimedia"
        self.navigationController?.pushViewController(productsVC, animated: true)
    }

}
