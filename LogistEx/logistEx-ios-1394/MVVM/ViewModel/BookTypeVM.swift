//
/**
 *
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author     : Shiv Charan Panjeta < shiv@toxsl.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of ToXSL Technologies Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */

import UIKit
class BookTypeVM: NSObject {
    
    //MARK: Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrVehilcleListModel = [VehilcleListModel]()
    var isTypeServiceScreen = String()
    
    //MARK:- Hit Vehicle Type List Api
    func hitVehicleTypeListApi( _ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.vehicleTypeList)?page=\(currentPage)", showIndicator: true) { (response) in
            
            if response!.success {
                if self.currentPage == 0 {
                    self.arrVehilcleListModel = []
                }
                if let dictMeta = response?.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response?.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objVechicleTypeListModel = VehilcleListModel()
                        objVechicleTypeListModel.handleData(dict)
                        self.arrVehilcleListModel.append(objVechicleTypeListModel)
                    }
                }
                completion()
            }
        }
    }
}
extension BookTypeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if objBookTypeVM.isTypeServiceScreen == PassTitles.no {
            return 2
        } else {
            return objBookTypeVM.arrVehilcleListModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookTypeCVC", for: indexPath) as! BookTypeCVC
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        if objBookTypeVM.isTypeServiceScreen == PassTitles.no {
            if indexPath.row == 0 {
                cell.lblTypeTitle.text = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.scheduleSpa : PassTitles.schedule)"
                cell.imgVwType.image = UIImage(named: "ic_schedule_btn")
            } else {
                cell.lblTypeTitle.text = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.bookNowSpa : PassTitles.bookNow)"
                cell.imgVwType.image = UIImage(named: "ic_book_now_btn")
            }
        } else {
            let dict = objBookTypeVM.arrVehilcleListModel[indexPath.row]
            cell.lblTypeTitle.text = dict.title
            cell.imgVwType.sd_setImage(with: URL(string: dict.imgFile), placeholderImage: #imageLiteral(resourceName: "ic_transport"))
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if objBookTypeVM.isTypeServiceScreen == PassTitles.no {
             return CGSize(width: self.collVwTypleList.frame.width/2, height: 110)
        } else {
            return CGSize(width: self.collVwTypleList.frame.width/2-20, height: 110)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if Proxy.shared.accessTokenNil() == "" {
            objPassDataDelegate?.push(moveTo: "login")
            dismissController()
        } else {
            if objUserModel.currency == "" {
                Proxy.shared.displayStatusAlert(message: AlertTitle.addCurrency.localized, state: .warning)
            } else {
                let dict = objBookTypeVM.arrVehilcleListModel[indexPath.row]
                if objBookTypeVM.isTypeServiceScreen == PassTitles.yes{
                    let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
                    lblHeader.text = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.selectTypeOfBookingSpa : PassTitles.selectTypeOfBooking)"
                    objBookTypeVM.isTypeServiceScreen = PassTitles.no
                    collVwTypleList.reloadData()
                    KAppDelegate.bookPostDict.dictValue.updateValue("\(dict.id)", forKey: "Booking[service_type]")
                    KAppDelegate.bookPostDict.dictValue.updateValue("\(dict.title)", forKey: "Booking[service_type_title]")

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookTypeCVC", for: indexPath) as! BookTypeCVC
                    cell.vwBackground.backgroundColor = .red
                } else {
                   
                    if indexPath.row == 0 {
                        KAppDelegate.bookPostDict.dictValue.updateValue("\(BookingType.schedule.rawValue)", forKey: "Booking[type_id]")
                    } else {
                        KAppDelegate.bookPostDict.dictValue.updateValue("\(BookingType.bookNow.rawValue)", forKey: "Booking[type_id]")
                    }
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookTypeCVC", for: indexPath) as! BookTypeCVC
                    cell.vwBackground.backgroundColor = .red
                    presentVC(selectedStoryboard: .main, identifier: .descriptionBookNowVC)
                }
            }
        }
    }
}


extension BookTypeVC {
    
    //MARK:- Set Titles function
    func setTitles(){
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        lblHeader.text = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.selectTypeOfServiceSpa : PassTitles.selectTypeOfService)"
        objBookTypeVM.isTypeServiceScreen = PassTitles.yes
    }
}
