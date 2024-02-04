//
//  BottomSheetViewController.swift
//  NeshanTask
//
//  Created by Arman Zohourian on 1/28/24.
//

import Foundation
class BottomSheetViewController: UIViewController {

    
    // MARK: - UI
    /// Main bottom sheet container view
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    /// View to to hold dynamic content
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Top bar view that draggable to dismiss
    private lazy var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    /// Top view bar
    private lazy var barLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    /// Maximum alpha for dimmed view
    private let maxDimmedAlpha: CGFloat = 0.8
    /// Minimum drag vertically that enable bottom sheet to dismiss
    private let minDismissiblePanHeight: CGFloat = 20
    /// Minimum spacing between the top edge and bottom sheet
    private var minTopSpacing: CGFloat = 80
    
    weak var delegate: MapDelegate?
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresent()
    }
    
    deinit {
        print("Bottom Sheet has been dismissed !")
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        // Container View
        view.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainContainerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: minTopSpacing)
        ])
        
        // Top draggable bar view
        mainContainerView.addSubview(topBarView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 54)
        ])
        topBarView.addSubview(barLineView)
        NSLayoutConstraint.activate([
            barLineView.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            barLineView.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: 8),
            barLineView.widthAnchor.constraint(equalToConstant: 40),
            barLineView.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        // Content View
        mainContainerView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -24),
            contentView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        topBarView.addGestureRecognizer(panGesture)
    }

    @objc private func handleTapDimmedView() {
        dismissBottomSheet()
    }
    
    //MARK: Handle Gesture
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        gesture.cancelsTouchesInView = false

        // Calculate the new frame origin for the bottom sheet
        let newY = self.mainContainerView.frame.origin.y + translation.y

        // Update the frame of the bottom sheet
        self.mainContainerView.frame.origin.y = max(newY, self.view.frame.height - self.mainContainerView.frame.height)

        // Reset the translation to avoid cumulative translations
        gesture.setTranslation(.zero, in: view)

        // Handle gesture state
        switch gesture.state {
        case .ended:
            // Optionally, you can add some animation when the gesture ends
            UIView.animate(withDuration: 0.3) {
                // If the bottom sheet is dragged down beyond a certain threshold, dismiss it
                if self.mainContainerView.frame.origin.y > self.view.frame.height - self.mainContainerView.frame.height * 0.7 {
                    self.dismissBottomSheet()
                    self.delegate?.didClosedSheet()
                } else {
                    // Otherwise, snap back to the original position
                    self.mainContainerView.frame.origin.y = self.view.frame.height - self.mainContainerView.frame.height
                }
            }
        default:
            break
        }
    }
    
    private func animatePresent() {

        mainContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.mainContainerView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard self != nil else { return }
        }
    }

    func dismissBottomSheet() {
        UIView.animate(withDuration: 0.2, animations: {  [weak self] in
            guard let self = self else { return }

            self.mainContainerView.frame.origin.y = self.view.frame.height
        }, completion: {  [weak self] _ in
            self?.dismiss(animated: false)
        })
    }
    
    func setContent(content: UIView) {
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        view.layoutIfNeeded()
    }

}

extension UIViewController {
    func presentBottomSheet(viewController: BottomSheetViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
}
