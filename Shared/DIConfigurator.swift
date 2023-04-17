//
//  DIConfigurator.swift
//  HomeFudd
//
//  Created by Ashish Chauhan on 29/03/19.
//

import Foundation
import UIKit

class DIConfigurator {
    static let shared = DIConfigurator()
    private init() {
        
    }
    
    func getViewControler(storyBoard: StoryboardType, indentifire: String) -> UIViewController {
        let storyB = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return storyB.instantiateViewController(withIdentifier: indentifire)
    }
    
    
    func getLoginVC() -> LoginVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "LoginVC") as? LoginVC {
            return viewC
        } else {
            fatalError("Not able to initialize LoginVC")
        }
    }
    
    func getSellerLoginVC() -> SellerLoginVC {
        if let viewC = self.getViewControler(storyBoard: .Seller, indentifire: "SellerLoginVC") as? SellerLoginVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerLoginVC")
        }
    }
    
    func getChangePasswordVC() -> ChangePasswordVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ChangePasswordVC") as? ChangePasswordVC {
            return viewC
        } else {
            fatalError("Not able to initialize LoginVC")
        }
    }
    
    func getDeactivateVC() -> DeactivateVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "DeactivateVC") as? DeactivateVC {
            return viewC
        } else {
            fatalError("Not able to initialize DeactivateVC")
        }
    }
    
    func getDeleteVC() -> DeleteVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "DeleteVC") as? DeleteVC {
            return viewC
        } else {
            fatalError("Not able to initialize DeleteVC")
        }
    }
    
    func getNotificationsVC() -> NotificationsVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "NotificationsVC") as? NotificationsVC {
            return viewC
        } else {
            fatalError("Not able to initialize NotificationsVC")
        }
    }
