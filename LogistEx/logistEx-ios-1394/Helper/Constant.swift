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
enum AppInfo {
    static let mode = "development"
    static let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let userAgent = "\(mode)/\(appName)/\(version)/language/"
    static let zoomLevel : Float = 12.0
}
enum DeviceInfo {
    static let deviceType = "2"
    static let deviceName = UIDevice.current.name
    static let DeviceHeight = UIScreen.main.bounds.height
    static let DeviceWidth = UIScreen.main.bounds.width
    static let deviceToken = Proxy.shared.deviceToken()
}
struct ApiResponse {
    var success: Bool
    var jsonData: Data?
    var data: [String: AnyObject]?
    var message: String?
}
enum StoryBoardType : String {
    case main = "Main"
    var storyBoard : UIStoryboard {
        return  UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
enum AlertTitle {
    static let slotSelected = "Slot selected"
    static let editProfile = "Edit Profile"
    static let myProfile = "My Profile"
    static let success = "Success"
    static let error = "Error"
    static let setting = "Settings"
    static let cancel = "Cancel"
    static let locationProblem = "Location problem"
    static let unableToEncodeJson = "Error: Unable to encode JSON Response"
    static let sessionExpired = "Session expired"
    static let checkUrl =  "Please check the URL : 400"
    static let urlDoesntExit = "URL does not exists : 404"
    static let serverErrrorTryAgain = "Server error, Please try again.."
    static let deleteAlert = "Alert !"
    static let addCurrency = "addCurrency"
    static let pleaseEnterAmount = "enterAmount"
}
enum AlertMessages {
    static let black = "Black"
    static let white = "White"
    static let updateIosVersion = "updateIosVersion"
    static let enterMessage = "enterMessage"
    static let firstName = "enterFirstName"
    static let enterLastName = "enterLastName"
    static let enterFullName = "enterFullName"
    static let enterValidFullName = "enterValidFullName"
    static let cardNumber = "cardNumber"
    static let cardNumberValid = "cardNumberValid"
    static let expiryYear = "expiryYear"
    static let expiryYearValid = "expiryYearValid"
    static let cvv = "CVV"
    static let cvvValid = "cvvValid"

    static let cardDetailsInCorrect = "cardDetailsInCorrect"
    static let enterCardHolderName = "enterCardHolderName"
    static let enterSenderName = "enterSenderName"
    static let uploadPaymentScreenshot = "uploadPaymentScreenshot"


    static let enterValidCardHolderName = "enterValidCardHolderName"
    static let enterEmail = "enterEmail"
    static let enterValidEmail = "enterValidEmail"
    static let enterReason = "enterReason"
    static let selectReason = "chooseReason"
    static let enterPassword = "enterPassword"
    static let enterValidPassword = "Please enter valid password"
    static let enterConfirmPassword = "enterConfirmPassword"
    static let loginSuccess = "LoginSuccessfully"
    static let changeAmountAcceptSuccessfully = "Change amount request accepted successfully"
    static let paymentDoneSuccess = "Payment done successfully" // new

   
    static let paymentRequestApproval = "Payment request is send to admin for approval"
    static let changeAmountRejectSuccessfully = "Change amount request rejected successfully"
    static let enterPhoneNumber = "enterMobileNumber"
    static let paswrdLimit  = "enterPasswordLimit"
    static let doesNotMatch = "notMatch"
    static let changePassword = "passwordChange"
    static let cameraTitle = "Unable to access the Camera"
    static let cameraNotSupported = "Camera is not supported"
    static let mailSend = "enquirySubmitted"
    static let cameraGallery = "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app"
    static var canNotDetermineYourLocation = "Location services are not able to determine your location."
    static var locationServiceOff = "Location services are off."
    static var turnOnLocationServiceFromSetting = "To use this service efficiently, you must turn on location services from settings."
    static var reviewYourNetworkConnection = "Please review your network connection"
    static let loading = "Loading..."
    static let deletePhoto = "Delete photo"
    static let choosePhoto = "Choose photo"
    static let takePhoto = "Take photo"
    static let cancel = "Cancel"
    static let accept = "acceptRequest"
    static let reject = "rejectRequest"
    static let alert = "Alert"
    static let ok = "Ok"
    static let okSpa = "Okay"
    static let yes = "Yes"
    static let no = "No"
    static let camera = "Camera"
    static let galery = "Gallery"
    static let settings = "Settings"
    static let checkInternetConn = "Please check your internet connection"
    static let connectionProblem =  "Connection problem"
    static let reviewNetworkConn = "Please review your network settings"
    static let notImplemented = "Not implemented yet"
    static let enterDescprition = "enterDesc"
    static let selectDestination = "selectDestLocation"
    static let maxPhotoSelected = "imageLimit"
    static let bookingCancelled = "bookingCancelled"
    static let bookingDeleted = "bookingDeleted"
    static let assigningDriverShortly = "assignShortly"
    static let paymentPending = "paymentPending" //new

    static let alreadyRated = "rated"
    static let giveRating = "giveRating"
    static let phoneValidation = "enterVaildPhoneNo"
    static let selectPickup = "selectPickLocation"
    static let acceptTermsAndCondition = "acceptTermsCondition"
    static let pleaseAddRating = "addRating"
    static let unbannedToFavouriteDriver = "unbanDriver"
    static let unfavouriteTobanDriver = "unbanFavDriver"
    static let noReceiptAvailable = "noReceipt"
    static let drop = "drop"
    static let pickUp = "pickup"
    static let vehicleNumber = "vehicleNo"
    static let vehicleColor = "vehicleColor" // new
    static let vehicleBrand = "vehicleBrand" // new
    static let contactNumber = "contactNo"
    static let serviceType = "serviceType"
    static let selectDate = "selectDate"
    static let selectTime = "selectTime"
    static let driverDetailsNotAvailable = "notAvailable"
    static let amount = "amount"
    static let chooseCurrency = "chooseCurrency"
    static let selectCurrency = "selectCurrency"
}
enum PassTitles {
    static let taxiSpa = "Taxi"
    static let home = "home"
    static let faq = "FAQs"
    static let myProfile = "My Profile"
    static let myBookings = "myBooking"
    static let bookingAmountRequests = "bookingAmountRequest"
    static let manageDriver = "manageDriver"
    static let enterAddress = "enterAddress"
    static let notification = "notifications"
    static let aboutUs = "aboutUs"
    static let contactUs = "contactUs"
    static let userGuide = "userGuide"
    static let privacyPolicy = "privacyPolicy"
    static let termsAndCondition = "termsCondition"
    static let logOut = "loggedOut"
    static let login = "login"
    static let allOrders = "orders"
    static let assigning = "assign"
    static let driverAssigned = "driverAssign"
    static let onGoing = "going"
    static let completed = "complete"
    static let cancelled = "cancelled"
    static let setDropOffLoc = "setDropOffLocation"
    static let typeHere = "typeHere"
    static let typeYourMessage = "typeYourMessage"
    static let setPickUpLoc = "SetPickupLocation"
    static let dropOff = "dropOff"
    static let pickUP = "pickUP"
    static let dropAt = "dropAt"
    static let pickUpAt = "pickUpAt"
    static let miles = "mile"
    static let min = "min"
    static let assigned = "driverAssign"
    static let bookingCompleted = "bookingCompleted"
    static let progress = "driverMoving"
    static let picked = "packagePicked"
    static let cash = "Cash"
    static let selectPromoCode = "Select Promo Code"
    static let oderId = "orderID"
    static let english = "English"
    static let spanish = "Spanish"
    static let about = "aboutUs"
    static let privacy = "privacyPolicy"
    static let term = "termsCondition"
    static let orderNo = "orderNo"
    static let driverName = "driverName"
    static let pickupLocation = "pickupLocation"
    static let dropOffLocation = "dropOffLocation"
    static let onWay = "onTheWay"
    static let pickedUp = "pickedUp"
    static let time = "time"
    static let distance = "distance"
    static let minute = "minute"
    static let fromTrack = "fromTrack"
    static let cancelDriver = "cancelDriver"
    static let fromHome = "fromHome"
    static let accepted = "requestAccept"
    static let refersh = "Refresh"
    static let refershSpa = "Actualizar"
    static let noDataFound = "No data found"
    static let noDataFoundSpa = "No se encontró reserva"
    static let noBookingFound = "No booking found"
    static let noBookingFoundSpa = "No se encontró ninguna reserva"
    static let noNotificationFound = "No notifications found"
    static let noNotificationFoundSpa = "No se encontraron notificaciones"
    static let noServiceFound =  "No services found"
    static let noServiceFoundSpa =  "No se encontraron servicios"
    static let whereAreYou =  "Where are you?"
    static let whereAreYouSpa =  "¿Dónde estás?"
    static let noLoggedIn = "Not logged In"
    static let noLoggedInSpa =  "Sin iniciar sesión"
    static let noResult = "No results"
    static let noResultSpa = "No hay resultados"
    static let noCollection =  "No collections"
    static let noCollectionSpa =  "Sin colecciones"
    static let weAreSorry =  "We’re Sorry"
    static let weAreSorrySpa =  "Lo sentimos"
    static let noIncome =  "No income"
    static let noIncomeSpa =  "Sin ingresos"
    static let askFriend =  "Ask friend!"
    static let askFriendSpa =  "¡Preguntar a un amigo!"
    static let noPromoCode =   "No promo code found"
    static let noPromoCodeSpa =  "No se encontró ningún código de promoción"
    static let goBack =  "Go back"
    static let goBackSpa =   "Regresa"
    static let locateNow =  "Locate now!"
    static let locateNowSpa =  "¡Localiza ahora!"
    static let goShopping =   "Go shopping"
    static let goShoppingSpa =  "Ir de compras"
    static let loginInNow =   "Log in now!"
    static let loginInNowSpa =  "¡Inicia sesión ahora!"
    static let requestPayment =    "Request payment"
    static let requestPaymentSpa =  "Solicitar pago"
    static let viewContact =    "View contact"
    static let viewContactSpa =  "Ver contacto"
    static let sorryDontHaveData = "Sorry, you dont have any data!"
    static let sorryDontHaveDataSpa = "Lo sentimos, ¡no tienes ningún dato!"
    static let sorryDontHaveBooking = "Sorry, you don't have any booking. Please come back later!"
    static let sorryDontHaveBookingSpa = "Lo siento, no tienes ninguna reserva. ¡Vuelve más tarde!"
    static let sorryDontHaveNotification = "Sorry, you don't have any notifications. Please come back later!"
    static let sorryDontHaveNotificationSpa = "Lo siento, no tienes notificaciones. ¡Vuelve más tarde!"
    static let sorryDontHaveAnyData =  "Sorry, you dont have any data!"
    static let sorryDontHaveAnyDataSpa = "¡Lo siento, no tienes ningún dato!"
    static let canFindLocation =  "We can't find your location"
    static let canFindLocationSpa = "No podemos encontrar tu ubicación"
    static let pleaseRegisterOrLogin =  "Please register or log in first"
    static let pleaseRegisterOrLoginSpa = "Por favor regístrese o inicie sesión primero"
    static let pleaseTryAnotherItem =  "Please try another search item"
    static let pleaseTryAnotherItemSpa = "Intente con otro elemento de búsqueda"
    static let goToCollect =   "Go to collect favorites products"
    static let goToCollectSpa = "Ir a recopilar productos favoritos"
    static let youCouldBorrowNetwork =   "You could borrow money from your network"
    static let youCouldBorrowNetworkSpa = "Podrías pedir prestado dinero a tu red"
    static let youHaveNoPayment =   "You have no payment so contact your client"
    static let youHaveNoPaymentSpa = "No tiene pago, comuníquese con su cliente"
    static let staffWorkingIssue =  "Our staff is still working on the issue for better experience"
    static let staffWorkingIssueSpa = "Nuestro personal todavía está trabajando en el tema para una mejor experiencia"
    static let cancelBooking = "Are you sure you want to cancel this booking?"
    static let cancelBookingSpa = "¿Estás segura de que deseas cancelar esta reserva?"
    static let yes = "Yes"
    static let yesSpa = "si"
    static let cancelBtn = "Cancel"
    static let cancelBtnSpa = "Cancelar"
    static let cashTitle = "Cash"
    static let cashTitleSpa = "Efectivo"
    static let cardTitle = "Card" // new
    static let cardTitleSpa = "Tarjeta" // new
    static let bankTransferTitlte = "Bank Transfer" // new
    static let bankTransferTitlteSpa = "Transferencia bancaria" // new
    static let paypalTitle = "Paypal" // new
    static let paypalTitleSpa = "Paypal" // new
    static let selectTypeOfService = "Select type of Service"
    static let selectTypeOfServiceSpa = "Seleccionar tipo de servicio"
    static let transpor = "Transport"
    static let transporSpa = "Transporte"
    static let taxi = "Taxi"
    static let selectTypeOfBooking = "Select type of Booking"
    static let selectTypeOfBookingSpa = "Seleccionar tipo de reserva"
    static let schedule = "Schedule"
    static let scheduleSpa = "Calendario"
    static let bookNow = "Book Now"
    static let bookNowSpa = "Reservar ahora"
    static let confirmBooking = "Confirm Booking"
    static let confirmBookingSpa = "Reserva confirmada"
    static let register = "Register"
    static let registerSpa = "Registrarse"
    static let amountRequested = "Amount Requested -"
    static let amountRequestedSpa = "Monto Solicitado -"
    static let amountSuggested = "Amount Suggested -"
    static let amountSuggestedSpa = "Monto Sugerido -"
    static let negotiable = "Negotiable ?"
    static let negotiableSpa = "Negociable?"
    static let willingPay = "How much are you willing to pay?"
    static let willingPaySpa = "Cuanto desea pagar?"
    static let rateChanges = "Rate Changes"
    static let rateChangesSpa = "Cambios de Tarifa"
    static let enterAmount = "Enter Amount"
    static let enterAmountSpa = "Introduzca el Monto"
    static let no = "No"
    static let total = "Total :" // new
    static let totalSpa = "Total :" // new

}

enum PlaceHolderText {
    static let fullName = "Full Name"
    static let zipCode = "Pin Code"
    static let country = "Country"
    static let email = "Email address"
    static let contact = "Contact Number"
    static let dateOfBirth = "Date of Birth"
    static let aboutMe = "About me"
}
enum ApiKey {
    static let googleClientId = "135699466832-qa2430rvjabmg9qhci09t8lijt1rce6v.apps.googleusercontent.com"
    static let googleMapsPlacesApi = "AIzaSyBwLGYDJ4ZO3C9NYKg4tOc2sIyKWp37Eqo"
    static let stripePublishKey = "pk_test_x9U3SZNP6lQwDs6wVoWXVBHn"
}

enum Apis {
    static var serverUrl: String{
        #if DEBUG
         //return "http://192.168.2.130/logistex-yii2-1394/api/" //Local Server Url
        return "https://app.logist-ex.com/api/" // Live Server Url
        //return "https://demo3.toxsl.in/logistex/api/" // Demo Server Url

        #else
        //return "http://192.168.2.130/logistex-yii2-1394/api/" //Local Server Url
       return "https://app.logist-ex.com/api/" // Live Server Url
       //return "https://demo3.toxsl.in/logistex/api/" // Demo Server Url

        #endif
    }
    static let countryList = "user/currency-list"
    static let isUserSessionValid = "user/check"
    static let signUp = "user/signup"
    static let signIn = "user/login"
    static let socialLogin = "user/social-login"
    static let forgotPassword = "user/recover"
    static let logout = "user/logout"
    static let changePassword = "user/change-password"
    static let updateProfile = "user/update"
    static let contactUs = "user/contact-us"
    static let selectReason = "user/reason-list"
    static let pageType = "user/page"
    static let notificationList = "request/notification-list"
    static let bookingDetail = "booking/details"
    static let bookingList = "booking/list"
    static let faqList = "user/faq"
    static let googleAddress = "https://maps.googleapis.com/maps/api/"
    //static let getNearbyCars = "booking/get-nearby-cars"
    static let getNearbyCars = "booking/get-nearby-new-cars"
    static let serviceList = "service/list"
    static let promoCodeList = "booking/promo-code-list"
    static let applyPromoCode = "booking/apply-code"
    static let driverList = "user/get-drivers-list"
    static let driverUnfav = "user/favourite"
    static let makeBooking = "booking/add"
    static let cancelBooking = "booking/cancel"
    static let toggleFavBanDriver = "user/favourite"
    static let rateDriver = "booking/rate"
    static let getMessages = "chat/get-message-user"
    static let sendMessage = "chat/send-message-user"
    static let receiveMessage = "chat/receive-message-user"
    static let getDriverLocation = "booking/get-current-location"
    static let acceptRejectAmountRequest = "request/accept-reject-amount-request"
    static let cardDetails = "user/create-card"
    static let vehicleTypeList = "vehicle/type"
    static let adminBankList = "user/banks"
    static let bankDetials = "user/bank-detail"
    static let paypalSuccess = "booking/success/"
    static let getPaypalUrl = "booking/new-paypal-url"
    static let payment = "booking/payment"
    static let requestSuccess = "request/success/"


}

enum Color {
    static let app = UIColor(red: 54/255, green: 139/255, blue: 187/255, alpha: 1)
    static let red = UIColor(red: 236/255, green: 31/255, blue: 38/255, alpha: 1)
}

enum PageType : Int {
    case userType = 0
    case aboutUs = 2
    case userGuide = 3
    case termsAndCondition = 5
    case privacyPolicy = 6
    
}

enum FilterType: Int {
    case allOrders = 0, active, deleted, pending, cancelled, inProgress, pickUp, completed, driverCancel
}

enum IdentifiersVC : String {
    case splashVC = "SplashVC"
    case homeVC = "HomeVC"
    case loginVC = "SignInVC"
    case bannerVC = "WelcomeBannerVC"
    case drawerVC = "DrawerVC"
    case bookTypeVC = "BookTypeVC"
    case forgotPasswordVC = "ForgotPasswordVC"
    case signUpVC = "SignUpVC"
    case newPasswordVC = "NewPasswordVC"   
    case descriptionBookNowVC = "DescriptionBookNowVC"
    case notificationVC = "NotificationVC"
    case manageDriveVC = "ManageDriverVC"
    case contactUsVC = "ContactUsVC"
    case pageTypeVC = "PageTypeVC"
    case userGuideVC = "UserGuideVC"
    case myProfileVC = "MyProfileVC"
    case selectVehicleTypeVC = "SelectVehicleTypeVC"
    case bookNowVC = "BookNowVC"
    case confirmBookingVC = "ConfirmBookingVC"
    case paymentVC = "PaymentVC"
    case cancelbookingVC = "CancelbookingVC"
    case notifyVC = "NotifyVC"
    case myBookingsVC = "MyBookingsVC"
    case filterVC = "FilterVC"
    case faqVC = "FaqVC"
    case selectReasonVC = "SelectReasonVC"
    case bookingDetailVC = "BookingDetailVC"
    case addressDetailVC = "AddressDetailVC"
    case additionalServicesVC = "AdditionalServicesVC"
    case promocodeVC = "PromocodeVC"
    case rateBookingVC = "RateBookingVC"
    case receiptVC = "ReceiptVC"
    case nearByDriver = "GetNearByDriverVC"
    case driverFound = "DriverFoundVC"
    case bookingChangePriceRequestVC = "BookingChangePriceRequestVC"
    case addCard = "AddCardVC"
    case bankList = "BankListVC"
    case bankDetailVC = "BankDetailVC"
    case paymentWebViewVC = "PaymentWebViewVC"

}

enum BookingType: Int {
    case schedule = 1, bookNow
}

enum IsFavouriteDriver: Int {    
    case notFav = 0 , isFav
}
enum AmountNagotiable: Int {
    case no = 0 , yes
}

enum VehicleType : Int {
    case motorCycle = 1, car, suv, miniBus, van, bus,motorCycleTrasnport,carTransport,pickupTruck,vanTransport,miniTruck,truck,lorry
}

enum BookingState : Int {
    case active = 1, deleted, pending, cancelled, inProgress, pickup, completed, driverCancel
}

enum PaymentMethod: Int {
    case cash = 1, stripe,bankTransfer, paypal
}

enum ManageDriver: Int {
    case fav = 1, banned
}

enum DriverState : Int {
    case notSet = 0, favourite, banned
}
enum Provider{
    static let facebook = "FACEBOOK"
    static let google = "GOOGLE"
    static let apple = "APPLE"
}
enum Role:Int {
    case user = 2
}
enum ChooseLanguage: String {
    case english = "en", spanish = "es"
}

enum NotificationAction {
    static let acceptRequest = "accept-request"
    static let updateStatus = "update-status"
    static let approve = "approve"
    static let cancelBooking = "driver-cancel"
    static let newMessage = "send-message-user"
    static let changeAmountRequest = "amount-request"
    static let acceptScheduledRequest = "accept-scheduled-request"
    static let paymentNotification = "payment-notification"
    static let amountRequest = "amount-request"



}
enum ContactType: Int {
    case cust = 0, driver
}
enum AmountRequestState: Int {
    case accept = 3, reject
}
enum DefaultStatus: Int{
    case no = 0,yes
}

