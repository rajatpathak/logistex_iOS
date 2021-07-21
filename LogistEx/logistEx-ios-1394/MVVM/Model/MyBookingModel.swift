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
class BookingModel{
    var driverId = Int()
    var categoryId = Int()

    var id = Int()
    var stateId = Int()
    var typeId = Int()
    var pickUpLocation = String()
    var dropLocation = String()
    var amount = Double()
    var changeRequestAmount = Double()
    var pickupLat = String()
    var pickupLong = String()
    var destLat = String()
    var destLong = String()
    var qualityRating = Double()
    var serviceRating = Double()
    var deliveryRating = Double()
    var averageRating = Double()
    var pickupDate = String()
    var deliveryTime = String()
    var paymentMethod = Int()
    var paymentStatus = Int()
    var isNagotiable = Int()
    var ratingComment = String()
    var driverName = String()
    var driverFirstName = String()
    var driverLastName = String()
    var vehicleNo = String()
    var vehicleBrand = String()
    var vehicleImgFile = String()
    var trackingIcon = String()
    var vehicleColor = String()
    var vehicleTypeTitle = String()

    var driverContact = String()
    var discountAmount = Double()
    var driverCurrency = String()
    var driverCurrencySymbol = String()
    
    var driverCountry = String()
    var driverProfile = String()
    var driverCurrencyId = Int()
    var vehicleType = Int()
    var currencyId = Int()
    var currency = String()
    var currencySymbol = String()
    var isChangeAmountRequest = Int()
    var isRated = false
    var signature = String()
    var driverCurrentState : DriverState?
    var arrAdditionalServiceModel = [AdditionalServiceModel]()
    