//
//    func getSignUpVC() -> SignUpVC {
//        if let viewC = self.getViewControler(storyBoard: .LoginSignup, indentifire: SignUpVC.className) as? SignUpVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize SignUpVC")
//        }
//    }
//
//    func getForgotPasswordVC() -> ForgotPasswordVC {
//        if let viewC = self.getViewControler(storyBoard: .LoginSignup, indentifire: ForgotPasswordVC.className) as? ForgotPasswordVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize ForgotPasswordVC")
//        }
//    }
//
//    func getFoodieMapVC() -> FoodieMapVC {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieMapVC.className) as? FoodieMapVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize FoodieMapVC")
//        }
//    }
//
    func getCatProductsVC() -> CatProductsVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "CatProductsVC") as? CatProductsVC {
            return viewC
        } else {
            fatalError("Not able to initialize CatProductsVC")
        }
    }
    
    func getSubCatVC() -> SubCatVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "SubCatVC") as? SubCatVC {
            return viewC
        } else {
            fatalError("Not able to initialize SubCatVC")
        }
    }
    
    func getProductsVC() -> ProductsVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ProductsVC") as? ProductsVC {
            return viewC
        } else {
            fatalError("Not able to initialize ProductsVC")
        }
    }
    
    func getContentDetailVC() -> BlogDetailVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "BlogDetailVC") as? BlogDetailVC {
            return viewC
        } else {
            fatalError("Not able to initialize ContentDetailVC")
        }
    }
    func getImageViewerVC() -> ImageViewerVC {
            if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ImageViewerVC") as? ImageViewerVC {
                return viewC
            } else {
                fatalError("Not able to initialize ImageViewerVC")
            }
        }
    
    func getChatVC() -> ChatVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ChatVC") as? ChatVC {
            return viewC
        } else {
            fatalError("Not able to initialize ChatVC")
        }
    }
    
    func getProductDetailVC() -> ProductDetailVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ProductDetailVC") as? ProductDetailVC {
            return viewC
        } else {
            fatalError("Not able to initialize ProductDetailVC")
        }
    }
    
    func getViewAllProductsVC() -> ViewAllProductsVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ViewAllProductsVC") as? ViewAllProductsVC {
            return viewC
        } else {
            fatalError("Not able to initialize ViewAllProductsVC")
        }
    }
    
    func getVendorListVC() -> VendorListVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "VendorListVC") as? VendorListVC {
            return viewC
        } else {
            fatalError("Not able to initialize VendorListVC")
        }
    }
    
    func getVendorDetailVC() -> VendorDetailVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "VendorDetailVC") as? VendorDetailVC {
            return viewC
        } else {
            fatalError("Not able to initialize VendorDetailVC")
        }
    }
    
    func getAddressVC() -> AddressVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "AddressVC") as? AddressVC {
            return viewC
        } else {
            fatalError("Not able to initialize AddressVC")
        }
    }
    
    func getAddAddressVC() -> AddAddressVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "AddAddressVC") as? AddAddressVC {
            return viewC
        } else {
            fatalError("Not able to initialize AddAddressVC")
        }
    }
    
    func getShowListVC() -> showListVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "showListVC") as? showListVC {
            return viewC
        } else {
            fatalError("Not able to initialize showListVC")
        }
    }
    
    func getEditProfileVC() -> EditProfileVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "EditProfileVC") as? EditProfileVC {
            return viewC
        } else {
            fatalError("Not able to initialize EditProfileVC")
        }
    }
    
    func getMediaVC() -> MediaVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "MediaVC") as? MediaVC {
            return viewC
        } else {
            fatalError("Not able to initialize MediaVC")
        }
    }
    
    func getCartVC() -> CartVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "CartVC") as? CartVC {
            return viewC
        } else {
            fatalError("Not able to initialize CartVC")
        }
    }
    
    func getChoosePaymentVC() -> ChoosePaymentVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ChoosePaymentVC") as? ChoosePaymentVC {
            return viewC
        } else {
            fatalError("Not able to initialize ChoosePaymentVC")
        }
    }
    
    func getWishlistVC() -> WishlistVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "WishlistVC") as? WishlistVC {
            return viewC
        } else {
            fatalError("Not able to initialize WishlistVC")
        }
    }
    
    func getPaystackVC() -> PaystackVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "PaystackVC") as? PaystackVC {
            return viewC
        } else {
            fatalError("Not able to initialize PaystackVC")
        }
    }
    
    func getSignUpVC() -> SignupVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "SignupVC") as? SignupVC {
            return viewC
        } else {
            fatalError("Not able to initialize SignupVC")
        }
    }
    
    func getCancelOrderVC() -> CancelOrderVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "CancelOrderVC") as? CancelOrderVC {
            return viewC
        } else {
            fatalError("Not able to initialize CancelOrderVC")
        }
    }
    
    func getVerifyOTPVC() -> VerifyOTPVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "VerifyOTPVC") as? VerifyOTPVC {
            return viewC
        } else {
            fatalError("Not able to initialize VerifyOTPVC")
        }
    }
    
    func getViewAllVC() -> ViewAllVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ViewAllVC") as? ViewAllVC {
            return viewC
        } else {
            fatalError("Not able to initialize ViewAllVC")
        }
    }
    
    func getViewCommentsVC() -> ViewCommentsVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ViewCommentsVC") as? ViewCommentsVC {
            return viewC
        } else {
            fatalError("Not able to initialize ViewCommentsVC")
        }
    }
    
    func getCategoriesNewVC() -> CategoriesNewVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "CategoriesNewVC") as? CategoriesNewVC {
            return viewC
        } else {
            fatalError("Not able to initialize CategoriesNewVC")
        }
    }
    
    func getFilterCatVC() -> FilterCatVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "FilterCatVC") as? FilterCatVC {
            return viewC
        } else {
            fatalError("Not able to initialize FilterCatVC")
        }
    }
    
    func getRatingsVC() -> RatingsVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "RatingsVC") as? RatingsVC {
            return viewC
        } else {
            fatalError("Not able to initialize RatingsVC")
        }
    }
    
    
    func getExploreVC() -> ExploreVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "ExploreVC") as? ExploreVC {
            return viewC
        } else {
            fatalError("Not able to initialize ExploreVC")
        }
    }
    
    func getAccountVC() -> AccountVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "AccountVC") as? AccountVC {
            return viewC
        } else {
            fatalError("Not able to initialize AccountVC")
        }
    }
    
    func getForgetPswrdVC() -> ForgetPasswordVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "ForgetPasswordVC") as? ForgetPasswordVC {
            return viewC
        } else {
            fatalError("Not able to initialize ForgetPasswordVC")
        }
    }
    
    func getSellerForgetPswrdVC() -> SellerForgetPswrdVC {
        if let viewC = self.getViewControler(storyBoard: .Seller, indentifire: "SellerForgetPswrdVC") as? SellerForgetPswrdVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerForgetPasswordVC")
        }
    }
    
    func getForgetPswrdOtpVC() -> ForgotPasswordOTPVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "ForgotPasswordOTPVC") as? ForgotPasswordOTPVC {
            return viewC
        } else {
            fatalError("Not able to initialize ForgotPasswordOTPVC")
        }
    }
    
    func getSellerForgetPswrdOtpVC() -> SellerForgetPswrdOtpVC {
        if let viewC = self.getViewControler(storyBoard: .Seller, indentifire: "SellerForgetPswrdOtpVC") as? SellerForgetPswrdOtpVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerForgetPswrdOtpVC")
        }
    }
    
    func getOrdersVC() -> OrdersVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "OrdersVC") as? OrdersVC {
            return viewC
        } else {
            fatalError("Not able to initialize OrdersVC")
        }
    }
    
    func getOrderDetailVC() -> OrderDetailVC {
        if let viewC = self.getViewControler(storyBoard: .Buyer, indentifire: "OrderDetailVC") as? OrderDetailVC {
            return viewC
        } else {
            fatalError("Not able to initialize OrderDetailVC")
        }
    }
