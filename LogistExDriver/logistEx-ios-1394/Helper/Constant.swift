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
}
enum DeviceInfo {
    static let deviceType = "2"
    static let deviceName = UIDevice.current.name
    static let DeviceHeight = UIScreen.main.bounds.height
    static let DeviceWidth = UIScreen.main.bounds.width
}
enum Keys {
    static let googleClientId = "135699466832-bkc5d39sh3n5rjmq0t5mdas2fq0i26h3.apps.googleusercontent.com"
    static let googleKey = "AIzaSyBwLGYDJ4ZO3C9NYKg4tOc2sIyKWp37Eqo"
}

struct ApiResponse {
    let data: NSDictionary?
    let success: Bool
    let message: String?
}

enum StoryBoard {
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

enum AlertMessages {
    static let black = "Black"
    static let white = "White"
    static let error = "Error"
    static let alert = "Alert"
    static let setting = "Settings"
    static let done = "Done"
    static let deletePhoto = "Delete Photo"
    static let choosePhoto = "Choose Photo"
    static let takePhoto = "Take Photo"
    static let gallery = "Gallery"
    static let camera = "Camera"
    static let success = "Success"
    static let locationProblem = "Location problem"
    static let unableJsonEncode = "Error: Unable to encode json response"
    static let ok = "Ok"
    static let okSpa = "Okay"
    static var turnOnLocationServiceFromSetting = "To use this service efficiently, you must turn on location services from settings."
    static var locationServiceOff = "Location services are off."
    static let yes = "Yes"
    static let yesSpa = "si"

    static var canNotDetermineYourLocation = "Location services are not able to determine your location."
    static let no = "No"

    static let settings = "Settings"
    static let cameraNotSupported = "Camera is not supported"
    static let connectionProblem =  "Connection problem"
    static let checkInternetConn = "Please check your internet connection"
    static let reviewNetworkConn = "Please review your network settings"
    static let loading = "Loading..."
    static let cammeraNotAccess = "Unable to access the Camera"
    static let cameraNotSupport = "Camera ilets not supported"
    static let openSettingCamera = "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."
    static let urlError = "Please check the URL : 400"
    static let urlNotExist = "URL does not exists : 404"
    static let serverError = "Server error, Please try again.."
    static let cancel = "cancel"
    static let email = "enterEmail"
    static let password = "enterPassword"
    static let profile = "chooseProfile"
    static let firstName = "enterFirstName"
    static let lastName = "enterLastName"
    static let validEmail = "enterValidEmail"
    static let passwordLimit = "enterPasswordLimit"
    static let enterVaildPhoneNo = "enterVaildPhoneNo"
    static let confirmPassword = "enterConfirmPassword"
    static let notMatch = "notMatch"
    static let mobileNumber = "enterMobileNumber"
    static let vehicleCategory = "selectVehicleCategory"
    static let vehicleType = "selectVehicleType"
    static let vehicleBrand = "selectVehicleBrand" // new
    static let vehicleColor = "selectVehicleColor" // new
    static let enterAmount = "enterAmount"
    static let selectCountry = "chooseCountry"
    static let license = "chooseLicense"
    static let licenseExp = "enterLicenseExp"
    static let insuranceExp = "enterInsuranceExp"
    static let vehicleNo = "enterVehicleNo"
    static let vehicleImg = "chooseVehicleImg"
    static let insuranceImg = "selectInsuranceImg"
    static let roadTax = "chooseRoadTax"
    static let idCard = "chooseIdCard"
    static let termsCondition = "acceptTermsCondition"
    static let loginSuccess = "loginSuccess"
    static let applyChangeRequest = "applyChangeRequest"
    static let canNotStartJourney = "canNotStartJourney"
    static let resetPassword = "resetPassword"
    static let fullName = "enterFullName"
    static let selectReason = "chooseReason"
    static let message = "enterReason"
    static let enquirySubmitted = "enquirySubmitted"
    static let newPassword = "enterNewPassword"
    static let changePassword = "passwordChange"
    static let accept = "acceptRequest"
    static let rejectAmountConfrimation = "rejectAmountConfrimation"
    static let applyAmountChangeConfirmation = "applyAmountChangeConfirmation"
    static let declinedRequestConfirmation = "declinedRequestConfirmation"
    static let reschudledRequestConfirmation = "reschudledRequestConfirmation"
    static let paymentIsPending = "paymentIsPending"
    static let requestSentSuccesfully = "requestSentSuccesfully"