    // pervious driver variable
    var previousDriverId = Int()
    var previousDriverName = String()
    var previousDriverFirstName = String()
    var previousDriverLastName = String()
    var previousDriverContact = String()
    var previousDriverProfile = String()
    var previousDriverVehicleTypeTitle = String()
    var previousDriverVehicleNo = String()
    var previousDriverVehicleType = Int()
    var previousDriverVehicleBrand = String()
    var previousDriverVehicleColor = String()

    
    func setBookingDetail(dictData: Dictionary<String, AnyObject>){
        id = dictData["id"] as? Int ?? 0
        isChangeAmountRequest = dictData["amount_request"] as? Int ?? 0
        stateId = dictData["state_id"] as? Int ?? 0
        typeId = dictData["type_id"] as? Int ?? 0
        pickUpLocation = dictData["pickup_location"] as? String ?? ""
        dropLocation = dictData["destination_location"] as? String ?? ""
        pickupLat = dictData["pickup_latitude"] as? String ?? ""
        pickupLong = dictData["pickup_longitude"] as? String ?? ""
        destLat = dictData["destination_latitude"] as? String ?? ""
        destLong = dictData["destination_longitude"] as? String ?? ""
        amount = dictData.getValueIndouble(dictData["amount"] as AnyObject)
        changeRequestAmount = dictData.getValueIndouble(dictData["new_amount"] as AnyObject)
        discountAmount = dictData.getValueIndouble(dictData["discount_amount"] as AnyObject)
        paymentMethod = dictData.getValueInInt(dictData["payment_method"] as AnyObject)
        paymentStatus = dictData.getValueInInt(dictData["payment_status"] as AnyObject)
        isNagotiable = dictData.getValueInInt(dictData["is_negotiable"] as AnyObject)
        // convert date
        let pickupDateVal =  dictData["pickup_date"] as? String ?? ""
        pickupDate = Proxy.shared.UTCToLocal(UTCDateString: pickupDateVal)
        
        let deliverDate =  dictData["delivery_time"] as? String ?? ""
        deliveryTime = Proxy.shared.UTCToLocal(UTCDateString: deliverDate)
        
        signature = dictData["signature_file"] as? String ?? ""
        averageRating = dictData.getValueIndouble(dictData["driver_avg_rating"] as AnyObject)
        currency = dictData["currency"] as? String ?? ""
        currencySymbol = dictData["currency_symbol"] as? String ?? ""
        currencyId = dictData.getValueInInt(dictData["currency_id"] as AnyObject)
        vehicleImgFile = dictData["vehicle_image"] as? String ?? ""
        trackingIcon = dictData["tracking_icon_file"] as? String ?? ""

        if let driverRatingDict = dictData["driver_rating"] as? Dictionary<String, AnyObject> {
            ratingComment = driverRatingDict["comment"] as? String ?? ""
            qualityRating = driverRatingDict.getValueIndouble(driverRatingDict["quality_rating"] as AnyObject)
            deliveryRating = driverRatingDict.getValueIndouble(driverRatingDict["delivery_rating"] as AnyObject)
            serviceRating = driverRatingDict.getValueIndouble(driverRatingDict["service_rating"] as AnyObject)
            isRated = true
        } else {
            isRated = false
        }

        if let driverDict = dictData["driver"] as? Dictionary<String, AnyObject> {
            driverId = driverDict["id"] as? Int ?? 0
            categoryId = driverDict["category_id"] as? Int ?? 0
            driverFirstName =  driverDict["first_name"] as? String ?? ""
            driverLastName =  driverDict["last_name"] as? String ?? ""
            driverName = "\(driverFirstName) \(driverLastName)"
            driverContact = driverDict["contact_no"] as? String ?? ""
            driverProfile = driverDict["profile_file"] as? String ?? ""
            driverCurrency = driverDict["currency"] as? String ?? ""
            driverCurrencySymbol = dictData["currency_symbol"] as? String ?? ""

            driverCountry = driverDict["driver_country"] as? String ?? ""
            driverCurrencyId = driverDict.getValueInInt(driverDict["currency_id"] as AnyObject)
            vehicleTypeTitle = driverDict["vehicle_type"] as? String ?? ""
            
            if let vehicleDetail = driverDict["vehicle"] as? Dictionary<String, AnyObject> {
                vehicleNo = vehicleDetail["vehicle_number"] as? String ?? ""
                vehicleType = driverDict.getValueInInt(vehicleDetail["type_id"] as AnyObject)
                vehicleBrand = vehicleDetail["brand_name"] as? String ?? ""
                vehicleColor = vehicleDetail["color_name"] as? String ?? ""
            }
        }
        
        if let previousDriverDict = dictData["previous_driver"] as? Dictionary<String, AnyObject> {
            previousDriverId = previousDriverDict["id"] as? Int ?? 0
            previousDriverFirstName =  previousDriverDict["first_name"] as? String ?? ""
            previousDriverLastName =  previousDriverDict["last_name"] as? String ?? ""
            previousDriverName = "\(previousDriverFirstName) \(previousDriverLastName)"
            previousDriverContact = previousDriverDict["contact_no"] as? String ?? ""
            previousDriverProfile = previousDriverDict["profile_file"] as? String ?? ""
            previousDriverVehicleTypeTitle = previousDriverDict["vehicle_type"] as? String ?? ""
            
            if let vehicleDetail = previousDriverDict["vehicle"] as? Dictionary<String, AnyObject> {
                previousDriverVehicleNo = vehicleDetail["vehicle_number"] as? String ?? ""
                previousDriverVehicleType = previousDriverDict.getValueInInt(vehicleDetail["type_id"] as AnyObject)
                previousDriverVehicleBrand = vehicleDetail["brand_name"] as? String ?? ""
                previousDriverVehicleColor = vehicleDetail["color_name"] as? String ?? ""
            }
        }
        
        if let createdByDict = dictData["createdBy"] as? Dictionary<String, AnyObject> {
            objUserModel.setData(dictData: createdByDict)
        }
        let dState = dictData["is_favorite"] as? Int ?? 0
        switch dState {
        case DriverState.notSet.rawValue:
            driverCurrentState = .notSet
        case DriverState.favourite.rawValue:
            driverCurrentState = .favourite
        case DriverState.banned.rawValue:
            driverCurrentState = .banned
        default:
            break
        }
        
        if let arrServiceList = dictData["services"] as? [Dictionary<String, AnyObject>] {
            for dict in arrServiceList {
                arrAdditionalServiceModel.append(AdditionalServiceModel(fromDictionary: dict))                
            }
        }
    }
}
