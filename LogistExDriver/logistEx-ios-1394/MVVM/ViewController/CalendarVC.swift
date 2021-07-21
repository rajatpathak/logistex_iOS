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
import FSCalendar

typealias PassDate = (String) -> ()
class CalendarVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var vwCalendar: FSCalendar!
    
    //MARK:- Variables
    var objPassDate: PassDate?
    var selectedDate = String()
    var dateStr = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if dateStr != "" {
            selectedDate = dateStr
        } else {
            selectedDate = selectedDate.getCurrentDate()
        }
    }
    
    //MARK:- IBActions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss()
    }
    @IBAction func actionOk(_ sender: Any) {
        guard let block = objPassDate else {return}
        dismiss()
        block(selectedDate)
    }
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date.stringFromFormat("yyyy-MM-dd")
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        if self.title != TitleValue.earning {
            return Date()
        } else {
            return Date.init(timeIntervalSince1970: 1970)
        }
    }
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        cell.eventIndicator = .none
        if (cell.numberOfEvents > 0) {
            cell.shapeLayer.fillColor = UIColor.red.cgColor
            cell.titleLabel.textColor = .white
        } else {
            if date < Date() {
                if Calendar.current.isDateInToday(date) {
                    cell.shapeLayer.fillColor =  (cell.numberOfEvents > 0) ? UIColor.red.cgColor : Color.app.cgColor
                    cell.titleLabel.textColor = .white
                } else {
                    cell.titleLabel.textColor = .gray
                }
            } else {
                cell.shapeLayer.fillColor = UIColor.white.cgColor
                cell.titleLabel.textColor = .black
            }
        }
        cell.isUserInteractionEnabled = true
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
       return (dateStr == date.stringFromFormat("yyyy-MM-dd")) ? 1 : 0
    }
}
