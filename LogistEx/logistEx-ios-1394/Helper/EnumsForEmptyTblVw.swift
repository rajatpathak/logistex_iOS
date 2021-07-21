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
import EmptyStateKit

enum TableState: CustomState {
    
    case noNotifications
    case noBox
    case noCart
    case noFavorites
    case noLocation
    case noProfile
    case noSearch
    case noTags
    case noInternet
    case noIncome
    case inviteFriend
    case noPromoCode
    
    var image: UIImage? {
        switch self {
        case .noNotifications: return UIImage(named: "Messages")
        case .noBox: return UIImage(named: "Messages")
        case .noCart: return UIImage(named: "Messages")
        case .noFavorites: return UIImage(named: "Messages")
        case .noLocation: return UIImage(named: "Location")
        case .noProfile: return UIImage(named: "Profile")
        case .noSearch: return UIImage(named: "Search")
        case .noTags: return UIImage(named: "Tags")
        case .noInternet: return UIImage(named: "Internet")
        case .noIncome: return UIImage(named: "Income")
        case .inviteFriend: return UIImage(named: "Invite")
        case .noPromoCode: return UIImage(named: "ic_no_filmmaker")
        }
    }
    
    var title: String? {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String

        switch self {
        case .noNotifications: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noBookingFoundSpa : PassTitles.noBookingFound)"
            
        case .noBox: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noDataFoundSpa : PassTitles.noDataFound)"
            
        case .noCart: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noNotificationFoundSpa : PassTitles.noNotificationFound)"
            
        case .noFavorites: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noServiceFoundSpa : PassTitles.noServiceFound)"
          
        case .noLocation:  return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.whereAreYouSpa : PassTitles.whereAreYou)"
            
        case .noProfile: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noLoggedInSpa : PassTitles.noLoggedIn)"
            
        case .noSearch: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noResultSpa : PassTitles.noResult)"
            
        case .noTags: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noCollectionSpa : PassTitles.noCollection)"
          
        case .noInternet: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.weAreSorrySpa : PassTitles.weAreSorry)"
            
        case .noIncome: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noIncomeSpa : PassTitles.noIncome)"
           
        case .inviteFriend: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.askFriendSpa : PassTitles.askFriend)"
            
        case .noPromoCode: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noPromoCodeSpa : PassTitles.noPromoCode)"
            
        }
    }
    
    var description: String? {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String

        switch self {
        case .noNotifications: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.sorryDontHaveBookingSpa : PassTitles.sorryDontHaveBooking)"
            
        case .noBox: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.sorryDontHaveDataSpa : PassTitles.sorryDontHaveData)"
            
        case .noCart: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.sorryDontHaveNotificationSpa : PassTitles.sorryDontHaveNotification)"
            
        case .noFavorites: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.sorryDontHaveAnyDataSpa : PassTitles.sorryDontHaveAnyData)"
           
        case .noLocation: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.canFindLocationSpa : PassTitles.canFindLocation)"
            
        case .noProfile: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.pleaseRegisterOrLoginSpa : PassTitles.pleaseRegisterOrLogin)"
            
        case .noSearch: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.pleaseTryAnotherItemSpa : PassTitles.pleaseTryAnotherItem)"
            
        case .noTags: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.goToCollectSpa : PassTitles.goToCollect)"
        
        case .noInternet: return  "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.staffWorkingIssueSpa : PassTitles.staffWorkingIssue)"
            
            
        case .noIncome: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.youHaveNoPaymentSpa : PassTitles.youHaveNoPayment)"
            
        case .inviteFriend: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.youCouldBorrowNetworkSpa : PassTitles.youCouldBorrowNetwork)"
            
        case .noPromoCode: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.noPromoCodeSpa : PassTitles.noPromoCode)"
        }
    }
    
    var titleButton: String? {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String

        switch self {
        case .noNotifications: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.refershSpa : PassTitles.refersh)"
            
        case .noBox: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.refershSpa : PassTitles.refersh)"
            
        case .noCart: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.goBackSpa : PassTitles.goBack)"
            
        case .noFavorites: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.refershSpa : PassTitles.refersh)"
            
        case .noLocation: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.locateNowSpa : PassTitles.locateNow)"
            
        case .noProfile: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.loginInNowSpa : PassTitles.loginInNow)"
          
            
        case .noSearch: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.goBackSpa : PassTitles.goBack)"
            
        case .noTags: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.goShoppingSpa : PassTitles.goShopping)"
            
        case .noInternet: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.refershSpa : PassTitles.refersh)"
            
        case .noIncome: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.requestPaymentSpa : PassTitles.requestPayment)"
            
            
        case .inviteFriend: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.viewContactSpa : PassTitles.viewContact)"
            
        case .noPromoCode: return "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.refershSpa : PassTitles.refersh)"
        }
    }
}

