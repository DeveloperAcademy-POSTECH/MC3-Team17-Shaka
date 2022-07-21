//
//  MapModalController.swift
//  shaka
//
//  Created by JungHoonPark on 2022/07/20.
//

import UIKit

class MapModalController: UIViewController {
    
    //    @IBOutlet weak var circularImage: UIImageView!
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    
    // snapshot 저장
    var backingImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //        circularImage.layer.masksToBounds = true
        //        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
        backingImageView.image = backingImage

        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // hide the card view at the bottom when the View first load
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        // set dimmerview to transparent
        dimmerView.alpha = 0.0
        
        // dimmerViewTapped() will be called when user tap on the dimmer view
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCard()
    }
    
    @IBAction func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideCardAndGoBack()
    }
    
    private func hideCardAndGoBack() {
        
        self.view.layoutIfNeeded()

        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            
            // move the card view to bottom of screen
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        // move card down to bottom
        // create a new property animator
        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        // hide dimmer view
        // this will animate the dimmerView alpha together with the card move down animation
        hideCard.addAnimations {
            self.dimmerView.alpha = 0.0
        }
        
        // when the animation completes, (position == .end means the animation has ended)
        // dismiss this view controller (if there is a presenting view controller)
        hideCard.addCompletion({ position in
            if position == .end {
                if(self.presentingViewController != nil) {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        })
        
        // run the animation
        hideCard.startAnimation()
    }
    
    //MARK: Animations
    
    private func showCard() {
        
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            
            cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 2.0
        }
        
        // move card up from bottom by telling the app to refresh the frame/position of view
        // create a new property animator
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        // show dimmer view
        // this will animate the dimmerView alpha together with the card move up animation
        showCard.addAnimations({
            self.dimmerView.alpha = 0.7
        })
        
        // run the animation
        showCard.startAnimation()
    }
    
    
    @IBAction func reactionListButtonTapped(_ sender: UIButton) {
        guard let mapModalVC = storyboard?.instantiateViewController(withIdentifier: "MapModalController")
                as? MapModalController else {
            
            assertionFailure("No view controller ID ReactionViewController in storyboard")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            // take a snapshot of current view and set it as backingImage
            mapModalVC.backingImage = self.tabBarController?.view.asImage()
            
            // present the view controller modally without animation
            self.present(mapModalVC, animated: false, completion: nil)
        })
    }
}
