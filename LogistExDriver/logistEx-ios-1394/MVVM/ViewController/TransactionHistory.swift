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

class TransactionHistory: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnAdded: UIButton!
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var tblVwTransactionHistory: UITableView!
    @IBOutlet weak var btnChooseDate: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        actionHistory(btnAll)
    }
    
    //MARK:- IBActions
    
    @IBAction func actionBack(_ sender: Any) {
    }
    
    @IBAction func actionHistory(_ sender: UIButton) {
        btnAll.backgroundColor = .white
        btnPaid.backgroundColor = .white
        btnAdded.backgroundColor = .white
        btnAll.setTitleColor(.black, for: .normal)
        btnPaid.setTitleColor(.black, for: .normal)
        btnAdded.setTitleColor(.black, for: .normal)
        sender.backgroundColor = UIColor(red: 237/255, green: 35/255, blue: 41/255, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
    }
    @IBAction func actionChooseDate(_ sender: Any) {
    }
}


extension TransactionHistory: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryTVC") as! TransactionHistoryTVC
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
