//
//  ZoomTransitionAnimator.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 22/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class ZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 2.0
    var operation: UINavigationController.Operation = .push
    var thumbnailFrame = CGRect.zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let presenting = operation == .push
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            else {
                return
        }
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            else {
                return
        }
        
        let placesTableView = presenting ? fromView : toView
        let placesDetailView = presenting ? toView : fromView
        
        var initialFrame = presenting ? thumbnailFrame : placesDetailView.frame
        let finalFrame = presenting  ? placesDetailView.frame : thumbnailFrame
        
        let initialFrameAspectRation = initialFrame.width/initialFrame.height
        let placesDetailViewAspectRatio = placesDetailView.frame.width/placesDetailView.frame.height
        
        if initialFrameAspectRation > placesDetailViewAspectRatio {
            initialFrame.size = CGSize(width: initialFrame.height * placesDetailViewAspectRatio, height: initialFrame.height)
        }
        else {
            initialFrame.size = CGSize(width: initialFrame.width, height: initialFrame.width / placesDetailViewAspectRatio)
        }
        
        let finalFrameAspectRatio = finalFrame.width / finalFrame.height
        var resizedFinalFrame = finalFrame
        if finalFrameAspectRatio > placesDetailViewAspectRatio {
            resizedFinalFrame.size = CGSize(width: finalFrame.height * placesDetailViewAspectRatio, height: finalFrame.height)
        }
        else {
            resizedFinalFrame.size = CGSize(width: finalFrame.width, height: finalFrame.width / placesDetailViewAspectRatio)
        }
        
        let scaleFactor = resizedFinalFrame.width / initialFrame.width
        let growScaleFactor = presenting ? scaleFactor: 1/scaleFactor
        let shrinkScaleFactor = 1/growScaleFactor
        
        if presenting {
            placesDetailView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
            placesDetailView.center = CGPoint(x: thumbnailFrame.midX, y: thumbnailFrame.midY)
            placesDetailView.clipsToBounds = true
        }
        
        placesDetailView.alpha = presenting ? 0 : 1
        placesTableView.alpha = presenting ? 1 : 0
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(placesDetailView)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            placesDetailView.alpha = presenting ? 1 : 0
            placesTableView.alpha = presenting ? 0 : 1
            
            if presenting {
                placesDetailView.transform = CGAffineTransform.identity
            } else {
                placesTableView.transform = CGAffineTransform.identity
                placesDetailView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
            }
            placesDetailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
        
    }
    
    

}
