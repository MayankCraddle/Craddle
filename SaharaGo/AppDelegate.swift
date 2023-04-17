//
//  AppDelegate.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 20/07/22.
//

import UIKit
import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift
import CoreData
import FBSDKCoreKit
import GoogleSignIn // 1 gs
import Paystack
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcmMessageIDKey"
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    weak var instanceForSocialLogin: UIViewController?
    var onClickAPICompletionClosure: APICompletionClosure?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        Paystack.setDefaultPublicKey("pk_test_1dfd4affcb0a1863c168a220cf8523d91c8ba7af")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        country = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as? String != nil ? UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String : ""
        UserDefaults.standard.set("rgba(0,131,78,1)", forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE)
        UserDefaults.standard.set("Nigeria", forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY)
        UserDefaults.standard.set("nigeria.png", forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG)
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarApperance = UITabBarAppearance()
            tabBarApperance.configureWithOpaqueBackground()
            tabBarApperance.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            countryColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
            UITabBar.appearance().standardAppearance = tabBarApperance
        }
        
        UserDefaults.standard.set("abc", forKey: "fcm_key")
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
//        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
//
//            let userStoryboard: UIStoryboard = UIStoryboard(name: "Buyer", bundle: nil)
//            let viewController = userStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
//            let rootNC = UINavigationController(rootViewController: viewController)
//            UIApplication.shared.delegate!.window!!.rootViewController = rootNC
//
//        } else {
//            let userStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController = userStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            let rootNC = UINavigationController(rootViewController: viewController)
//            UIApplication.shared.delegate!.window!!.rootViewController = rootNC
//        }
        let userStoryboard: UIStoryboard = UIStoryboard(name: "Buyer", bundle: nil)
        let viewController = userStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        let rootNC = UINavigationController(rootViewController: viewController)
        UIApplication.shared.delegate!.window!!.rootViewController = rootNC
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
                
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
          } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
          }

        
          application.registerForRemoteNotifications()
        
        
        // For FaceBook // 2 fb
         ApplicationDelegate.shared.application(
             application,
             didFinishLaunchingWithOptions:
                 launchOptions
         )
         // Google Sign In
         GIDSignIn.sharedInstance().clientID = "803247183253-nrf5aulivu6gsj1kg6vh1b87kn16bjjs.apps.googleusercontent.com"
         GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    // For FaceBook // 3 fb
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//      // If you are receiving a notification message while your app is in the background,
//      // this callback will not be fired till the user taps on the notification launching the application.
//      // TODO: Handle data of notification
//
//      // With swizzling disabled you must let Messaging know about the message, for Analytics
//      // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//      // Print message ID.
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }
//
//      // Print full message.
//      print(userInfo)
//    }

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//      // If you are receiving a notification message while your app is in the background,
//      // this callback will not be fired till the user taps on the notification launching the application.
//      // TODO: Handle data of notification
//
//      // With swizzling disabled you must let Messaging know about the message, for Analytics
//      // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//      // Print message ID.
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }
//
//      // Print full message.
//      print(userInfo)
//
//      completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    
    func showHome(_ from: UIViewController) {
        let vc = HomeVC.instantiateViewController(.Buyer)
        from.navigationController?.viewControllers = [vc]
        
    }
    
    func showBuyerHomeTab(_ from: UIViewController) {
        let vc = TabbarVC.instantiateViewController(.Buyer)
        from.navigationController?.viewControllers = [vc]
        
    }
    
    func showSellerHomeTab(_ from: UIViewController) {
        let vc = SellerTabBarVC.instantiateViewController(.Seller)
        from.navigationController?.viewControllers = [vc]
        
    }
    
    func showCountryScreen(_ from: UIViewController) {
        let vc = ChooseCountryVC.instantiateViewController(.Main)
        from.navigationController?.viewControllers = [vc]
        
    }
    
    func showSignupVC(_ from: UIViewController) {
        let vc = SignupVC.instantiateViewController(.Main)
        from.navigationController?.viewControllers = [vc]
        
    }
    
    func showVerifyOTPVC(_ from: UIViewController) {
        let vc = VerifyOTPVC.instantiateViewController(.Main)
        from.navigationController?.viewControllers = [vc]
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "SaharaGo")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        // MARK: - Core Data Saving support
        
    lazy var context = persistentContainer.viewContext
        func saveContext () {
//            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    

    
    func changeToString(value : Any?) -> String{
        if value == nil{return ""}
        if "\(value!)".lowercased() == "null" || "\(value!)".lowercased() == "<null>"{return ""}
        return "\(value!)"
    }

    
    
}
extension AppDelegate: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
//      let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile?.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
        let email = user.profile?.email
      // ...
        var dict = [String:Any]()
        dict["name"] = fullName
        dict["first_name"] = givenName
        dict["last_name"] = familyName
        dict["email"] = email
        dict["socialProviderUid"] = userId
        dict["socialProviderType"] = "google"
        print(dict)
        
        // call Api here
         hitSocialLoginAPI(socialData: dict)
    }
          
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}

