//
//  TabbarVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/07/22.
//

import UIKit

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
//    var tabBarView: TabbarItemsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        addView()
       // self.tabBar.makeRoundCorner()
        //self.tabBar.tintColor = UIColor.red
//        if isProfileTab == "yes" {
//            self.selectedIndex = 4
//        } else if isLogin == "yes" {
//            self.selectedIndex = 0
//        }
    }
    
    
    override func viewDidLayoutSubviews() {
//        if UIDevice().userInterfaceIdiom == .phone{
//            var tabFrame = self.tabBar.frame
//            tabFrame.size.height = 0
//            tabFrame.origin.y = self.view.frame.size.height //- 10
//            self.tabBar.frame = tabFrame
//        }
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        
//        UITabBar.appearance().tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
//        self.tabBarController?.tabBar.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
                
    }
     
    
    
    
   /*
    func addView() {
//        let myview = UIView.fromNib(xibName: "TabbarItemsView") as! TabbarItemsView
        tabBarView = myview
        
        myview.instance = self
        myview.configView()
        
        var height:CGFloat = 80
        if UIDevice().userInterfaceIdiom == .phone{
            let screenHeight = UIScreen.main.nativeBounds.height
            print_debug("Height: \(screenHeight)")
            switch screenHeight{
            case 1136:
                height = 65 + 5
                print_debug("iPhone 5 or 5s or 5c")
            case 1334, 1920:
                height = 65 + 5
                print_debug("iPhone 6/6s/7/8/6+/6s+/7+")
            case 2208:
                height = 70 + 5
                print_debug("iPhone 8+")
            case 2436:
                height = 80 + 5
                print_debug("iPhone X")
            case 2688, 1792:
                height = 80 + 5
                print_debug("iPhone XR or XS")
            default:
                height = 80 + 5
                print_debug("unknown")
            }
        }
        
        myview.frame = CGRect.init(x: 0, y: self.view.frame.height-height, width: self.view.frame.width, height: height)
        self.view.addSubview(myview)
        
    }
    */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        if item.title == "Categories" {
            
        }
    }
//    
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        print("Selected view controller")
//    }

}
