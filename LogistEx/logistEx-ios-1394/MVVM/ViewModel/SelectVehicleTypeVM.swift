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
import GoogleMaps

class SelectVehicleTypeVM: NSObject {
    
    //MARK:- Variables
    var dropOffMarker = GMSMarker()
    var arrNearbyVehicleModel = [NearbyVehicleModel]()
    var currentPage = Int()
    var totalPage = Int()
    
    var distance = String()
    var amount = String()
    var selectedIndex = -1
    
    var objAdditionalServicesVM = AdditionalServicesVM()
    var selectedType = -1
   
    //MARK:- Get Notification List
    func getNearbyCars(success: @escaping()-> Void){
        
        let param = [
                     "type_id": KAppDelegate.bookPostDict.dictValue["Booking[service_type]"]!,
                      "latitude": KAppDelegate.bookPostDict.dictValue["Booking[pickup_latitude]"]!,
                      "longitude": KAppDelegate.bookPostDict.dictValue["Booking[pickup_longitude]"]!,
                      "destination_latitude": KAppDelegate.bookPostDict.dictValue["Booking[destination_latitude]"]!,
                      "destination_longitude": KAppDelegate.bookPostDict.dictValue["Booking[destination_longitude]"]!  ] as Dictionary<String,AnyObject>
        
        WebServiceProxy.shared.postData(urlStr: Apis.getNearbyCars, params: param, showIndicator: true) { response in
            
            self.distance = response?.data!.getValueInString(response?.data!["distance"] as AnyObject) as! String
            self.amount = response?.data!.getValueInString(response?.data!["amount"] as AnyObject)  as! String
            
            if let arrList = response?.data!["result"] as? [Dictionary<String, AnyObject>] {
                for dict in arrList{
                    let objNearbyVehicleModel = NearbyVehicleModel()
                    objNearbyVehicleModel.setNearbyVehicle(dictData: dict)
                    self.arrNearbyVehicleModel.append(objNearbyVehicleModel)
                }
            }
            success()
        }
    }
}

extension SelectVehicleTypeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objSelectVehicleTypeVM.arrNearbyVehicleModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectVehicleTypeCVC", for: indexPath) as! SelectVehicleTypeCVC
        
        let dictData = objSelectVehicleTypeVM.arrNearbyVehicleModel[indexPath.row]
        cell.titleVehicle.text = dictData.vehicleTitle
        if objSelectVehicleTypeVM.selectedIndex == indexPath.row {
             cell.imgVwVehicle.sd_setImage(with: URL(string: dictData.vehicleImg), placeholderImage: #imageLiteral(resourceName: "ic_taxi"))
            imgVwSelectedVehicle.image = cell.imgVwVehicle.image
        } else {
            cell.imgVwVehicle.sd_setImage(with: URL(string: dictData.vehicleImg), placeholderImage: #imageLiteral(resourceName: "ic_taxi"))
        }
        cell.lblMiles.text = dictData.distance + " \(PassTitles.miles.localized)"
        cell.lblTime.text = "\(dictData.time/60) \(PassTitles.min.localized)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        objSelectVehicleTypeVM.selectedIndex = (objSelectVehicleTypeVM.selectedIndex == indexPath.row) ? -1 : indexPath.row
        
        objSelectVehicleTypeVM.arrNearbyVehicleModel = []
        objSelectVehicleTypeVM.getNearbyCars {
            if self.objSelectVehicleTypeVM.selectedIndex > -1 && self.objSelectVehicleTypeVM.arrNearbyVehicleModel[indexPath.row].distance != "N/A" {
            KAppDelegate.bookPostDict.dictValue.updateValue("\(self.objSelectVehicleTypeVM.arrNearbyVehicleModel[self.objSelectVehicleTypeVM.selectedIndex].id)", forKey: "Booking[vehicle_type]")
                
                self.cnstHeightVwAdditional.constant = 65
                self.vwAdditionalDetails.isHidden = false
                self.cnstHeightBtnBookNow.constant = 44
                self.cnstHeightClcVw.constant = 0
                self.clcVwNearByVehicles.isHidden = true
                
                self.lblDistance.text =  self.objSelectVehicleTypeVM.distance.roundValuesUpto2Points(uptoPoints: 3) + " \(PassTitles.miles.localized)"
                let val = "\(KAppDelegate.bookPostDict.dictValue["Booking[amount]"] ?? "")"
                let currencyTitle = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_title]"] ?? "")"
                let currencySymbol = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_symbol]"] ?? "")"

                let valueString =  String(val)
                self.lblTotalCharges.text = "\(currencySymbol) \(valueString) \(currencyTitle)"
                self.lblAdditionalServices.text = "\(currencyTitle) 0.0"
                self.clcVwNearByVehicles.reloadData()
            } else {
                self.cnstHeightVwAdditional.constant = 0
                self.vwAdditionalDetails.isHidden = true
                self.cnstHeightBtnBookNow.constant = 0
                self.clcVwNearByVehicles.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size  = (collectionView.frame.size.width/3)
        return CGSize(width:size, height: 150)
    }
}


extension SelectVehicleTypeVC : AdditionalServicesDelegate {
    
    func setData(arrList: [AdditionalServicesModel]) {
        self.objSelectVehicleTypeVM.objAdditionalServicesVM.arrAdditionalServicesModel = arrList
        
        //  let indexOf =
        var finalPrice = 0.0
        KAppDelegate.bookPostDict.arrServiceId = []
        self.objSelectVehicleTypeVM.objAdditionalServicesVM.arrAdditionalServicesModel.filter {
            if $0.isSelected {
                finalPrice = finalPrice + Double($0.amount!)!
                KAppDelegate.bookPostDict.arrServiceId.append($0.id!)
            }
            return ($0.amount != nil)
        }
        let val = "\(KAppDelegate.bookPostDict.dictValue["Booking[amount]"] ?? "")"
        let valueDouble =  Double(val)
        let currencyTitle = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_tilte]"] ?? "")"
        lblAdditionalServices.text = "\(currencyTitle) \(finalPrice)"
        lblTotalCharges.text = "\(currencyTitle) \(Double(valueDouble!) + Double(finalPrice))"
    }
}
