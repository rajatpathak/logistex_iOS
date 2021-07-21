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

protocol CategoryDelegateProtocol {
    func sendCategoryData(id: Int, title:String)
}
var objCategoryDelegateProtocol: CategoryDelegateProtocol!

protocol FilterDelegateProtocol {
    func sendFilterData(id: Int, title: String)
}
var objFilterDelegateProtocol: FilterDelegateProtocol!

protocol PassDataDelegate {
    func push(moveTo:String)
}
var objPassDataDelegate:PassDataDelegate?

protocol AdditionalServicesDelegate {
    func setData(arrList: [AdditionalServicesModel])
}
var objAdditionalServicesDelegate: AdditionalServicesDelegate?

protocol PromoModelDelegate {
    func setData(dictData: PromocodeModel)
}
var objPromoModelDelegate : PromoModelDelegate?

protocol SearchDriverDelegate {
    func setData(orderId: String)
}
var objSearchDriverDelegate : SearchDriverDelegate?

 protocol TrackOrderDelegate {
    func push(orderId:Int, type: Int, title: String)

}
var objTrackOrderDelegate : TrackOrderDelegate?
