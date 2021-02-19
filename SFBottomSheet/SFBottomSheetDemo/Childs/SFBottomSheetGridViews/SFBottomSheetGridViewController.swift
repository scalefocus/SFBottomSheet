//
//  SFBottomSheetGridViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 18.02.21.
//

import UIKit

class SFBottomSheetGridViewController: UIViewController, SFBottomSheetChildControllerProtocol {
    
    weak var delegate: SFBottomSheetChildDelegate?
      
    fileprivate var viewModel: SFBottomSheetListViewModelProtocol!
    
    // MARK: - Outlets

    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private let cellIdentifier = "\(SFBottomSheetGridCollectionViewCell.self)"
    var defaultContainerHeight: CGFloat = .zero
    var defaultRowHeight: CGFloat = 200
    var minimumAvailableContainerHeight: CGFloat {
        return defaultContainerHeight * 0.3
    }
    var maximumAvailableHeightCoefficient: CGFloat = 0.7
    var childContainerLeadingDefaultConstraint: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func getContainerHeight(_ maximumAvailableContainerHeight: CGFloat) -> CGFloat {
        let contentHeight = defaultRowHeight + 50
        let eligibleCellCounts = Int(maximumAvailableContainerHeight / defaultRowHeight)
        let eligibleContainerHeight = defaultRowHeight * CGFloat(eligibleCellCounts)
        defaultContainerHeight = min(eligibleContainerHeight, contentHeight)
        if defaultContainerHeight == contentHeight {
            collectionView.isScrollEnabled = true
        }
        return defaultContainerHeight
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UICollectionViewDelegate

extension SFBottomSheetGridViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension SFBottomSheetGridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCellsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SFBottomSheetGridCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configureWith(viewModel.dataSource[indexPath.item])
        return cell
    }
    
}

struct SFBottomSheetGridSceneConfigurator {
    
    static func createScene() -> SFBottomSheetGridViewController? {
        let controller = SFBottomSheetGridViewController()
        let viewModel = SFBottomSheetListViewModel()
        controller.viewModel = viewModel
        return controller
    }
}
