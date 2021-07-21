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
    
    var image: UIImage? {
        switch self {
        case .noNotifications: return UIImage(named: "Messages")
        case .noBox: return UIImage(named: "Box")
        case .noCart: return UIImage(named: "Cart")
        case .noFavorites: return UIImage(named: "Favorites")
        case .noLocation: return UIImage(named: "Location")
        case .noProfile: return UIImage(named: "Profile")
        case .noSearch: return UIImage(named: "Search")
        case .noTags: return UIImage(named: "Tags")
        case .noInternet: return UIImage(named: "Internet")
        case .noIncome: return UIImage(named: "Income")
        case .inviteFriend: return UIImage(named: "Invite")
        }
    }
    
    var title: String? {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        switch self {

        case .noNotifications: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.noNotificatoinSpa : TitleValue.noNotificatoin)"
            
        case .noBox: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.boxEmptySpa : TitleValue.boxEmpty)"
            
        case .noCart: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.cartEmptySpa : TitleValue.cartEmpty)"
            
        case .noFavorites: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.noFavouriteSpa : TitleValue.noFavourite)"
            
        case .noLocation:  return  "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.whereAreYouSpa : TitleValue.whereAreYou)"
            
        case .noProfile: return  "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.noLoggedInSpa : TitleValue.noLoggedIn)"
            
        case .noSearch: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.noResultSpa : TitleValue.noResult)"
            
        case .noTags: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.noCollectionSpa : TitleValue.noCollection)"
            
        case .noInternet: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.weAreSorrySpa : TitleValue.weAreSorry)"
            
        case .noIncome: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.noIncomeSpa : TitleValue.noIncome)"
            
        case .inviteFriend: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.askFriendSpa : TitleValue.askFriend)"
        }
    }
    
    var description: String? {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        switch self {
            
        case .noNotifications: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.sorryDontHaveNotificationSpa : TitleValue.sorryDontHaveNotification)"
           
        case .noBox: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.dontHaveEmailSpa : TitleValue.dontHaveEmail)"
            
        case .noCart: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.selectAlmostItemSpa : TitleValue.selectAlmostItem)"
            
        case .noFavorites: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.selectYourItemSpa : TitleValue.selectYourItem)"
            
        case .noLocation: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.canFindLocationSpa : TitleValue.canFindLocation)"
            
        case .noProfile: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pleaseRegisterOrLoginSpa : TitleValue.pleaseRegisterOrLogin)"
         
        case .noSearch: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pleaseTryAgainSpa : TitleValue.pleaseTryAgain)"
            
        case .noTags: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.goToCollectSpa : TitleValue.goToCollect)"
            
        case .noInternet: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.staffWorkingIssueSpa : TitleValue.staffWorkingIssue)"
            
        case .noIncome: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.youHaveNoPaymentSpa : TitleValue.youHaveNoPayment)"
            
        case .inviteFriend: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.youCouldBorrowNetworkSpa : TitleValue.youCouldBorrowNetwork)"
            
        }
    }
    
    var titleButton: String? {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String

        switch self {
        case .noNotifications: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.refershSpa : TitleValue.refersh)"
            
        case .noBox: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.searchAgainSpa : TitleValue.searchAgain)"
            
        case .noCart: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.goBackSpa : TitleValue.goBack)"
            
        case .noFavorites: return  "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.goBackSpa : TitleValue.goBack)"
            
        case .noLocation: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.locateNowSpa : TitleValue.locateNow)"
            
        case .noProfile: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.loginInNowSpa : TitleValue.loginInNow)"
            
        case .noSearch: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.refershSpa : TitleValue.refersh)"
            
        case .noTags: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.goShoppingSpa : TitleValue.goShopping)"
            
        case .noInternet: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.tryAgainSpa : TitleValue.tryAgain)"
           
            
        case .noIncome: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.requestPaymentSpa : TitleValue.requestPayment)"
            
        case .inviteFriend: return "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.viewContactSpa : TitleValue.viewContact)"
        }
    }
}
