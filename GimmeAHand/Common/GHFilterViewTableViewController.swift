//
//  GHFilterViewTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/18/21.
//

import UIKit

class GHFilterViewTableViewController: UITableViewController {
    
    lazy var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0.0, y: tableView.frame.height, width: tableView.frame.width, height: 500.0))
        containerView.backgroundColor = .systemBackground
        containerView.setRoundCorner(20.0)
        return containerView
    }()
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilterView))
        blurEffectView.addGestureRecognizer(tapGesture)
        
        return blurEffectView
    }()
    
    func showFilterView(_ filterTitle: String, _ filterView: UIView) {
        let margin: CGFloat = 20.0
        
        // clear old subviews
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        UIView.animate(withDuration: GHConstant.kFilterViewTransitionDuration, delay: 0.0, options: [.curveEaseOut, .transitionFlipFromBottom]) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            // execute animation
            strongSelf.blurEffectView.effect = UIBlurEffect(style: .dark)
            UIApplication.shared.windows.first!.addSubview(strongSelf.blurEffectView)
            let containerView = strongSelf.containerView
            
            // real animation
            containerView.frame.origin.y = strongSelf.tableView.frame.height - containerView.frame.height
            
            // add title
            let titleLabel = UILabel(frame: CGRect(x: margin, y: 0, width: containerView.frame.width - 2 * margin, height: 80.0))
            titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
            titleLabel.text = filterTitle
            containerView.addSubview(titleLabel)
            
            // add dismiss button
            let dismissButton = UIButton(frame: CGRect(x: margin, y: containerView.frame.height - 90.0, width: containerView.frame.width - 2 * margin, height: 50.0))
            dismissButton.backgroundColor = .GHTint
            dismissButton.setRoundCorner()
            dismissButton.setTitle("OK", for: .normal)
            dismissButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            dismissButton.addAction(UIAction(handler: { _ in
                // dismiss the containerView
                strongSelf.dismissFilterView(nil)
            }), for: .touchUpInside)
            containerView.addSubview(dismissButton)
            
            // add customzied filter view
            filterView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(filterView)
            containerView.addConstraints([
                NSLayoutConstraint(item: filterView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: filterView, attribute: .bottom, relatedBy: .equal, toItem: dismissButton, attribute: .top, multiplier: 1.0, constant: -margin),
                NSLayoutConstraint(item: filterView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: margin),
                NSLayoutConstraint(item: filterView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: -margin)
            ])
            containerView.updateConstraintsIfNeeded()
            
            UIApplication.shared.windows.first!.addSubview(containerView)
            UIApplication.shared.windows.first!.bringSubviewToFront(containerView)
        } completion: { [weak self] (completed) in
            guard let strongSelf = self else {
                return
            }
            if completed {
                strongSelf.tableView.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func dismissFilterView(_ sender: UITapGestureRecognizer?) {
        UIView.animate(withDuration: GHConstant.kFilterViewTransitionDuration, delay: 0.0, options: .curveEaseIn) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            // dismiss containerview animation
            strongSelf.blurEffectView.effect = nil
            strongSelf.containerView.frame.origin.y = strongSelf.tableView.frame.height
        } completion: { [weak self] (completed) in
            guard let strongSelf = self else {
                return
            }
            
            if completed {
                strongSelf.containerView.removeFromSuperview()
                strongSelf.blurEffectView.removeFromSuperview()
                strongSelf.tableView.isUserInteractionEnabled = true
            }
        }
    }
    
}
