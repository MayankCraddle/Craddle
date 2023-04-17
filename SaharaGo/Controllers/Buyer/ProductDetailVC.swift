//
//  ProductDetailVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 26/07/22.
//

import UIKit
import Cosmos

class ProductDetailVC: UIViewController {

    @IBOutlet weak var mainDescViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var variantStackView: UIStackView!
    @IBOutlet weak var variantCollView: UICollectionView!
    @IBOutlet weak var productWeightLbl: UILabel!
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var bannerCollView: UICollectionView!
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var productDiscountPercentageLbl: UILabel!
    @IBOutlet weak var productActualPriceLbl: UILabel!
    @IBOutlet weak var productRatingLbl: UILabel!
    @IBOutlet weak var returnPolicyView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productDiscountedPriceLbl: UILabel!
    @IBOutlet weak var productDescriptionLbl: UILabel!
    @IBOutlet weak var returnPolicyLbl: UILabel!
    
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var vendorDetailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var returnPolicyHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vendorDetailsView: UIView!
    
    @IBOutlet weak var descriptionExpandImg: UIImageView!
    @IBOutlet weak var vendorDetailsExpandImg: UIImageView!
    @IBOutlet weak var ratingsExpandImg: UIImageView!
    @IBOutlet weak var returnPolicyExpandImg: UIImageView!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    @IBOutlet weak var similarProductsCollectionView: UICollectionView!
    @IBOutlet weak var otherProductsCollView: UICollectionView!
    @IBOutlet weak var onSaleCollView: UICollectionView!
    @IBOutlet weak var newArrivalCollView: UICollectionView!
    
    @IBOutlet weak var similarProductsLblHeight: NSLayoutConstraint!
    @IBOutlet weak var similarProductsCollHeight: NSLayoutConstraint!
    @IBOutlet weak var otherProductsLblHeight: NSLayoutConstraint!
    @IBOutlet weak var otherProductsCollHeight: NSLayoutConstraint!
    @IBOutlet weak var newArrivalsLblHeight: NSLayoutConstraint!
    @IBOutlet weak var newArrivalsCollHeight: NSLayoutConstraint!
    @IBOutlet weak var onSaleCollHeight: NSLayoutConstraint!
    @IBOutlet weak var onSaleLblHeight: NSLayoutConstraint!
    @IBOutlet weak var newArrivalsLbl: UILabel!
    @IBOutlet weak var onSaleLbl: UILabel!
    @IBOutlet weak var otherProductsLbl: UILabel!
    @IBOutlet weak var similarProductsLbl: UILabel!
    
    @IBOutlet weak var newArrivalsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var onSaleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherProductsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var similarProductsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var similarCollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherProductsCollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var onSaleCollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var newArrivalsCollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var vendorImg: UIImageView!
    @IBOutlet weak var vendorDetailsLbl: UILabel!
    @IBOutlet weak var vendorRating: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var socialMediaStackView: UIStackView!
    @IBOutlet weak var fiveStarRatingLbl: UILabel!
    @IBOutlet weak var fourStarRatingLbl: UILabel!
    @IBOutlet weak var threeStarRatingLbl: UILabel!
    @IBOutlet weak var twoStarRatingLbl: UILabel!
    @IBOutlet weak var oneStarRatingLbl: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var instaBtn: UIButton!
    
    @IBOutlet weak var oneStarProgressView: UIProgressView!
    @IBOutlet weak var twoStarProgressView: UIProgressView!
    @IBOutlet weak var threeStarProgressView: UIProgressView!
    @IBOutlet weak var fourStarProgressView: UIProgressView!
    @IBOutlet weak var fiveStarProgressView: UIProgressView!
    
    
    var isDescriptionOpened = true
    var isVendorDetailsOpened = true
    var isRatingsOpened = true
    var isReturnPolicyOpened = true
    var similarProductsArr = [SimilarProducts_Struct]()
    var otherProductsSoldByVendorArr = [SimilarProducts_Struct]()
    var onSaleProductsArr = [SimilarProducts_Struct]()
    var newArrivalsArr = [SimilarProducts_Struct]()
    var variantsArr = [productVariantStruct]()
    var variantsDuplicateArr = [productVariantStruct]()
    
    var productDetails = categoryProductListStruct()
    var itemID: String?
    var productID: String?
    var vendorID: String?
    var font = UIFont()
    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    var socialMediaArr = [SocialMediaStruct]()
    var bannerImagesArr = [String]()
    
