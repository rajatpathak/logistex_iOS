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

class PageControlVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var colVwPages: UICollectionView!
    @IBOutlet weak var pageControlIntro: UIPageControl!
    
    //MARK:- Variables
    var arrIntro = [("24*7 Flexible Work Time","Earn money at anywhere on anytime. \n Lots of delivery waiting for you.",#imageLiteral(resourceName: "ic_slide")),("Easy Delivery","Plan your way ahead, save time & \n energy.",#imageLiteral(resourceName: "ic_slide2")),("Earn More","The more delivery the more you earn.",#imageLiteral(resourceName: "ic_slide3"))]
    
    var arrSpanishIntro = [("24 * 7 Horarios de trabajo flexibles","Gana dinero en cualquier lugar a cualquier hora. \n Muchos envíos esperando por ti..",#imageLiteral(resourceName: "ic_slide")),("Facil Entrega","Planifícate, ahorra tiempo &amp; energía.",#imageLiteral(resourceName: "ic_slide2")),("Gana mas","Mientras mas entregas hagas mas dinero ganas.",#imageLiteral(resourceName: "ic_slide3"))]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    //MARK:- IBActions
    @IBAction func actionSkip(_ sender: Any) {
        root(identifier: "LoginVC")
    }
}

extension PageControlVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrIntro.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dictEng = arrIntro[indexPath.row]
        let dictSpanish = arrSpanishIntro[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageControlCVC", for: indexPath) as! PageControlCVC
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        cell.lblTitle.text = lang == ChooseLanguage.spanish.rawValue ? dictSpanish.0 : dictEng.0
        cell.lblDesc.text = lang == ChooseLanguage.spanish.rawValue ? dictSpanish.1 : dictEng.1
        cell.imgVwSlide.image =  lang == ChooseLanguage.spanish.rawValue ? dictSpanish.2 : dictEng.2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: colVwPages.contentOffset, size: colVwPages.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = colVwPages.indexPathForItem(at: visiblePoint)
        pageControlIntro.currentPage = indexPath?.row ?? 0
    }
}
