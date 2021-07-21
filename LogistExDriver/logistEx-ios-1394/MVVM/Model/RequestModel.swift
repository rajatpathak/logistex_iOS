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

struct LoginRequest {
    let name: String?
    let password: String?
    let role: String?
}

struct SignupRequest {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    let confirmPassword: String?
    let contact: String?
    let role: String?
    let vehicleType: String?
    let category: String?
    let brand: String?
    let color: String?
    let vehicleNo: String?
    let licenseExpDate: String?
    let insuranceExpDate: String?
    let currency: String?
    let profile: UIImage?
    let license: NSMutableArray?
    let numberPlate: NSMutableArray?
    let roadTax: NSMutableArray?
    let idCard: NSMutableArray?
    let insurance: NSMutableArray?
    let term: Bool?
}

struct ForgotRequest {
    let email: String?
    let role: String?
}

struct ContactUsRequest {
    let name: String?
    let email: String?
    let selectedReason: String?
    let message: String?
}


struct ChangePasswordRequest {
    let newPassword: String?
    let confirmPassword: String?
}

struct UpdateProfileRequest {
    let firstName: String?
    let lastName: String?
    let email: String?
    let contact: String?
    let role: String?
    let vehicleType: String?
    let category: String?
    let vehicleNo: String?
    let brand: String?
    let color: String?
    let licenseExpDate: String?
    let insuranceExpDate: String?
    let currency: String?
    let profile: UIImage?
    let license: NSMutableArray?
    let numberPlate: NSMutableArray?
    let roadTax: NSMutableArray?
    let idCard: NSMutableArray?
    let insurance: NSMutableArray?
}

struct FacebookRequest {
    let email: String?
    let name: String?
    let role: String?
    let userId: String?
    let provider: String?
}

struct AddRating {
    let comment: String?
    let rating: Float?
    let userId: String?
    let bookingId: String?
}

struct AddBankAccount {
    let accountName: String?
    let bankName: String?
    let accountNo: String?
    let bankCode: String?
}
