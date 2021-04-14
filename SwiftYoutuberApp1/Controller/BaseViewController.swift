//
//  BaseViewController.swift
//  SwiftYoutuberApp1
//
//  Created by Hitomi Nagano on 2021/04/13.
//

import UIKit
import SegementSlide

class BaseViewController: SegementSlideDefaultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // SegementSlideの更新
        reloadData()
        defaultSelectedIndex = 0
    }
    
    override func segementSlideHeaderView() -> UIView {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "header")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerHeight: CGFloat
        if #available(iOS 11.0, *) {
            headerHeight = view.bounds.height/4+view.safeAreaInsets.top
        } else {
            headerHeight = view.bounds.height/4+topLayoutGuide.length
        }
        headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        return headerView
    }

    override var titlesInSwitcher: [String] {
        return ["Swift", "React×TypeScript", "Front-End"]
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch index {
        case 0:
            return Page1ViewController()
        case 1:
            return Page2ViewController()
        case 2:
            return Page3ViewController()
        default:
            return Page1ViewController()
        }
    }
}