    var imagesWithUrlArr = [URL]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 15.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    var variantSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kProductDetailScreen)
        font = UIFont(name: "Poppins-Regular", size: 10.0)!
        self.view.layoutIfNeeded()
        
        similarProductsCollectionView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        otherProductsCollView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        onSaleCollView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        newArrivalCollView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        variantCollView.register(UINib(nibName: "VariantCollCell", bundle: nil), forCellWithReuseIdentifier: "VariantCollCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
        
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            getItemByItemID(itemID: self.productID!, userId: UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_ID) as! String)
        } else {
            getItemByItemID(itemID: self.productID!, userId: "")
        }
        
        self.getSimilarProducts(self.itemID!)
        self.getOtherProductsSoldByVendor(self.itemID!)
        self.getOnSaleProducts(self.itemID!)
        self.getNewArrivalProducts(self.vendorID ?? "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setCartBadge()
        self.navigationController?.navigationBar.isHidden = true
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    }
    
    @objc func updateCartBadge(_ notification: Notification) {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    func setCartBadge() {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        cartView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 25)
        let height = self.heightForView(text: self.productDetails.description, font: self.font, width: self.descriptionView.bounds.size.width)
        self.descriptionViewHeight.constant = height + 15
        self.descriptionExpandImg.image = UIImage(named: "up arrow")
        self.vendorDetailsViewHeight.constant = 100.0
        self.vendorDetailsExpandImg.image = UIImage(named: "up arrow")
        self.ratingsViewHeight.constant = 100.0
        self.ratingsExpandImg.image = UIImage(named: "up arrow")
        let returnPolicyHeight = self.heightForView(text: self.productDetails.returnPolicy, font: self.font, width: self.returnPolicyView.bounds.size.width)
        self.returnPolicyHeight.constant = returnPolicyHeight + 20
        self.returnPolicyExpandImg.image = UIImage(named: "up arrow")
        
        self.socialMediaStackView.isHidden = false
        self.ratingStackView.isHidden = false
        self.writeReviewBtn.isHidden = false
        self.vendorDetailsView.isHidden = false
    }
    
    @IBAction func expandTabActions(_ sender: UIButton) {
        if sender.tag == 101 {
            if isDescriptionOpened {
                UIView.animate(withDuration: 0.2) {
                    self.descriptionViewHeight.constant = 0.0
                    self.descriptionExpandImg.image = UIImage(named: "down-arrow")
                    self.view.layoutIfNeeded()
                }
                
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    let height = self.heightForView(text: self.productDetails.description, font: self.font, width: self.descriptionView.bounds.size.width)
                    self.descriptionViewHeight.constant = height + 15
                    self.descriptionExpandImg.image = UIImage(named: "up arrow")
                    self.view.layoutIfNeeded()
                }
                
            }
            self.isDescriptionOpened = !self.isDescriptionOpened
        } else if sender.tag == 102 {
            if isVendorDetailsOpened {
                UIView.animate(withDuration: 0.2) {
                    self.vendorDetailsViewHeight.constant = 0.0
                    self.vendorDetailsView.isHidden = true
                    self.vendorDetailsExpandImg.image = UIImage(named: "down-arrow")
                    self.view.layoutIfNeeded()
                }
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.vendorDetailsViewHeight.constant = 100.0
                    self.vendorDetailsView.isHidden = false
                    self.vendorDetailsExpandImg.image = UIImage(named: "up arrow")
                    self.view.layoutIfNeeded()
                }
                
            }
            self.isVendorDetailsOpened = !self.isVendorDetailsOpened
        } else if sender.tag == 103 {
            if isRatingsOpened {
                UIView.animate(withDuration: 0.2) {
                    self.ratingsViewHeight.constant = 0.0
                    self.ratingsExpandImg.image = UIImage(named: "down-arrow")
                    self.socialMediaStackView.isHidden = true
                    self.ratingStackView.isHidden = true
                    self.writeReviewBtn.isHidden = true
                    self.view.layoutIfNeeded()
                }
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.ratingsViewHeight.constant = 100.0
                    self.ratingsExpandImg.image = UIImage(named: "up arrow")
                    self.socialMediaStackView.isHidden = false
                    self.ratingStackView.isHidden = false
                    self.writeReviewBtn.isHidden = false
                    self.view.layoutIfNeeded()
                }
                
            }
            self.isRatingsOpened = !self.isRatingsOpened
        } else {
            if isReturnPolicyOpened {
                UIView.animate(withDuration: 0.2) {
                    self.returnPolicyHeight.constant = 0.0
                    self.returnPolicyExpandImg.image = UIImage(named: "down-arrow")
                    self.view.layoutIfNeeded()
                }
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    let height = self.heightForView(text: self.productDetails.returnPolicy, font: self.font, width: self.returnPolicyView.bounds.size.width)
                    self.returnPolicyHeight.constant = height + 20
                    self.returnPolicyExpandImg.image = UIImage(named: "up arrow")
                    self.view.layoutIfNeeded()
                }
                
            }
            self.isReturnPolicyOpened = !self.isReturnPolicyOpened
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
    
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            if !self.productDetails.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUserFromMainAddToCart(self.productDetails)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "ProductDetailVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

    }
    
    @IBAction func onClickWriteReview(_ sender: UIButton) {
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kViewProductReview)
        let viewAllVC = DIConfigurator.shared.getViewCommentsVC()
        // viewAllVC.blogId = Int(self.productDetails.itemId) ?? 0
        viewAllVC.itemId = self.productDetails.itemId
        viewAllVC.shortDesc = self.productDetails.name
        viewAllVC.isFromProduct = true
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    
    func getItemByItemID(itemID: String, userId: String){
        
        if Reachability.isConnectedToNetwork(){
            
            showProgressOnView(appDelegateInstance.window!)
            
            ServerClass.sharedInstance.getRequestWithUrlParameters([:], path: BASE_URL + PROJECT_URL.GET_PRODUCT_BY_ITEM_ID + itemID + "?userId=\(userId)", successBlock: { (response) in
                hideAllProgressOnView(appDelegateInstance.window!)
                print(response)
                
                let currency = response["currency"].stringValue
                let description = response["metaData"]["description"].stringValue
                let productWeight = response["metaData"]["productWeight"].stringValue
                let category = response["categoryId"].stringValue
                let stock = response["stock"].stringValue
                let vendorName = response["vendorName"].stringValue
                let vendorId = response["vendorId"].stringValue
                let productID = response["productId"].stringValue
                let itemID = response["itemId"].stringValue
                let discountedPrice = response["discountedPrice"].stringValue
                let discountPercent = response["discountValue"].stringValue
                let price = response["price"].stringValue
                let rating = response["rating"].stringValue
                let name = response["name"].stringValue
                let wishlisted = response["wishlisted"].boolValue
                let orderable = response["orderable"].boolValue
                let actualPrice = response["actualPrice"].stringValue
                let returnPolicy = response["returnPolicy"].stringValue
                
                let vCompanyName = response["vendorMetaData"]["companyName"].stringValue
                let vCity = response["vendorMetaData"]["city"].stringValue
                let vstreetAddress = response["vendorMetaData"]["streetAddress"].stringValue
                let vCountry = response["vendorMetaData"]["country"].stringValue
                let vState = response["vendorMetaData"]["state"].stringValue
                let vEmailMobile = response["emailMobile"].stringValue
                let vImage = response["vendorMetaData"]["image"].stringValue
                let vRating = response["vendorRating"].stringValue
                
                let vEncryptedId = response["vendorEncryptedId"].stringValue
                let vfcmKey = response["fcmKey"].stringValue
                let shareUrl = response["shareUrl"].stringValue
                
                self.socialMediaArr.removeAll()
                for i in 0..<response["vendorMetaData"]["socialMediaLinks"].count {
                    self.socialMediaArr.append(SocialMediaStruct.init(link: response["vendorMetaData"]["socialMediaLinks"][i]["link"].stringValue, type: response["vendorMetaData"]["socialMediaLinks"][i]["type"].stringValue))
                }
                
                self.bannerImagesArr.removeAll()
                self.imagesWithUrlArr.removeAll()
                self.variantsArr.removeAll()
                for j in 0..<response["metaData"]["images"].count {
                    self.bannerImagesArr.append(response["metaData"]["images"][j].stringValue)
                    self.imagesWithUrlArr.append(URL(string: FILE_BASE_URL + response["metaData"]["images"][j].stringValue )!)
                }
                
                for k in 0..<response["variants"].count {
                    let itemId = response["variants"][k]["itemId"].stringValue
                    let actualPrice = response["variants"][k]["actualPrice"].stringValue
                    let discountedPrice = response["variants"][k]["discountedPrice"].stringValue
                    let discountValue = response["variants"][k]["discountValue"].stringValue
                    let variant = response["variants"][k]["variant"].stringValue
                    let minQuantity = response["variants"][k]["minQuantity"].stringValue
                    var isSelected = false
                    isSelected = k == 0 ? true : false
                    if !variant.isEmpty {
                        self.variantsArr.append(productVariantStruct.init(itemId: itemId, actualPrice: actualPrice, discountedPrice: discountedPrice, discountValue: discountValue, isSelected: isSelected, variant: variant, minQuantity: minQuantity))
                        self.variantsDuplicateArr.append(productVariantStruct.init(itemId: itemId, actualPrice: actualPrice, discountedPrice: discountedPrice, discountValue: discountValue, isSelected: false, variant: variant, minQuantity: minQuantity))
                        
                    }
                    
                }
                                
                let vendorDetails = vendorDetailsStruct(vendorName: vendorName, vendorStreetAddress: vstreetAddress, vendorCity: vCity, vendorCountry: vCountry, vendorState: vState, vendorEmailMobile: vEmailMobile, vendorCompanyName: vCompanyName, vendorImage: vImage, vendorRating: "", vendorId: vendorId, vendorEncryptedId: vEncryptedId, fcmKey: vfcmKey)
                                
                self.productDetails = categoryProductListStruct(currency: currency, description: description, productWeight: productWeight, category: category, stock: stock, vendorName: vendorName, productId: productID, itemId: itemID, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, rating: rating ?? "0.0", name: name, images: self.bannerImagesArr, actualPrice: actualPrice, wishlisted: wishlisted, orderable: orderable, returnPolicy: returnPolicy, vendorDetails: vendorDetails, socialMediaArr: self.socialMediaArr, ratingData: VendorRatingStruct.init(one: response["productRatingDetail"]["1"].intValue, two: response["productRatingDetail"]["2"].intValue, three: response["productRatingDetail"]["3"].intValue, four: response["productRatingDetail"]["4"].intValue, five: response["productRatingDetail"]["5"].intValue, total: response["productRatingDetail"]["Total"].intValue), shareUrl: shareUrl)
                                
//                self.ratingView.rating = Double(self.productDetails.rating)!
                
//
                self.setDetails()
                
            }) { (error) in
                hideAllProgressOnView(appDelegateInstance.window!)
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func setDetails() {
        self.productNameLbl.text = self.productDetails.name
        self.productDiscountedPriceLbl.text = "₦\(self.productDetails.discountedPrice)"
        self.productDescriptionLbl.text = self.productDetails.description
        self.returnPolicyLbl.text = self.productDetails.returnPolicy
        
        if self.productDetails.discountPercent == "0" {
            self.productActualPriceLbl.isHidden = true
            self.productDiscountPercentageLbl.isHidden = true
        } else {
            self.productDiscountPercentageLbl.isHidden = false
            self.productActualPriceLbl.isHidden = false
            self.productDiscountPercentageLbl.text = "\(self.productDetails.discountPercent)% OFF"
        }
        
//        self.productWeightLbl.isHidden = self.productDetails.productWeight == "0" ? true : false
        self.productWeightLbl.text = "\(self.productDetails.productWeight) Kg"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₦\(self.productDetails.actualPrice)")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.productActualPriceLbl.attributedText = attributeString
        
        if self.productDetails.wishlisted {
            self.wishlistBtn.setImage(UIImage(named: "wishlist_active"), for: .normal)
        } else {
            self.wishlistBtn.setImage(UIImage(named: "wishlist"), for: .normal)
        }

        self.ratingView.rating = Double(self.productDetails.rating)!
        self.ratingView.settings.updateOnTouch = false
        self.ratingView.settings.fillMode = .precise
        
        self.productRatingLbl.text = "(\(self.productDetails.rating))"
        self.vendorNameLbl.text = self.productDetails.vendorDetails.vendorName
        self.vendorDetailsLbl.text = "Address: \(self.productDetails.vendorDetails.vendorStreetAddress), \(self.productDetails.vendorDetails.vendorCity), \(self.productDetails.vendorDetails.vendorState), \(self.productDetails.vendorDetails.vendorCountry) | Email: \(self.productDetails.vendorDetails.vendorEmailMobile)"
        self.vendorImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(self.productDetails.vendorDetails.vendorImage)"), placeholderImage: UIImage(named: "loading"))
        setUpSocialMediaButtons()
        setUpVendorRatingGraph(self.productDetails.ratingData)
        if self.bannerImagesArr.count > 0 {
            DispatchQueue.main.async {
                self.bannerCollView.reloadData()
                self.bannerCollView.dataSource = self
                self.bannerCollView.delegate = self
                
            }
        }
        if self.variantsArr.count > 0 {
            DispatchQueue.main.async {
                self.mainDescViewTopConstraint.constant = 75.0
                self.variantStackView.isHidden = false
                self.variantCollView.isHidden = false
                self.variantCollView.reloadData()
                self.variantCollView.dataSource = self
                self.variantCollView.delegate = self
            }
        } else {
            self.mainDescViewTopConstraint.constant = 0.0
            self.variantStackView.isHidden = true
            self.variantCollView.isHidden = true
        }
        
    }
    
    func makeVariantHiglighted(_ higlightedIndex: Int) {
        self.variantsArr = self.variantsDuplicateArr
        var index = -1
        for items in self.variantsArr {
            index += 1
            var item = items as! productVariantStruct
            if index == higlightedIndex {
                item.isSelected = true
                variantsArr.remove(at: index)
                variantsArr.insert(item, at: index)
            }
            
            
        }
        self.variantCollView.reloadData()
    }
    
    func setUpSocialMediaButtons() {
        for i in 0..<self.productDetails.socialMediaArr.count {
            if self.productDetails.socialMediaArr[i].type == "facebook" {
                self.fbButton.isHidden = false
            }
            if self.productDetails.socialMediaArr[i].type == "instagram" {
                self.instaBtn.isHidden = false
            }
            if self.productDetails.socialMediaArr[i].type == "twitter" {
                self.twitterBtn.isHidden = false
            }
        }
    }
    
    func setUpVendorRatingGraph(_ ratingDic: VendorRatingStruct) {
        self.oneStarRatingLbl.text = "\(ratingDic.one)"
        if ratingDic.total == 0 {
            self.oneStarProgressView.progress = 0.0
            self.twoStarProgressView.progress = 0.0
            self.threeStarProgressView.progress = 0.0
            self.fourStarProgressView.progress = 0.0
            self.fiveStarProgressView.progress = 0.0
        } else {
            self.oneStarProgressView.progress = Float(ratingDic.one) / Float(ratingDic.total)
            self.twoStarProgressView.progress = Float(ratingDic.two) / Float(ratingDic.total)
            self.threeStarProgressView.progress = Float(ratingDic.three) / Float(ratingDic.total)
            self.fourStarProgressView.progress = Float(ratingDic.four) / Float(ratingDic.total)
            self.fiveStarProgressView.progress = Float(ratingDic.five) / Float(ratingDic.total)
        }
        
        self.twoStarRatingLbl.text = "\(ratingDic.two)"
        
        self.threeStarRatingLbl.text = "\(ratingDic.three)"
        
        self.fourStarRatingLbl.text = "\(ratingDic.four)"
        
        self.fiveStarRatingLbl.text = "\(ratingDic.five)"
        
    }
    
    func getSimilarProducts(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            let param:[String:String] = [:]

            let apiUrl = BASE_URL + PROJECT_URL.GET_SIMILAR_PRODUCTS + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString

            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.similarProductsArr.removeAll()
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        let variants = json["productList"][i]["variants"].arrayValue
                        var minQuantity = ""
                        if variants.count > 0 {
                            minQuantity = json["productList"][i]["variants"][0]["minQuantity"].stringValue
                        }
                        
                        self.similarProductsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, discountPercent: discountPercent, minQuantity: minQuantity))
                        
                    }

                    if self.similarProductsArr.count > 0 {
                        self.similarProductsCollectionView.isHidden = false
                        self.similarProductsLblHeight.constant = 20
                        self.similarProductsCollHeight.constant = 370
                        self.similarProductsTopConstraint.constant = 15
                        self.similarCollTopConstraint.constant = 15
                        self.similarProductsLbl.isHidden = false
//                        self.similarProductsEmptyView.isHidden = true
                    } else {
                        self.similarProductsCollectionView.isHidden = true
                        self.similarProductsLblHeight.constant = 0
                        self.similarProductsCollHeight.constant = 0
                        self.similarProductsTopConstraint.constant = 0
                        self.similarCollTopConstraint.constant = 0
                        self.similarProductsLbl.isHidden = true
//                        self.similarProductsEmptyView.isHidden = false
                    }

                    DispatchQueue.main.async {
                        self.similarProductsCollectionView.reloadData()
                    }

                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })

        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func getOtherProductsSoldByVendor(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            let param:[String:String] = [:]

            let apiUrl = BASE_URL + PROJECT_URL.GET_OTHERS_PRODUCTS_SOLD_BY_VENDOR + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString

            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.otherProductsSoldByVendorArr.removeAll()
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        let variants = json["productList"][i]["variants"].arrayValue
                        var minQuantity = ""
                        if variants.count > 0 {
                            minQuantity = json["productList"][i]["variants"][0]["minQuantity"].stringValue
                        }
                        
                        self.otherProductsSoldByVendorArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, discountPercent: discountPercent, minQuantity: minQuantity))
                        
                    }

                    if self.otherProductsSoldByVendorArr.count > 0 {
                        self.otherProductsCollView.isHidden = false
                        self.otherProductsLblHeight.constant = 20
                        self.otherProductsCollHeight.constant = 370
                        self.otherProductsTopConstraint.constant = 15
                        self.otherProductsCollTopConstraint.constant = 15
                        self.otherProductsLbl.isHidden = false
                    } else {
                        self.otherProductsCollView.isHidden = true
                        self.otherProductsLblHeight.constant = 0
                        self.otherProductsCollHeight.constant = 0
                        self.otherProductsTopConstraint.constant = 0
                        self.otherProductsCollTopConstraint.constant = 0
                        self.otherProductsLbl.isHidden = true

                    }

                    DispatchQueue.main.async {
                        self.otherProductsCollView.reloadData()
                    }

                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })

        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func getOnSaleProducts(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            let param:[String:String] = [:]

            let apiUrl = BASE_URL + PROJECT_URL.GET_ONSALE_PRODUCTS + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString

            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.onSaleProductsArr.removeAll()
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        let variants = json["productList"][i]["variants"].arrayValue
                        var minQuantity = ""
                        if variants.count > 0 {
                            minQuantity = json["productList"][i]["variants"][0]["minQuantity"].stringValue
                        }
                        
                        self.onSaleProductsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, discountPercent: discountPercent, minQuantity: minQuantity))
                        
                    }

                    if self.onSaleProductsArr.count > 0 {
                        self.onSaleCollView.isHidden = false
                        self.onSaleLblHeight.constant = 20
                        self.onSaleCollHeight.constant = 370
                        self.onSaleTopConstraint.constant = 15
                        self.onSaleCollTopConstraint.constant = 15
                        self.onSaleLbl.isHidden = false
                    } else {
                        self.onSaleCollView.isHidden = true
                        self.onSaleLblHeight.constant = 0
                        self.onSaleCollHeight.constant = 0
                        self.onSaleTopConstraint.constant = 0
                        self.onSaleCollTopConstraint.constant = 0
                        self.onSaleLbl.isHidden = true
                    }

                    DispatchQueue.main.async {
                        self.onSaleCollView.reloadData()
                    }

                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })

        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func getNewArrivalProducts(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            let param:[String:String] = [:]
            let apiUrl = BASE_URL + PROJECT_URL.NEW_ARRIVALS + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString

            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.newArrivalsArr.removeAll()
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        let variants = json["productList"][i]["variants"].arrayValue
                        var minQuantity = ""
                        if variants.count > 0 {
                            minQuantity = json["productList"][i]["variants"][0]["minQuantity"].stringValue
                        }
                        
                        self.newArrivalsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, discountPercent: discountPercent, minQuantity: minQuantity))
                        
                    }

                    if self.newArrivalsArr.count > 0 {
                        self.newArrivalCollView.isHidden = false
                        self.newArrivalsLblHeight.constant = 20
                        self.newArrivalsCollHeight.constant = 370
                        self.newArrivalsTopConstraint.constant = 15
                        self.newArrivalsCollTopConstraint.constant = 15
                        self.newArrivalsLbl.isHidden = false
                    } else {
                        self.newArrivalCollView.isHidden = true
                        self.newArrivalsLblHeight.constant = 0
                        self.newArrivalsCollHeight.constant = 0
                        self.newArrivalsTopConstraint.constant = 0
                        self.newArrivalsCollTopConstraint.constant = 0
                        self.newArrivalsLbl.isHidden = true
                    }

                    DispatchQueue.main.async {
                        self.newArrivalCollView.reloadData()
                    }

                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })

        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func isAvailableInCart(_ itemId: String) -> (Bool, Int) {
        var index = -1
        var isAvailble = false
        for items in globalCartItemsArr {
            index += 1
            let item  = items as! NSMutableDictionary
            if (item.value(forKey: "itemId") as! NSString) as String == itemId {
                isAvailble = true
                break
            }
        }
        return (isAvailble, index)
    }
    
    func getCartDetailOfUser(_ cartProductsInfo: SimilarProducts_Struct) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    globalCartProducts.removeAll()
                    globalCartItemsArr.removeAllObjects()
                    if json["metaData"]["items"].count > 0 {
                        for i in 0..<json["metaData"]["items"].count {
                            let productId =  json["metaData"]["items"][i]["productId"].stringValue
                            let itemId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let quantity =  json["metaData"]["items"][i]["quantity"].stringValue
                            let discountPercent =  json["metaData"]["items"][i]["discountValue"].stringValue
                            let name =  json["metaData"]["items"][i]["name"].stringValue
                            let price =  json["metaData"]["items"][i]["price"].stringValue
                            let stock =  json["metaData"]["items"][i]["stock"].stringValue
                            let discountedPrice =  json["metaData"]["items"][i]["discountedPrice"].stringValue
                            let currency =  json["metaData"]["items"][i]["currency"].stringValue
                            let vendorId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let description =  json["metaData"]["items"][i]["metaData"]["description"].stringValue
                            
                            var imgArr = [String]()
                            for j in 0..<json["metaData"]["items"][i]["metaData"]["images"].count {
                                
                                let file = json["metaData"]["items"][i]["metaData"]["images"][j].stringValue
                                imgArr.append(file)
                            }
                            
                            globalCartProducts.append(cartProductListStruct.init(currency: currency, description: description, stock: stock, productId: productId, itemId: itemId, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, name: name, quantity: quantity, imagesArr: imgArr, vendorId: vendorId))
                            
                            let itemDic: NSMutableDictionary = NSMutableDictionary()
                            itemDic.setValue(productId, forKey: "productId")
                            itemDic.setValue(quantity, forKey: "quantity")
                            itemDic.setValue(itemId, forKey: "itemId")
                            
                            globalCartItemsArr.add(itemDic)
                        }
                    }
                    
                    let isAvailable = self.isAvailableInCart(cartProductsInfo.itemId)
                    if isAvailable.0 {
                        let selectedProduct = globalCartItemsArr[isAvailable.1] as! NSMutableDictionary
                        let quantity = selectedProduct.value(forKey: "quantity") as! String
                        let updatedQuanity = Int(quantity)! + 1
                        
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue("\(updatedQuanity)", forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.removeObject(at: isAvailable.1)
                        globalCartItemsArr.insert(itemDic, at: isAvailable.1)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    } else {
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue(cartProductsInfo.minQuantity, forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.add(itemDic)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    }
                    
                    UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) != nil ? self.updateCartAPI() : self.saveCartApiCall()
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func getCartDetailOfUserFromMainAddToCart(_ cartProductsInfo: categoryProductListStruct) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    globalCartProducts.removeAll()
                    globalCartItemsArr.removeAllObjects()
                    if json["metaData"]["items"].count > 0 {
                        for i in 0..<json["metaData"]["items"].count {
                            let productId =  json["metaData"]["items"][i]["productId"].stringValue
                            let itemId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let quantity =  json["metaData"]["items"][i]["quantity"].stringValue
                            let discountPercent =  json["metaData"]["items"][i]["discountValue"].stringValue
                            let name =  json["metaData"]["items"][i]["name"].stringValue
                            let price =  json["metaData"]["items"][i]["price"].stringValue
                            let stock =  json["metaData"]["items"][i]["stock"].stringValue
                            let discountedPrice =  json["metaData"]["items"][i]["discountedPrice"].stringValue
                            let currency =  json["metaData"]["items"][i]["currency"].stringValue
                            let vendorId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let description =  json["metaData"]["items"][i]["metaData"]["description"].stringValue
                            let minQuantity = json["metaData"]["items"][i]["quantity"].stringValue
                            
                            var imgArr = [String]()
                            for j in 0..<json["metaData"]["items"][i]["metaData"]["images"].count {
                                
                                let file = json["metaData"]["items"][i]["metaData"]["images"][j].stringValue
                                imgArr.append(file)
                            }
                            
                            globalCartProducts.append(cartProductListStruct.init(currency: currency, description: description, stock: stock, productId: productId, itemId: itemId, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, name: name, quantity: quantity, imagesArr: imgArr, vendorId: vendorId, minQuantity: minQuantity))
                            
                            let itemDic: NSMutableDictionary = NSMutableDictionary()
                            itemDic.setValue(productId, forKey: "productId")
                            itemDic.setValue(quantity, forKey: "quantity")
                            itemDic.setValue(itemId, forKey: "itemId")
                            
                            globalCartItemsArr.add(itemDic)
                        }
                    }
                    
                    let isAvailable = self.isAvailableInCart(cartProductsInfo.itemId)
                    if isAvailable.0 {
                        let selectedProduct = globalCartItemsArr[isAvailable.1] as! NSMutableDictionary
                        let quantity = selectedProduct.value(forKey: "quantity") as! String
                        let updatedQuanity = Int(quantity)! + 1
                        let stock = Int(globalCartProducts[isAvailable.1].stock)!
                        if updatedQuanity > stock {
                            self.view.makeToast("Only \(stock) items available in stock.")
                            return
                        }
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue("\(updatedQuanity)", forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.removeObject(at: isAvailable.1)
                        globalCartItemsArr.insert(itemDic, at: isAvailable.1)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    } else {
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
//                        itemDic.setValue("1", forKey: "quantity")
                        itemDic.setValue(self.variantsArr[self.variantSelectedIndex].minQuantity, forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.add(itemDic)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    }
                    
                    UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) as! String != "" ? self.updateCartAPI() : self.saveCartApiCall()
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func getCartDetailOfUserFromMainAddToCartDuplicate(_ cartProductsInfo: SimilarProducts_Struct) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    globalCartProducts.removeAll()
                    globalCartItemsArr.removeAllObjects()
                    if json["metaData"]["items"].count > 0 {
                        for i in 0..<json["metaData"]["items"].count {
                            let productId =  json["metaData"]["items"][i]["productId"].stringValue
                            let itemId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let quantity =  json["metaData"]["items"][i]["quantity"].stringValue
                            let discountPercent =  json["metaData"]["items"][i]["discountValue"].stringValue
                            let name =  json["metaData"]["items"][i]["name"].stringValue
                            let price =  json["metaData"]["items"][i]["price"].stringValue
                            let stock =  json["metaData"]["items"][i]["stock"].stringValue
                            let discountedPrice =  json["metaData"]["items"][i]["discountedPrice"].stringValue
                            let currency =  json["metaData"]["items"][i]["currency"].stringValue
                            let vendorId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let description =  json["metaData"]["items"][i]["metaData"]["description"].stringValue
                            
                            var imgArr = [String]()
                            for j in 0..<json["metaData"]["items"][i]["metaData"]["images"].count {
                                
                                let file = json["metaData"]["items"][i]["metaData"]["images"][j].stringValue
                                imgArr.append(file)
                            }
                            
                            globalCartProducts.append(cartProductListStruct.init(currency: currency, description: description, stock: stock, productId: productId, itemId: itemId, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, name: name, quantity: quantity, imagesArr: imgArr, vendorId: vendorId))
                            
                            let itemDic: NSMutableDictionary = NSMutableDictionary()
                            itemDic.setValue(productId, forKey: "productId")
                            itemDic.setValue(quantity, forKey: "quantity")
                            itemDic.setValue(itemId, forKey: "itemId")
                            
                            globalCartItemsArr.add(itemDic)
                        }
                    }
                    
                    let isAvailable = self.isAvailableInCart(cartProductsInfo.itemId)
                    if isAvailable.0 {
                        let selectedProduct = globalCartItemsArr[isAvailable.1] as! NSMutableDictionary
                        let quantity = selectedProduct.value(forKey: "quantity") as! String
                        let updatedQuanity = Int(quantity)! + 1
                        let stock = Int(globalCartProducts[isAvailable.1].stock)!
                        if updatedQuanity > stock {
                            self.view.makeToast("Only \(stock) items available in stock.")
                            return
                        }
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue("\(updatedQuanity)", forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.removeObject(at: isAvailable.1)
                        globalCartItemsArr.insert(itemDic, at: isAvailable.1)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    } else {
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue(cartProductsInfo.minQuantity, forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.add(itemDic)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    }
                    
                    UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) as! String != "" ? self.updateCartAPI() : self.saveCartApiCall()
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func saveCartApiCall() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "metaData": self.finalItemDic]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_SAVE_CART, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
//                    self.udCartId = json["cartId"].stringValue
                    self.view.makeToast("Cart saved.")
//                    UserDefaults.standard.set(globalCartItemsArr.count, forKey: "cartCount")
                    UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                    let cartCount = ["userInfo": ["cartCount": globalCartItemsArr.count]]
                    NotificationCenter.default
                        .post(name:           NSNotification.Name("updateCartBadge"),
                              object: nil,
                              userInfo: cartCount)
                    self.finalItemDic.removeAllObjects()
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func updateCartAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            var  apiUrl =  BASE_URL + PROJECT_URL.USER_UPDATE_CART
            apiUrl = apiUrl + "\(String(describing: UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID)!))"
            
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:Any] = [ "metaData": self.finalItemDic]
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: urlStr as String, successBlock: { [self] (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
//                    UserDefaults.standard.set(globalCartItemsArr.count, forKey: "cartCount")
                    UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                    let cartCount = ["userInfo": ["cartCount": globalCartItemsArr.count]]
                    NotificationCenter.default
                        .post(name:           NSNotification.Name("updateCartBadge"),
                              object: nil,
                              userInfo: cartCount)
                    self.finalItemDic.removeAllObjects()
                    
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func wishlistAPI(_ itemId: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "itemId": itemId]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_ADD_TO_WISHLIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.view.makeToast("Product added to wishlist.")
                    self.wishlistBtn.setImage(UIImage.init(named: "wishlist_active"), for: .normal)
                                        
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }


    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }

    @IBAction func onClickSocialMedias(_ sender: UIButton) {
        let links = findSocialMediaLink()
        
        if sender.tag == 101 {
            guard let url = URL(string: links.0) else {
              return //be safe
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else if sender.tag == 102 {
            guard let url = URL(string: links.1) else {
              return //be safe
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            guard let url = URL(string: links.2) else {
              return //be safe
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func findSocialMediaLink() -> (String, String, String) {
        var fbLink = ""
        var twitterLink = ""
        var instaLink = ""
        
        for i in 0..<self.socialMediaArr.count {
            if self.socialMediaArr[i].type == "facebook" {
                fbLink = self.socialMediaArr[i].link
            }
            if self.socialMediaArr[i].type == "instagram" {
                twitterLink = self.socialMediaArr[i].link
            }
            if self.socialMediaArr[i].type == "twitter" {
                instaLink = self.socialMediaArr[i].link
            }
        }
        
        return (fbLink, twitterLink, instaLink)
    }
    
    @IBAction func onClickWishlist(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            self.wishlistAPI(self.productDetails.itemId)
        } else {
            self.view.makeToast("Hey, you need to login in order to add product to Wishlist.")
        }
        
    }
    
    @IBAction func onClickShare(_ sender: UIButton) {
        let productShareUrl = self.productDetails.shareUrl
        self.shareButton(Url: productShareUrl)
    }
    
    
    @IBAction func onClickVendor(_ sender: UIButton) {
        let vendorDetailVC = DIConfigurator.shared.getVendorDetailVC()
        let info = self.productDetails
        vendorDetailVC.vendorId = info.vendorDetails.vendorId
        vendorDetailVC.vendorEncryptedId = info.vendorDetails.vendorEncryptedId
        vendorDetailVC.fcmKey = info.vendorDetails.fcmKey
        vendorDetailVC.vendorName = info.vendorName
        self.navigationController?.pushViewController(vendorDetailVC, animated: true)
    }
    
    @objc func similarProductsAddBtnClicked(sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let info = self.similarProductsArr[sender.tag]
            
    //        self.getCartDetailOfUser(info)
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "ProductDetailVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    @objc func otherProductsAddBtnClicked(sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let info = self.otherProductsSoldByVendorArr[sender.tag]
            
    //        self.getCartDetailOfUser(info)
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "ProductDetailVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    @objc func newArrivalsAddBtnClicked(sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let info = self.newArrivalsArr[sender.tag]
            
    //        self.getCartDetailOfUser(info)
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "ProductDetailVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func onSaleProductsAddBtnClicked(sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let info = self.onSaleProductsArr[sender.tag]
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUser(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    @IBAction func onClickEnquiry(_ sender: UIButton) {
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kOnClickProductInquire)
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let vc = DIConfigurator.shared.getChatVC()
            let info = self.productDetails.vendorDetails
            if info.vendorEncryptedId != "" {
                vc.toId = info.vendorEncryptedId
    //            vc.fcmKey = self.fcmKey
                vc.fcmKey = info.fcmKey
                vc.vendorName = info.vendorName
                vc.isFromEnquiry = true
                vc.productName = self.productDetails.name
                UserDefaults.standard.set(info.vendorName, forKey: USER_DEFAULTS_KEYS.TO_LOGIN_NAME)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.view.makeToast("Vendor Encrypted Id is not available.")
            }
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func shareButton(Url: String) {
        let text = Url
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarProductsCollectionView {
            return similarProductsArr.count
        } else if collectionView == otherProductsCollView {
            return otherProductsSoldByVendorArr.count
        } else if collectionView == onSaleCollView {
            return onSaleProductsArr.count
        } else if collectionView == bannerCollView {
            return bannerImagesArr.count
        } else if collectionView == self.variantCollView {
            return self.variantsArr.count
        } else {
            return newArrivalsArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == similarProductsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell

            let info = self.similarProductsArr[indexPath.row]
            cell.cellLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"

            if info.discountPercent == "0" {
                cell.cellPercentageLbl.isHidden = true
            } else {
                cell.cellPercentageLbl.isHidden = false
                cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            }
            
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            cell.cellDeleteView.isHidden = true
            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.similarProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            return cell
            
        } else if collectionView == otherProductsCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell

            let info = self.otherProductsSoldByVendorArr[indexPath.row]
            cell.cellLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"
            if info.discountPercent == "0" {
                cell.cellPercentageLbl.isHidden = true
            } else {
                cell.cellPercentageLbl.isHidden = false
                cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            }
//            cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            cell.cellDeleteView.isHidden = true
            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.otherProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
        } else if collectionView == onSaleCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell
            
            let info = self.onSaleProductsArr[indexPath.row]
            cell.cellLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"
            if info.discountPercent == "0" {
                cell.cellPercentageLbl.isHidden = true
            } else {
                cell.cellPercentageLbl.isHidden = false
                cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            }
//            cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            cell.cellDeleteView.isHidden = true
            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.onSaleProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
        } else if collectionView == bannerCollView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollCell", for: indexPath) as! BannerCollCell
            if self.bannerImagesArr.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(self.bannerImagesArr[indexPath.row])"), placeholderImage: UIImage(named: "loading"))
            }
            return cell
            
        } else if collectionView == self.variantCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VariantCollCell", for: indexPath) as! VariantCollCell
            let info = self.variantsArr[indexPath.row]
            cell.cellHeadingLbl.text = "\(info.variant)"
            if info.discountValue == "0" {
                cell.cellDiscountLbl.isHidden = true
                cell.cellActualPriceLbl.isHidden = true
            } else {
                cell.cellDiscountLbl.isHidden = false
                cell.cellActualPriceLbl.isHidden = false
                cell.cellDiscountLbl.text = "\(info.discountValue)% OFF"
            }
//            cell.cellDiscountLbl.text = "\(info.discountValue)% Off"
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₦\(info.actualPrice)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.cellActualPriceLbl.attributedText = attributeString
//            cell.cellActualPriceLbl.text =
            cell.cellDiscountPriceLbl.text = "₦\(info.discountedPrice)"
            cell.cellView.borderColor = info.isSelected ? UIColor.green : UIColor.darkGray
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell
            
            let info = self.newArrivalsArr[indexPath.row]
            cell.cellLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"
            if info.discountPercent == "0" {
                cell.cellPercentageLbl.isHidden = true
            } else {
                cell.cellPercentageLbl.isHidden = false
                cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            }
//            cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            cell.cellDeleteView.isHidden = true
            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.newArrivalsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var info = SimilarProducts_Struct()
        let productDetailVC = DIConfigurator.shared.getProductDetailVC()
        
        if collectionView == similarProductsCollectionView {
            info = self.similarProductsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
            
        } else if collectionView == otherProductsCollView {
            info = self.otherProductsSoldByVendorArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
            
        } else if collectionView == onSaleCollView {
            info = self.onSaleProductsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
            
        } else if collectionView == newArrivalCollView {
            info = self.newArrivalsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
            
        } else if collectionView == bannerCollView {
            let contentDetailVC = DIConfigurator.shared.getImageViewerVC()
            contentDetailVC.imagesArr = self.imagesWithUrlArr
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
            
        } else if collectionView == variantCollView {
            self.variantSelectedIndex = indexPath.row
            let variantsInfo = self.variantsArr[indexPath.row]
            self.productDetails.itemId = variantsInfo.itemId
            self.productDetails.actualPrice = variantsInfo.actualPrice
            self.productDetails.discountedPrice = variantsInfo.discountedPrice
            self.productDetails.discountPercent = variantsInfo.discountValue
            self.makeVariantHiglighted(indexPath.row)
            
            DispatchQueue.main.async {
                
                self.productDiscountedPriceLbl.text = "₦\(self.productDetails.discountedPrice)"
                self.productDiscountPercentageLbl.text = "\(self.productDetails.discountPercent)% OFF"
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₦\(self.productDetails.actualPrice)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                self.productActualPriceLbl.attributedText = attributeString
            }
            
        }

    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 2
        if collectionView == self.bannerCollView {
            let collectionWidth = collectionView.bounds.width
            let collectionHeight = collectionView.bounds.height
            return CGSize(width: collectionWidth, height: collectionHeight)
        } else if collectionView == self.variantCollView {
            let collectionWidth = collectionView.bounds.width
            let collectionHeight = collectionView.bounds.height
            return CGSize(width: 130, height: collectionHeight)
        } else {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 370)
        }
        
    }
    
}