//
//    func getChangePasswordVC() -> ChangePasswordVC {
//        if let viewC = self.getViewControler(storyBoard: .LoginSignup, indentifire: ChangePasswordVC.className) as? ChangePasswordVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize Home_hostVC")
//        }
//    }
//
//    func getAddressPickerViewController() -> AddressPickerViewController {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: AddressPickerViewController.className) as? AddressPickerViewController {
//            return viewC
//        } else {
//            fatalError("Not able to initialize Home_hostVC")
//        }
//    }
//
//    func getAboutUsVC() -> AboutUsVC {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: AboutUsVC.className) as? AboutUsVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize AboutUsVC")
//        }
//    }
//
//    func getContactUs() -> ContactUsVC {
//        if let viewC = self.getViewControler(storyBoard: .LoginSignup, indentifire: ContactUsVC.className) as? ContactUsVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize ContactUsVC")
//        }
//    }
//
//    func getHostSignupLikeDislikeVC() -> HostSignupLikeDislikeVC {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: HostSignupLikeDislikeVC.className) as? HostSignupLikeDislikeVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize Home_hostVC")
//        }
//    }
//
//    func getFoodieLikeDislikeViewController() -> FoodieLikeDislikeViewController {
//        if let viewC = self.getViewControler(storyBoard: .LoginSignup, indentifire: FoodieLikeDislikeViewController.className) as? FoodieLikeDislikeViewController {
//            return viewC
//        } else {
//            fatalError("Not able to initialize Home_hostVC")
//        }
//    }
//
//    func getResetCodeOTPPopupVC() -> ResetCodeOTPPopupVC {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: ResetCodeOTPPopupVC.className) as? ResetCodeOTPPopupVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize Home_hostVC")
//        }
//    }
//
//    func getMyBookingVC() -> MyBooking_HOSTVc {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: MyBooking_HOSTVc.className) as? MyBooking_HOSTVc {
//            return viewC
//        } else {
//            fatalError("Not able to initialize MyBooking_HOSTVc")
//        }
//    }
//
//    func getMyBookingDetailVC() -> BookingDetail_Vc_Host?{
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: BookingDetail_Vc_Host.className) as? BookingDetail_Vc_Host {
//            return viewC
//        } else {
//            fatalError("Not able to initialize MyBooking_HOSTVc")
//        }
//    }
//    func getFoodieMyOrderFinalVC() -> FoodieMyOrderFinalVC?{
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieMyOrderFinalVC.className) as? FoodieMyOrderFinalVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize MyBooking_HOSTVc")
//        }
//    }
//    func getFoodieScrollManagerVC() -> FoodieScrollManagerViewController {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieScrollManagerViewController.className) as? FoodieScrollManagerViewController {
//            return viewC
//        } else {
//            fatalError("Not able to initialize MyBooking_HOSTVc")
//        }
//    }
//
//    func getViewEditAccountDetailVC() -> ViewEditAccountDetailVC {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: ViewEditAccountDetailVC.className) as? ViewEditAccountDetailVC {
//            return viewC
//        } else {
//            fatalError("Not able to initialize MyBooking_HOSTVc")
//        }
//    }
//
//    //MARK: - ViewMenuDetailVC
//
//    func getViewMenuDetailVC() -> ViewMenuDetailVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: ViewMenuDetailVC.className) as? ViewMenuDetailVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - PaymentSelectionVC
//
//    func getPaymentSelectionVC() -> PaymentSelectionVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: PaymentSelectionVC.className) as? PaymentSelectionVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    func getAddMenuAfterBookingVC() -> AddMenuAfterBookingVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: AddMenuAfterBookingVC.className) as? AddMenuAfterBookingVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - FoodieBookNowVC
//
//    func getFoodieBookNowVC() -> FoodieBookNowVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieBookNowVC.className) as? FoodieBookNowVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//    //MARK: - FoodieOrderDetails
//
//    func getFoodieOrderDetails() -> FoodieMyOrderDetailsVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieMyOrderDetailsVC.className) as? FoodieMyOrderDetailsVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//    //MARK: - MenuItemDetailVC
//
//    func getMenuItemDetailVC() -> MenuItemDetailVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: MenuItemDetailVC.className) as? MenuItemDetailVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - ShowAddedMenuForBookingVC
//
//    func getShowAddedMenuForBookingVC() -> ShowAddedMenuForBookingVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: ShowAddedMenuForBookingVC.className) as? ShowAddedMenuForBookingVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - FoodieMyOrdersVC
//
//    func getFoodieMyOrdersVC() -> FoodieMyOrdersVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieMyOrdersVC.className) as? FoodieMyOrdersVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - FoodieCancelReservationListVC
//
//    func getFoodieCancelReservationListVC() -> FoodieCancelReservationListVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieCancelReservationListVC.className) as? FoodieCancelReservationListVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - CancelByChefVC
//
//    func getCancelByChefVC() -> CancelByChefVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: CancelByChefVC.className) as? CancelByChefVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - FoodieEditProfileVC
//
//    func getFoodieEditProfileVC() -> FoodieEditProfileVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FoodieEditProfileVC.className) as? FoodieEditProfileVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - FavouriteHostVC
//
//    func getFavouriteHostVC() -> FavouriteHostVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: FavouriteHostVC.className) as? FavouriteHostVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - NotificationsViewController
//
//    func getNotificationsViewController() -> NotificationsViewController? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: NotificationsViewController.className) as? NotificationsViewController {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - SettingsViewController
//
//    func getSettingsViewController() -> SettingsViewController? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: SettingsViewController.className) as? SettingsViewController {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - HostDescriptionFoodieSideVC
//
//    func getHostDescriptionFoodieSideView() -> HostDescriptionFoodieSideVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: HostDescriptionFoodieSideVC.className) as? HostDescriptionFoodieSideVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - ReportUserViewController
//
//    func getReportUserView() -> ReportUserViewController? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: ReportUserViewController.className) as? ReportUserViewController {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - MenuForFoodieVC
//
//    func getMenuForFoodieView() -> MenuForFoodieVC? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: MenuForFoodieVC.className) as? MenuForFoodieVC {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//    //MARK: - ReviewAndRatingViewController
//
//    func getReviewAndRatingView() -> ReviewAndRatingViewController? {
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: ReviewAndRatingViewController.className) as? ReviewAndRatingViewController {
//            return viewC
//        } else {
//            return nil
//        }
//    }
//
//   //MARK: - BookingDetail_PopUpVc_Host
//
//    func getBookingDetail_PopUpVc_Host() -> BookingDetail_PopUpVc_Host?{
//
//        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: BookingDetail_PopUpVc_Host.className) as?
//            BookingDetail_PopUpVc_Host{
//            return viewC
//        }else{
//            return nil
//        }
//    }
//
//    //MARK: - BookingDetail_PopUpVc_Cancel_Host
//
//     func getBookingDetail_PopUpVc_Cancel_Host() -> BookingDetail_PopUpVc_Cancel_Host?{
//
//         if let viewC = self.getViewControler(storyBoard: .Main, indentifire: BookingDetail_PopUpVc_Cancel_Host.className) as?
//             BookingDetail_PopUpVc_Cancel_Host{
//             return viewC
//         }else{
//             return nil
//         }
//     }


   //MARK: - HostWorkigDaysVC

//func getHostWorkingDaysVC() -> HostWorkingDaysVC?{
//    
//    if let viewC = self.getViewControler(storyBoard: .Main, indentifire: HostWorkingDaysVC.className) as?
//        HostWorkingDaysVC{
//        return viewC
//    }else{
//        return nil
//    }
// }
}

enum StoryboardType: String {
    
    case LaunchScreen
    case Main
    case Buyer
    case Seller
    
    var storyboardName: String {
        return rawValue
    }
}
