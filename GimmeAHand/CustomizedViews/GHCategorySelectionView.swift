//
//  GHCategorySelectionView.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/23/21.
//

import UIKit

class GHCategorySelectionView: UIStackView {
    
    var buttons: [UIButton] = []
    var selectedCategories: Set<String> = Set<String>() {
        didSet {
            for button in buttons {
                guard let buttonString = button.titleLabel?.text else {
                    continue
                }
                button.updateSelectionColor(selected: selectedCategories.contains(buttonString))
            }
        }
    }
    
    init(_ selectedCategories: Set<String>, _ buttonAction: @escaping UIActionHandler) {
        super.init(frame: .zero)
        
        let allCategories = GHOrderCategory.allCases
        axis = .vertical
        spacing = 10.0
        alignment = .fill
        distribution = .fillEqually
        for i in 0...2 {
            let smallStackView = UIStackView()
            smallStackView.axis = .horizontal
            smallStackView.spacing = 10.0
            for j in 0...1 {
                let currentCategory = allCategories[i * 2 + j]
                let currentCategoryString = currentCategory.rawValue
                let currentCategoryImage = currentCategory.getImage()
                let button = UIButton()
                button.setTitle(currentCategoryString, for: .normal)
                button.setImage(currentCategoryImage, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10.0);
                button.setRoundCorner()
                button.addAction(UIAction(handler: buttonAction), for: .touchUpInside)
                buttons.append(button)
                smallStackView.addArrangedSubview(button)
            }
            smallStackView.alignment = .fill
            smallStackView.distribution = .fillEqually
            addArrangedSubview(smallStackView)
        }
        updateSelectedCategories(selectedCategories)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelectedCategories(_ selectedCategories: Set<String>) {
        self.selectedCategories = selectedCategories
    }
    
}

extension UIButton {
    
    func updateSelectionColor(selected: Bool) {
        if selected {
            backgroundColor = .GHTint
            setTitleColor(.white, for: .normal)
            tintColor = .white
        } else {
            backgroundColor = .systemBackground
            setTitleColor(.GHTint, for: .normal)
            tintColor = .GHTint
        }
    }
    
}
