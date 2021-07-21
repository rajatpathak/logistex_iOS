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

var objUserModel = UserModel()

class UserModel: NSObject {
    
    var email = String()
    var fullName = String()
    var firstName = String()
    var lastName = String()
    var profile = String()
    var address = String()
    var contact = String()
    var userId = String()
    var role = Int()
    var averageRating = Int()
    var vehicleNo = String()
    var vehicleCat = String()
    var vehicleCatTitle = String()


    var licenseExpDate = String()
    var insuranceExpDate = String()
    var workStatus = Int()
    var currency = String()
    var driverCountry = String()
    var accountName = String()
    var bankName = String()
    var bankCode = String()
    var bankId = String()
    var accountNo = String()
    var currencyId = String()
    var categoryId = Int()
    var brandId = Int()
    var brandTitle = String()
    var colorId = Int()
    var colorTitle = String()
    var serviceTitle = String()
    var serviceTypeId = Int()
    var arrLicense = NSMutableArray()
    var arrIdCard = NSMutableArray()
    var arrRoadTax = NSMutableArray()
    var arrNumberPlate = NSMutableArray()
    var arrInsurance = NSMutableArray()
    var arrLicenseID = NSMutableArray()
    var arrIdCardID = NSMutableArray()
    var arrRoadTaxID = NSMutableArray()
    var arrNumberPlateID = NSMutableArray()
    var arrInsuranceID = NSMutableArray()
    var objAccepRequestModel = AccepRequestModel()
    
    var currentLocationTitle = String()
    
    func saveData(_ dict:NSDictionary) {
        email = dict["email"] as? String ?? ""
        fullName = dict["full_name"] as? String ?? ""
        firstName = dict["first_name"] as? String ?? ""
        lastName = dict["last_name"] as? String ?? ""
        profile = dict["profile_file"] as? String ?? ""
        address = dict["address"] as? String ?? ""
        contact = dict["contact_no"] as? String ?? ""
        averageRating = Proxy.shared.isValueInt(dict["averageRating"] as Any)
        userId = Proxy.shared.isValueString(dict["id"] as Any)
        role = Proxy.shared.isValueInt(dict["role_id"] as Any)
        workStatus = Proxy.shared.isValueInt(dict["work_status"] as Any)
        insuranceExpDate = dict["insurance_expiry_date"] as? String ?? ""
        licenseExpDate = dict["license_expiry_date"] as? String ?? ""
        currency = dict["currency"] as? String ?? ""
        driverCountry = dict["driver_country"] as? String ?? ""
        currencyId = Proxy.shared.isValueString(dict["currency_id"] as Any)
        serviceTitle = dict["vehicle_type"] as? String ?? ""

        if let vehicleDict = dict["vehicle"] as? NSDictionary {
            vehicleNo = vehicleDict["vehicle_number"] as? String ?? ""
            vehicleCat = Proxy.shared.isValueString(vehicleDict["type_id"] as Any)
            vehicleCatTitle = vehicleDict["category_name"] as? String ?? ""
            serviceTypeId = Proxy.shared.isValueInt(vehicleDict["service_type"] as Any)
            brandId = Proxy.shared.isValueInt(vehicleDict["brand_id"] as Any)
            colorId = Proxy.shared.isValueInt(vehicleDict["color_id"] as Any)
            brandTitle = vehicleDict["brand_name"] as? String ?? ""
            colorTitle = vehicleDict["color_name"] as? String ?? ""
            
        }
        if let bankDict = dict["bank_detail"] as? NSDictionary {
            bankName = bankDict["bank_name"] as? String ?? ""
            accountName = bankDict["account_name"] as? String ?? ""
            bankCode = bankDict["bank_code"] as? String ?? ""
            bankId = Proxy.shared.isValueString(bankDict["id"] as Any)
            accountNo = Proxy.shared.isValueString(bankDict["account_number"] as Any)
        }
        objAccepRequestModel.saveData(dict)
        arrLicense = []
        arrIdCard = []
        arrNumberPlate = []
        arrRoadTax = []
        arrInsurance = []
        if let arrFile = dict["files"] as? [NSDictionary] {
            for dict in arrFile {
                let type = Proxy.shared.isValueInt(dict["type_id"] as Any)
                switch type {
                case TypeImage.license.rawValue:
                    arrLicense.add(dict["file"] as? String ?? "")
                    arrLicenseID.add(dict["id"] as? Int ?? 0)
                case TypeImage.idCard.rawValue:
                    arrIdCard.add(dict["file"] as? String ?? "")
                    arrIdCardID.add(dict["id"] as? Int ?? 0)
                case TypeImage.roadTax.rawValue:
                    arrRoadTax.add(dict["file"] as? String ?? "")
                    arrRoadTaxID.add(dict["id"] as? Int ?? 0)
                case TypeImage.vehicleImage.rawValue:
                    arrNumberPlate.add(dict["file"] as? String ?? "")
                    arrNumberPlateID.add(dict["id"] as? Int ?? 0)
                case TypeImage.insurance.rawValue:
                    arrInsurance.add(dict["file"] as? String ?? "")
                    arrInsuranceID.add(dict["id"] as? Int ?? 0)
                default:
                    break
                }
            }
        }
    }
}