extension AppDelegate{
        //MARK:- data from facebook
        func fetchDataFromFacebook(){
             let requestMe = GraphRequest.init(graphPath: "me", parameters: ["fields" : "id,name,first_name,last_name,email,picture.type(large)"])
             let connection = GraphRequestConnection()
            connection.add(requestMe, completionHandler: { (connectn, userresult, error) in
                 if let dictData: [String : Any] = userresult as? [String : Any] {
                     DispatchQueue.main.async {
                         if let pictureData: [String : Any] = dictData["picture"] as? [String : Any] {
                             if let data : [String: Any] = pictureData["data"] as? [String: Any] {

                                 print(data)
                                 print("**************************************\(dictData["id"]!)")
                                 print(dictData["name"] ?? "")
                                 print(dictData["email"] ?? "")
                                 print(data["url"] ?? "")

                                 var dict = dictData as? [String:Any] ?? [:]

                                 dict["facebookId"] = dict["id"]
                                 dict["name"] = dictData["name"]  ?? ""
                                 dict["email"] = dictData["email"] ?? ""
                                 dict["first_name"] = dictData["first_name"] ?? ""
                                 dict["last_name"] = dictData["last_name"] ?? ""
                                 dict["socialProviderUid"] = dict["id"] ?? ""
                                 dict["socialProviderType"] = "facebook"

                                 print(dict)
                                 //call API here
                                 self.hitSocialLoginAPI(socialData: dict)

                             }
                         }
                     }
                 }
             })
             connection.start()
 }
   
}

extension AppDelegate{
    
    //MARK:- Hit APIs
    func hitSocialLoginAPI(socialData: [String:Any]) {
        
        let socialType = changeToString(value: socialData["socialProviderType"])
        let socialId = changeToString(value: socialData["socialProviderUid"])
        
        var param = ["email"                          : changeToString(value: socialData["email"]).trim(),
                     "name"                           : changeToString(value: socialData["name"]),
                     "device_type"                    : "iOS",
                     "method"                        : "auth/login/social"
        ]
        print(param)
        //changeToString(value: socialData["method"]).trim()
        if socialType == "facebook"{
            param["facebookId"] = socialId
        }else if socialType == "google"{
            param["googleId"] = socialId
        }else if socialType == "apple"{
            param["appleId"] = socialId
        }
        
//        self.startButtonAnimation(socialType: socialType)
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                //                fcmKey = ""
                fcmKey = "abcdef"
            }

