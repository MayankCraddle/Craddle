//
//  CategoriesTableCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 28/10/22.
//

import UIKit

class CategoriesTableCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cellDownArrowImg: UIImageView!
    @IBOutlet weak var subCatTblHeight: NSLayoutConstraint!
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var subCategoriesTable: UITableView!
    
    @IBOutlet weak var cellImg: UIImageView!
    var didselectClosure: DidSelectClosure?
//    var subcategoriesList: [categoryListStruct]! {
//        didSet {
//            subCategoriesTable.reloadData()
//        }
//    }
    var subcategoriesList: [SubCategory]! {
        didSet {
            subCategoriesTable.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subCategoriesTable.delegate = self
        subCategoriesTable.dataSource = self
        self.subCategoriesTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! UITableView) == self.subCategoriesTable {
          if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
              let newsize = newvalue as! CGSize
                subCatTblHeight.constant = newsize.height
            }
          }
        }
      }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subcategoriesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subcategoriesList[section].opened == true {
            //return tableViewData[section].sectionData.count
//            return subcategoriesList[section].subcategoriesList.count + 1
            return subcategoriesList[section].subCategories!.count + 1
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoriesTableCell", for: indexPath) as! SubCategoriesTableCell
            
            cell.cellLbl.text = subcategoriesList[indexPath.section].name
            if subcategoriesList[indexPath.section].isSubCategoryAvailable {
                cell.cellDownImg.isHidden = false
            } else {
                cell.cellDownImg.isHidden = true
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubSubCategoriesTableCell", for: indexPath) as! SubSubCategoriesTableCell
            
//            cell.cellLbl.text = subcategoriesList[indexPath.section].subcategoriesList[indexPath.row - 1].name
            cell.cellLbl.text = subcategoriesList[indexPath.section].subCategories![indexPath.row - 1].name
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < subcategoriesList.count {
            if subcategoriesList[indexPath.section].opened! {
                subcategoriesList[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                subCategoriesTable.reloadSections(sections, with: .none)
            } else {
                
                subcategoriesList[indexPath.section].opened = subcategoriesList[indexPath.section].isSubCategoryAvailable
                let sections = IndexSet.init(integer: indexPath.section)
                subCategoriesTable.reloadSections(sections, with: .none)
            }
            didselectClosure?(indexPath.section, indexPath.row - 1)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.subCatTblHeight.constant = subCategoriesTable.contentSize.height
    }

}
