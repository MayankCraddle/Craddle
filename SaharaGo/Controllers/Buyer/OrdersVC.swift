//
//  OrdersVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 07/11/22.
//

import UIKit

class OrdersVC: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var OrderHistoryArr = [current_order_Address_main_struct]()
    var cartDataArr = [current_order_cartData_struct]()
    
    var currentPageIndex: Int = 1
    var totalDataCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPageIndex = 1
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kViewOrdersScreen)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentPageIndex = 1
        self.getsOrderHistory()
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getsOrderHistory() {
        
        var  apiUrl =  BASE_URL + PROJECT_URL.USER_GET_ORDER_HISTORY
        apiUrl = apiUrl + "?pageNumber=\(currentPageIndex)&limit=50"
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_ORDER_HISTORY, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.totalDataCount = json["totalCount"].intValue
                    if self.currentPageIndex == 1 {
                        self.OrderHistoryArr.removeAll()
                    }
                    
                    self.cartDataArr.removeAll()
                    for i in 0..<json["orderList"].count {
                        let orderState = json["orderList"][i]["orderState"].stringValue
                        let shippingRate = json["orderList"][i]["shippingRate"].stringValue
                        let orderId = json["orderList"][i]["orderId"].stringValue
                        let createdOn = json["orderList"][i]["createdOn"].stringValue
                        let orderBy = json["orderList"][i]["orderBy"].stringValue
                        let totalPrice = json["orderList"][i]["totalPrice"].stringValue
                        let isRated = json["orderList"][i]["isRated"].boolValue
                        let userRating = json["orderList"][i]["rating"].doubleValue
                        let userReview = json["orderList"][i]["review"].stringValue
                        let vendorId = json["orderList"][i]["vendorId"].stringValue
                        
                        let firstName = json["orderList"][i]["addressMetaData"]["firstName"].stringValue
                        let lastName = json["orderList"][i]["addressMetaData"]["lastName"].stringValue
                        let phone = json["orderList"][i]["addressMetaData"]["phone"].stringValue
                        let streetAddress = json["orderList"][i]["addressMetaData"]["streetAddress"].stringValue
                        let city = json["orderList"][i]["addressMetaData"]["city"].stringValue
                        let state = json["orderList"][i]["addressMetaData"]["state"].stringValue
                        let country = json["orderList"][i]["addressMetaData"]["country"].stringValue
                        let zipcode = json["orderList"][i]["addressMetaData"]["zipcode"].stringValue
                        let landmark = json["orderList"][i]["addressMetaData"]["landmark"].stringValue
                        
                        let vendorFName = json["orderList"][i]["vendorMetadata"]["firstName"].stringValue
                        let vendorLName = json["orderList"][i]["vendorMetadata"]["lastName"].stringValue
                        
                        self.cartDataArr.removeAll()
                        
                        for j in 0..<json["orderList"][i]["cartMetaData"]["items"].count{
                            let name = json["orderList"][i]["cartMetaData"]["items"][j]["name"].stringValue
                            let itemId = json["orderList"][i]["cartMetaData"]["items"][j]["itemId"].stringValue
                            let vendorId = json["orderList"][i]["cartMetaData"]["items"][j]["vendorId"].stringValue
                            let stock = json["orderList"][i]["cartMetaData"]["items"][j]["stock"].stringValue
                            let price = json["orderList"][i]["cartMetaData"]["items"][j]["price"].stringValue
                            let totalPrice = json["orderList"][i]["cartMetaData"]["items"][j]["totalPrice"].stringValue
                            let currency = json["orderList"][i]["cartMetaData"]["items"][j]["currency"].stringValue
                            let discountPercent = json["orderList"][i]["cartMetaData"]["items"][j]["discountPercent"].stringValue
                            let productId = json["orderList"][i]["cartMetaData"]["items"][j]["productId"].stringValue
                            let discountedPrice = json["orderList"][i]["cartMetaData"]["items"][j]["discountedPrice"].stringValue
                            let quantity = json["orderList"][i]["cartMetaData"]["items"][j]["quantity"].stringValue
                            let images = json["orderList"][i]["cartMetaData"]["items"][j]["metaData"]["images"].arrayObject
                            let description = json["orderList"][i]["cartMetaData"]["items"][j]["metaData"]["description"].stringValue
                            let rating = json["orderList"][i]["cartMetaData"]["items"][j]["rating"].doubleValue
                            
                            self.cartDataArr.append(current_order_cartData_struct.init(itemId: itemId, vendorId: vendorId, productId: productId, price: price, discountedPrice: discountedPrice, name: name, currency: currency, quantity: quantity,discountPercent: discountPercent, stock: stock, totalPrice: totalPrice, isRated: isRated, metaData: current_order_metaData_struct.init(images: images ?? [], description: description), rating: rating, userRating: userRating, userReview: userReview))
                        }
                        
                        self.OrderHistoryArr.append(current_order_Address_main_struct.init(orderState: orderState, shippingRate: shippingRate, totalPrice: totalPrice, orderId: orderId, createdOn: createdOn, orderBy: orderBy, country: country, state: state, lastName: lastName, firstName: firstName, city: city, phone: phone, zipcode: zipcode, streetAddress: streetAddress, landmark: landmark, cartMetaData: self.cartDataArr, vendorName: "\(vendorFName) \(vendorLName)", vendorId: vendorId))
                    }
                    
                    DispatchQueue.main.async {
                        if self.OrderHistoryArr.count > 0 {
                            self.tableView.isHidden = false
                            self.emptyView.isHidden = true
                            self.tableView.reloadData()
                        } else {
                            self.tableView.isHidden = true
                            self.emptyView.isHidden = false
                        }
                        
                    }
                    
                    
                }
                else {
                    self.currentPageIndex = -1
                    self.OrderHistoryArr.removeAll()
                    
                    
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
    
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OrderHistoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = self.OrderHistoryArr[indexPath.row]
        if info.orderState == "Delivered" && info.cartMetaData[0].isRated {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDeliveredCell", for: indexPath) as! OrderDeliveredCell
            cell.cellDateLbl.text = getFormattedDateStr(dateStr: info.createdOn, dateFormat: "MMM dd, yyyy")
            if info.cartMetaData.count > 0 {
                cell.cellLbl.text = info.cartMetaData[0].name
//                cell.cellStatusLbl.text = "Delivered on 16 Oct"
                cell.ratingView.rating = Double(info.cartMetaData[0].userRating)
                cell.ratingView.isUserInteractionEnabled = false
                if info.cartMetaData[0].metaData.images.count > 0 {
                    cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.cartMetaData[0].metaData.images[0])"), placeholderImage: UIImage(named: "loading"))
                }
            }
            
            return cell
        } else if info.orderState == "Delivered" && !info.cartMetaData[0].isRated {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderRatingCell", for: indexPath) as! OrderRatingCell
            cell.cellDateLbl.text = getFormattedDateStr(dateStr: info.createdOn, dateFormat: "MMM dd, yyyy")
            cell.cellLbl.text = info.cartMetaData[0].name
//            cell.cellStatusLbl.text = "Delivered on 16 Oct"
            cell.ratingView.rating = Double(0)
            cell.ratingView.isUserInteractionEnabled = false
            if info.cartMetaData[0].metaData.images.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.cartMetaData[0].metaData.images[0])"), placeholderImage: UIImage(named: "loading"))
            }
            return cell
        } else if info.orderState == "Confirmed" || info.orderState == "Shipped" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProcessingCell", for: indexPath) as! OrderProcessingCell
            cell.cellDateLbl.text = getFormattedDateStr(dateStr: info.createdOn, dateFormat: "MMM dd, yyyy")
            if info.cartMetaData.count > 0 {
                cell.cellLbl.text = info.cartMetaData[0].name
                cell.cellStatusLbl.text = info.orderState
                if info.cartMetaData[0].metaData.images.count > 0 {
                    cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.cartMetaData[0].metaData.images[0])"), placeholderImage: UIImage(named: "loading"))
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCancelledCell", for: indexPath) as! OrderCancelledCell
            cell.cellDateLbl.text = getFormattedDateStr(dateStr: info.createdOn, dateFormat: "MMM dd, yyyy")
            if info.cartMetaData.count > 0 {
                cell.cellLbl.text = info.cartMetaData[0].name
                cell.cellStatusLbl.text = info.orderState
                if info.cartMetaData[0].metaData.images.count > 0 {
                    cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.cartMetaData[0].metaData.images[0])"), placeholderImage: UIImage(named: "loading"))
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerLoginVC = DIConfigurator.shared.getOrderDetailVC()
        sellerLoginVC.orderDetail = self.OrderHistoryArr[indexPath.row]
        self.navigationController?.pushViewController(sellerLoginVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (OrderHistoryArr.count - 1) {
            if (OrderHistoryArr.count < (totalDataCount ?? 0)) && (currentPageIndex != -1) {
                currentPageIndex = currentPageIndex + 1
                self.getsOrderHistory()
            }
        }
    }
}