    static let verificationLink = "verificationLink"
    static let enterMessage = "enterMessage"
    static let updated = "profileUpdated"
    static let updateIosVersion = "updateIosVersion"
    static let custSignature = "custSign"
    static let addRating = "addRating"
    static let addComment = "addComment"
    static let bankName = "enterBankName"
    static let accountNo = "enterAccountNo"
    static let accountName = "enterAccountName"
    static let bankCode = "enterBankCode"
    static let completeProfile = "completeProfile"
    static let logout = "logout"
    static let logoutSuccess = "logoutSuccess"
    static let cancelBooking = "cancelBooking"
    static let cantChangeCountry = "cantChangeCountry"
}

enum TitleValue {
    static let termsCondition = "Terms & Conditions"
    static let license = "License"
    static let idCard = "Id Card"
    static let noPlate = "Number Plate"
    static let roadTax = "Road Tax"
    static let insurance = "Insurance"
    static let profile = "Profile"
    static let chooseReason = "Choose Reason"
    static let chooseReasonSpa = "Escoja la razón"
    static let motorCycle = "Motor Cycle"
    static let car = "Car"
    static let van = "Van"
    static let truck = "Truck"
    static let lorry = "Lorry"
    static let cash = "Cash"
    static let cashSpa = "Efectivo"
    static let card = "Card"
    static let cardSpa = "Tarjeta"
    static let bankTransferTitlte = "Bank Transfer" // new
    static let bankTransferTitlteSpa = "Transferencia bancaria" // new
    static let paypalTitle = "Paypal" // new
    static let paypalTitleSpa = "Paypal" // new
    static let pickupLocation = "pickupLocation"
    static let dropLocation = "dropLocation"
    static let assigned = "Driver Assigned"
    static let assignedSpa = "Conductor Asignado"
    static let progress = "Driver is moving"
    static let progressSpa = "Conductor en movimiento"
    static let picked = "Package Picked"
    static let pickedSpa = "Paquete Recogido"
    static let cancelled = "Package Cancelled"
    static let cancelledSpa = "Reserva Cancelada"
    static let completed = "Completed"
    static let completedSpa = "Terminada"
    static let bookingCancelled = "Booking Cancelled"
    static let bookingCancelledSpa = "Conductor Cancelado"
    static let makeOrderPickup = "makeOrderPickup"
    static let startJourney = "startJourney"
    static let makeOrderComplete = "makeOrderComplete"
    static let dropOffDetail = "dropOffDetail"
    static let driverGuide = "Driver Guide"
    static let driverGuideSpa = "Guía de usuario"
    static let privacy = "Privacy Policy"
    static let privacySpa = "Políticas de privacidad"
    static let earning = "Earning"
    static let chatUser = "Chat with user"
    static let rate = "rate"
    static let chatAdmin = "Admin"
    static let chatAdminSpa = "Administrador"
    static let alreadyRate = "Already Rated"
    static let addBankDetail = " Add Bank Details"
    static let addBankDetailSpa = " Agregar Detalles Bancarios"
    static let bankDetail = " Bank Details"
    static let bankDetailSpa = " Detalles Bancarios"
    static let alreadyRateSpa = " Ya clasificado"
    static let rateUser = "Rate User"
    static let rateUserSpa = "Valorar usuario"
    static let english = "English"
    static let spanish = "Spanish"
    static let pickUpTime = "Pickup date/time:"
    static let pickUpTimeSpa = "Hora de recogida:"
    static let deliveryTime = "Service Completed On:"
    static let deliveryTimeSpa = "Servicio completado el:"
    static let deliveryStatus = "Delivery Status:"
    static let deliveryStatusSpa = "Estado de la entrega:"
    static let orderPrice = "Order Price:"
    static let orderPriceSpa = "Precio de la Orden:"
    static let pickUp = "Pick up:"
    static let pickUpSpa = "recogida:"
    static let drop = "Drop:"
    static let dropSpa = "Entrega:"
    static let orderId = "Order ID:"
    static let orderIdSpa = "Orden ID:"
    static let orderNo = "Order No:-"
    static let orderNoSpa = "Orden No:-"
    static let noResult = "No results"
    static let noResultSpa = "No hay resultados"
    static let pleaseTryAgain = "Please try again later"
    static let pleaseTryAgainSpa = "Por favor, inténtelo de nuevo más tarde"
    static let refersh = "Refresh"
    static let refershSpa = "Actualizar"
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
    static let tryAgain =  "Try again?"
    static let tryAgainSpa =  "¿Inténtalo de nuevo?"
    static let searchAgain =  "Search again?"
    static let searchAgainSpa =  "¿Busca de nuevo?"
    static let noIncome =  "No income"
    static let noIncomeSpa =  "Sin ingresos"
    static let askFriend =  "Ask friend!"
    static let askFriendSpa =  "¡Preguntar a un amigo!"
    static let noCollection =  "No collections"
    static let noCollectionSpa =  "Sin colecciones"
    static let weAreSorry =  "We’re Sorry"
    static let weAreSorrySpa =  "Lo sentimos"
    static let whereAreYou =  "Where are you?"
    static let whereAreYouSpa =  "¿Dónde estás?"
    static let noLoggedIn = "Not logged In"
    static let noLoggedInSpa =  "Sin iniciar sesión"
    static let noFavourite = "No favorites"
    static let noFavouriteSpa =  "Sin favoritos"
    static let cartEmpty = "The cart is empty"
    static let cartEmptySpa =  "El carrito está vacío"
    static let boxEmpty = "The box is empty"
    static let boxEmptySpa =  "La caja esta vacía"
    static let noNotificatoin =  "No notifications"
    static let noNotificatoinSpa =  "No Notificaciones"
    static let cashCollect = "Cash to be Collected:"
    static let cashCollectSpa = "Total a cobrar :"
    static let distance = "Distance:"
    static let distanceSpa = "Distancia:"
    static let time = "Time:"
    static let timeSpa = "Hora:"
    static let totalRides = "Total Rides-"
    static let totalRidesSpa = "Total de Viajes-"
    static let typeHere = "Type here"
    static let typeHereSpa = "Escriba aquí"
    static let typeMessage = "Type message"
    static let typeMessageSpa = "Escribir mensaje"
    static let goToCollect =   "Go to collect favorites products"
    static let goToCollectSpa = "Ir a recopilar productos favoritos"
    static let youCouldBorrowNetwork =   "You could borrow money from your network"
    static let youCouldBorrowNetworkSpa = "Podrías pedir prestado dinero a tu red"
    static let youHaveNoPayment =   "You have no payment so contact your client"
    static let youHaveNoPaymentSpa = "No tiene pago, comuníquese con su cliente"
    static let staffWorkingIssue =  "Our staff is still working on the issue for better experience"
    static let staffWorkingIssueSpa = "Nuestro personal todavía está trabajando en el tema para una mejor experiencia"
    static let canFindLocation =  "We can't find your location"
    static let canFindLocationSpa = "No podemos encontrar tu ubicación"
    static let pleaseRegisterOrLogin =  "Please register or log in first"
    static let pleaseRegisterOrLoginSpa = "Por favor regístrese o inicie sesión primero"
    static let sorryDontHaveNotification = "Sorry, you don't have any notifications. Please come back later!"
    static let sorryDontHaveNotificationSpa = "Lo siento, no tienes notificaciones. ¡Vuelve más tarde!"
    static let dontHaveEmail =  "You dont have any email!"
    static let dontHaveEmailSpa =  "¡No tienes ningún correo electrónico!"
    static let selectAlmostItem =  " Please, select almost one item to purchase"
    static let selectAlmostItemSpa =  "Por favor, seleccione casi un artículo para comprar"
    static let selectYourItem =  "Select your favorite items first!"
    static let selectYourItemSpa =  "¡Primero seleccione sus artículos favoritos!"
    static let cancelCapsFirstLetter =  "Cancel"
    static let cancelCapsFirstLetterSpa =  "Cancelar"
    static let offeredAmount =  "Amount Offered :"
    static let offeredAmountSpa =  "Monto Ofertado"
    static let changeAmount =  "Change Amount"
    static let changeAmountSpa =  "Cambiar Monto"
    static let taxi = "Taxi"
    static let taxiSpa = "Taxi"
    static let transport = "Transport"
    static let transportSpa = "Transporte"
    static let applyChanges = "APPLY CHANGES"
    static let applyChangesSpa = "Aplicar Cambios"
    static let decline = "DECLINE"
    static let declineSpa = "Declinar"
    static let enterAmountTitle = "Enter Amount"
    static let enterAmountTitleSpa = "Introduzca el Monto"
    static let orderCompletedSpa = "¡Pedido completado!"
    static let orderCompleted = " Order completed!"
    static let cashCollected = "Cash to be collected:"
    static let cashCollectedSpa = "Efectivo a cobrar:"
    
    
    // new work constant
    static let vehicleTypeList = "Select Vehicle Type"
    static let vehicleTypeListSpa = "Select Vehicle Type"
    static let vehicleBrand = "Select Vehicle Brand"
    static let vehicleBrandSpa = "Select Vehicle Type"
    static let vehicleColor = "Select Vehicle Color"
    static let vehicleColorSpa = "Select Vehicle Color"

}

enum Apis {
    static let googleAddress = "https://maps.googleapis.com/maps/api/"
    static let serverUrl = "https://app.logist-ex.com/api/"  // Live server
    //static let serverUrl = "https://demo3.toxsl.in/logistex/api/" // Demo server
    //static let serverUrl = "http://192.168.2.130/logistex-yii2-1394/api/" // Local Sever
    static let login = "user/login"
    static let signup = "user/driver-signup"
    static let updateProfile = "user/driver-update"
    static let check = "user/check"
    static let forgot = "user/recover"
    static let contactUs = "user/contact-us"
    static let changePassword = "user/change-password"
    static let updateStatus = "user/update-work-status"
    static let reasonList = "user/reason-list"
    static let requestList = "request/list"
    static let requestAllList = "request/get-all-request"
    static let updateLocation = "user/update-current-location"
    static let page = "user/page"
    static let notificationList = "request/notification-list"
    static let acceptRequest = "request/accept-request"
    static let acceptScheduledRequest = "request/accept-scheduled-request"
    static let rejectRequest = "request/reject-request"
    static let updateBookingStatus = "booking/update-status"
    static let bookingDetail = "booking/details"
    static let bookingHistory = "booking/history"
    static let faq = "user/faq"
    static let logout = "user/logout"
    static let getMessages = "chat/get-message"
    static let sendMessage = "chat/send-message"
    static let receiveMessage = "chat/receive-message"
    static let socialLogin = "user/social-login"
    static let earning = "booking/my-earning"
    static let countryList = "user/currency-list"
    static let getUserMessages = "chat/get-message-user"
    static let sendUserMessage = "chat/send-message-user"
    static let receiveUserMessage = "chat/receive-message-user"
    static let addRating = "user/add-rating"
    static let addBankAccount = "bank-account/add-account"
    static let updateBankAccount = "bank-account/update-account"
    static let cancelBookingDriver = "booking/driver-cancel"
    static let delete = "user/file-delete"
    static let vehicleCategoryList = "user/vehicle-list"
    static let applyAmountChange = "booking/amount-request"
    static let declinedRequest = "request/decline-request"
    static let vehicleBrandList = "vehicle/brands"
    static let vehicleColorList = "vehicle/color"
    static let vehicleTypeList = "vehicle/type"
    static let reschduledRequest =  "booking/reschedule"
    static let paymentNotification =  "booking/payment-notification"

}

enum Color {
    static let app = UIColor(red: 0/255, green: 67/255, blue: 132/255, alpha: 1)
    static let fadeGray = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let lightRed = UIColor(red: 234/255, green: 38/255, blue: 31/255, alpha: 1)
}
enum Font {
    static let avenirBlack = "Avenir-Black"
    static let avenirLight = "Avenir-Light"
    static let avenirMedium = "Avenir-Medium"
}
enum Role:Int {
    case driver = 3
}

enum VehicleCategory : Int {
    case motorCycle = 1, car, suv, miniBus, van, bus,motorCycleTrasnport,carTransport,pickupTruck,vanTransport,miniTruck,truck,lorry
}

enum VehicleType: Int {
    case taxi = 1,transport
}
enum ContactType: Int {
    case cust = 0, driver
}
enum TypeImage: Int {
    case other = 0, license, roadTax, vehicleImage, idCard, insurance
}
enum DriverStatus: Int {
    case online = 1, offline, busy
}
enum AmountNagotiable: Int {
    case no = 0 , yes
}
enum TypePage: Int {
    case user = 0
    case termDriver = 1
    case about = 2
    case userGuide = 3
    case driverGuide = 4
    case termsUser = 5
    case privacy = 6
}
enum SortType: Int {
    case distance = 1, time
}
enum FilterType: Int {
    case now = 1, today, later
}
enum StateRequest: Int {
    case active = 1, deleted, pending, cancelled, inProgress, pickup, completed, driverCancel
}
enum PaymentMethod: Int {
    case cash = 1, stripe, bankTransfer, paypal
}
enum DeliveryState: Int {
    case accepted = 4
    case completed = 6
}
enum BookingType: Int {
    case scheduled = 1, bookNow
}
enum ChangeAmountRequstState: Int {
    case none = 0,send = 1 ,accept = 3, reject = 4
}
enum Provider{
    static let facebook = "FACEBOOK"
    static let google = "GOOGLE"
    static let apple = "APPLE"
}

enum ChooseLanguage: String {
    case english = "en", spanish = "es"
}
enum NotificationAction {
    static let newRequest = "add"
    static let newMessage = "send-message-user"
    static let newMessageAdmin = "send"
    static let cancelBooking = "cancel"
    static let rating = "rate"
    static let acceptAmountRequest = "accept-reject-amount-request"
    static let acceptRequest = "accept-request"
    static let approve = "approve"
    static let success = "success"
    
}