            let paramm:[String:Any] = ["email": changeToString(value: socialData["email"]).trim(),"mobile":"", "country":"", "lastName":changeToString(value: socialData["last_name"]), "firstName":changeToString(value: socialData["first_name"]), "fcmKey": fcmKey,"channel":"iOS"]
            print(paramm)
            ServerClass.sharedInstance.postRequestWithUrlParameters(paramm, path: BASE_URL + PROJECT_URL.USER_SOCIAL_LOGIN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["socialMediaLoggedIn"].boolValue, forKey: USER_DEFAULTS_KEYS.IS_SOCIAL_MEDIA_LOGGED_IN)
                    UserDefaults.standard.setValue(json["token"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    UserDefaults.standard.setValue(json["type"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_TYPE)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    UserDefaults.standard.setValue(json["encryptedId"].stringValue, forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                    UserDefaults.standard.setValue(json["name"].stringValue, forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
                    UserDefaults.standard.set(json["emailMobile"].stringValue, forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL)
                    if json["emailMobile"].stringValue.contains("@") {
                        UserDefaults.standard.set("yes", forKey: "isEmailSaved")
                    } else {
                        UserDefaults.standard.set("no", forKey: "isEmailSaved")
                    }
                    
                    UserDefaults.standard.set("rgba(0,131,78,1)", forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE)
                    UserDefaults.standard.set("Nigeria", forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY)
                    UserDefaults.standard.set("nigeria.png", forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG)
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        
                        self.getCartDetailOfUser()
                    }
                    
                    
                    let encryptedId = UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                                        
                    let userDict = [
                        "email": self.changeToString(value: socialData["email"]),
                        "name" : json["name"].stringValue,
                        "fcmKey" : UserDefaults.standard.object(forKey: "fcm_key") as! String
                    ]

                    Database.database().reference().child("users").child("\(encryptedId ?? "")").updateChildValues(userDict as [AnyHashable : Any])
                    UserDefaults.standard.set(nil, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
                    
                    if let vc = self.instanceForSocialLogin{
                        vc.navigationController?.popViewController(animated: true)
                    }
                }
                else {
//                    self.view.makeToast("\(json["message"].stringValue)")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })

        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }

        /////////////////???????????///////????????????/////////
        
//        ServiceController.instance.hitPostService(param, methodType: .post, unReachable: { [weak self] in
//            self?.stopButtonAnimation(socialType: socialType)
//
//        }) { [weak self] (response) in
//            print_debug(response)
//            guard let response = response else { return }
//            guard let self = self else { return }
//
//            self.stopButtonAnimation(socialType: socialType)
//
//            if changeToString(value: response[AppKey.kCode]) == RemoteConfigs.responseSuccess{
//                let data = getDictOn(key: "data", fromResponse: response)
//                let user = getDictOn(key: "user", fromResponse: data)
//                let token = changeToString(value: data[AppKey.kAuth_Token])
//                setDictUserDefault(user)
//                setUserDefault(AppKey.kAuth_Token, value: token)
//                setUserDefault(AppKey.kIs_Login, value: "1")
//
//                if socialType == "facebook"{
//                    AnalyticsUtil.instance.trackEvent("Login", sourceName: "Facebook")
//                }else if socialType == "google"{
//                    AnalyticsUtil.instance.trackEvent("Login", sourceName: "Google")
//                }else if socialType == "apple"{
//                    AnalyticsUtil.instance.trackEvent("Login", sourceName: "Apple")
//                }
//
//                if let vc = self.instanceForSocialLogin{
//                    self.showHome(vc)
//                }
//            }else{
//                self.instanceForSocialLogin?.showOkAlert(changeToString(value: response[AppKey.kMessage]))
//            }
//
//
//        }
    }
    
    func startButtonAnimation(socialType: String) {
        if let vc = self.instanceForSocialLogin as? LoginVC{
            if socialType == "facebook"{
           vc.btnFacebook.startAnimation()
            }else if socialType == "google"{
               vc.btnGoogle.startAnimation()
            }else if socialType == "apple"{
               vc.btnApple.startAnimation()
            }

        }else if let vc = self.instanceForSocialLogin as? SignupVC{
            if socialType == "facebook"{
             //vc.btnFacebook.startAnimation()
            }else if socialType == "google"{
               // vc.btnGoogle.startAnimation()
            }else if socialType == "apple"{
              //vc.btnApple.startAnimation()
            }

        }
    }
    
    func stopButtonAnimation(socialType: String) {
        if let vc = self.instanceForSocialLogin as? LoginVC{
            if socialType == "facebook"{
          vc.btnFacebook.stopAnimation()
            }else if socialType == "google"{
              vc.btnGoogle.stopAnimation()
            }else if socialType == "apple"{
              vc.btnApple.stopAnimation()
            }

        }else if let vc = self.instanceForSocialLogin as? SignupVC{
            if socialType == "facebook"{
              //vc.btnFacebook.stopAnimation()
            }else if socialType == "google"{
             //vc.btnGoogle.stopAnimation()
            }else if socialType == "apple"{
               //vc.btnApple.stopAnimation()
            }

        }
    }
    
    func getCartDetailOfUser() {
        if Reachability.isConnectedToNetwork() {
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                DispatchQueue.main.async {
                    print(json)
                }
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    globalCartProducts.removeAll()
                    if json["metaData"]["items"].count > 0 {
                        for i in 0..<json["metaData"]["items"].count {
                            let productId =  json["metaData"]["items"][i]["productId"].stringValue
                            let itemId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let quantity =  json["metaData"]["items"][i]["quantity"].stringValue
                            let discountPercent =  json["metaData"]["items"][i]["discountPercent"].stringValue
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

//                            UserDefaults.standard.set(globalCartProducts.count, forKey: "cartCount")
                            UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                        }
                        
                    }
                    self.onClickAPICompletionClosure?(true)
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
            })
            
        }else{
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
}





extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey: "fcm_key")
        let dataDict:[String: String] = ["token": fcmToken!]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
 
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound, .badge]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
