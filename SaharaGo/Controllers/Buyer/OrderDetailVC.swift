//
//  OrderDetailVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 07/11/22.
//

import UIKit


struct OrderTrackDetailListStruct {
    var status:String = ""
    var updatedOn:String = ""
    var description:String = ""
}

class OrderDetailVC: UIViewController {
    
    var orderDetail = current_order_Address_main_struct()
    @IBOutlet weak var orderDetailListTableView: UITableView!
    var OrderTrackDetailListArr = [OrderTrackDetailListStruct]()
    var orderStatus = ""
    var rating = 0.00
    
    var shippingRate = ""
    var subTotal = ""
    var discount = ""
    var totalPrice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kOrderDetailScreen)
        
        
        getOrderTrackingStatusApi(orderID: orderDetail.orderId)
        getOrderDetailApi(orderID: orderDetail.orderId)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func writeReviewAction(_ sender: UIButton) {
        if orderDetail.cartMetaData[0].isRated {
            self.view.makeToast("You already rated this Product.")
            return
        }
        let viewAllVC = DIConfigurator.shared.getRatingsVC()
        viewAllVC.toId = orderDetail.cartMetaData[0].itemId as! String
        viewAllVC.isFrom = "Orders"
        viewAllVC.orderId = orderDetail.orderId
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    
    func getOrderTrackingStatusApi(orderID:String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            //guard let orderId = orderID else {return}
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.ORDER_TRACKING_STATUS_API + orderID, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.OrderTrackDetailListArr.removeAll()
                    for i in 0..<json["trackDetailList"].count {
                        let state = json["trackDetailList"][i]["state"].stringValue
                        let updatedOn = json["trackDetailList"][i]["updatedOn"].stringValue
                        
                        self.OrderTrackDetailListArr.append(OrderTrackDetailListStruct.init(status: state, updatedOn: updatedOn, description: ""))
                    }
                    self.orderDetailListTableView.reloadData()
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
    
    
    func getOrderDetailApi(orderID:String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            //guard let orderId = orderID else {return}
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_ORDER_DETAILS + orderID, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.shippingRate = json["shippingRate"].stringValue
                    self.subTotal = json["subTotal"].stringValue
                    self.discount = json["discount"].stringValue
                    self.totalPrice = json["totalPrice"].stringValue
                            
                    DispatchQueue.main.async {
                        self.orderDetailListTableView.reloadData()
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
    
    func giveRatingApiCall() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "fromId": UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_ID) as! String,"toId": orderDetail.cartMetaData[0].itemId as! String,"rating":self.rating, "review": "", "title": "", "orderId": orderDetail.orderId]
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GIVE_RATING, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    self.view.makeToast(json["message"].stringValue)
                    
                    
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                    // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
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
    
    @IBAction func viewProductAction(_ sender: UIButton) {
        let productDetailVC = DIConfigurator.shared.getProductDetailVC()
//        let info = globalCartProducts[indexPath.row]
        productDetailVC.itemID = self.orderDetail.cartMetaData[0].itemId
        productDetailVC.productID = self.orderDetail.cartMetaData[0].productId
//        productDetailVC.vendorID = self.orderDetail.cartMetaData[0].vendorId
        productDetailVC.vendorID = self.orderDetail.vendorId
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    @IBAction func onClickCancelAction(_ sender: UIButton) {
        let signUpVC = DIConfigurator.shared.getCancelOrderVC()
        signUpVC.orderDetail = self.orderDetail
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
}

extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
            cell.orderIdLbl.text = "Order Id #\(self.orderDetail.orderId)"
            if self.orderDetail.cartMetaData.count > 0 {
                cell.cellProductLbl.text =  self.orderDetail.cartMetaData[0].name
                cell.cellQuantityLbl.text = "Qty: \(self.orderDetail.cartMetaData[0].quantity)"
                cell.cellPriceLbl.text =  "₦\(self.orderDetail.totalPrice)"
                cell.cellSellerLbl.text = "Seller: \(self.orderDetail.vendorName)"
                //                cell.cellRatingView.rating = self.orderDetail.cartMetaData[0].userRating
                //                cell.cellRatingView.isUserInteractionEnabled = !self.orderDetail.cartMetaData[0].isRated
                
                if self.orderDetail.cartMetaData[0].metaData.images.count > 0 {
                    cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\( self.orderDetail.cartMetaData[0].metaData.images[0])"), placeholderImage: UIImage(named: "loading"))
                }
                cell.ratingView.settings.fillMode = .precise
                cell.ratingView.rating = 0.00
                
                cell.ratingView.didFinishTouchingCosmos = { rating in
                    
                    self.rating = rating
                    self.giveRatingApiCall()
                    
                }
                if orderDetail.orderState == "Delivered" && !orderDetail.cartMetaData[0].isRated {
                    cell.ratingStackView.isHidden = false
//                    cell.writeReviewStackView.isHidden = false
//                    cell.writeReviewBtn.setTitle("Write Review", for: .normal)
                    cell.writeReviewBtn.isUserInteractionEnabled = true
                } else if orderDetail.orderState == "Delivered" && orderDetail.cartMetaData[0].isRated {
                    cell.ratingStackView.isHidden = false
//                    cell.writeReviewStackView.isHidden = false
                    cell.ratingView.rating = Double(orderDetail.cartMetaData[0].userRating)
                    cell.ratingLbl.text = "You already rated this product."
                    cell.writeReviewBtn.isUserInteractionEnabled = false
//                    cell.writeReviewBtn.setTitle("Edit Review", for: .normal)
                } else {
                    cell.ratingStackView.isHidden = true
//                    cell.writeReviewStackView.isHidden = true
                }
                
                if orderDetail.orderState == "Payment_Completed" || orderDetail.orderState == "Confirmed" || orderDetail.orderState == "Packed" {
                    cell.cancelOrderStackView.isHidden = false
                } else {
                    cell.cancelOrderStackView.isHidden = true
                }
                
            }
            
            for i in 0..<self.OrderTrackDetailListArr.count {
                if self.OrderTrackDetailListArr[i].status == "Shipped" {
                    cell.orderShippedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderShippedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderPackedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderPackedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderShippedStatusDesLbl.text = getFormattedDateStr1(dateStr: self.OrderTrackDetailListArr[i].updatedOn, dateFormat: "MMM dd, yyyy hh:mm a")
                    
                } else if self.OrderTrackDetailListArr[i].status == "Confirmed" {
                    cell.orderConfirmedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedStatusDesLbl.text = getFormattedDateStr1(dateStr: self.OrderTrackDetailListArr[i].updatedOn, dateFormat: "MMM dd, yyyy hh:mm a")
                }  else if self.OrderTrackDetailListArr[i].status == "Packed" {
                    
                    cell.orderPackedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderPackedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    
                    cell.orderPackedStatusDesLbl.text = getFormattedDateStr1(dateStr: self.OrderTrackDetailListArr[i].updatedOn, dateFormat: "MMM dd, yyyy hh:mm a")
                } else if self.OrderTrackDetailListArr[i].status == "Delivered" {
                    cell.orderDeliveredDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderDeliveredTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderShippedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderShippedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderPackedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderPackedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedDotLbl.textColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    cell.orderConfirmedTrackLbl.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
                    
                    cell.orderDeliveredStatusDesLbl.text = getFormattedDateStr1(dateStr: self.OrderTrackDetailListArr[i].updatedOn, dateFormat: "MMM dd, yyyy hh:mm a")
                }
            }
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailShippingCell", for: indexPath) as! OrderDetailShippingCell
            cell.cellNameLbl.text = "\(self.orderDetail.firstName) \(self.orderDetail.lastName)"
            cell.cellAddressLbl.text = "\(self.orderDetail.streetAddress),\nMobile:  \(self.orderDetail.phone), \n\(self.orderDetail.state), \(self.orderDetail.city),\n\(self.orderDetail.country)"
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailPriceCell", for: indexPath) as! OrderDetailPriceCell
            cell.CellTotalPriceLbl.text = "₦\(self.totalPrice)"
            cell.cellItemTotalLbl.text = "₦\(self.subTotal)"
            cell.cellDeliveryLbl.text = "₦\(self.shippingRate)"
            cell.cellDiscountLbl.text = "₦\(self.discount)"
            cell.cellPaymentModeLbl.text = "Card: ₦\(self.orderDetail.totalPrice)"
            
            return cell
            
        }
    }
    
    
}
