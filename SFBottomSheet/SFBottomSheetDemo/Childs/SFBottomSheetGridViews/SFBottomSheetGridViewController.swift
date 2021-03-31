//
//  SFBottomSheetGridViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 18.02.21.
//

import UIKit

class SFBottomSheetGridViewController: UIViewController, SFBottomSheetChildControllerProtocol {

    fileprivate var viewModel: SFBottomSheetListViewModelProtocol!
    
    // MARK: - Outlets

    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private let cellIdentifier = "\(SFBottomSheetGridCollectionViewCell.self)"
    @objc dynamic var bottomSheetAppearanceSizes: BottomSheetChildAppearanceSizes!
    var didRequestCloseAction: (() -> Void)?
    var defaultRowHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupCollectionView()
    }
    
    // MARK: - Methods
    
    private func setupScene() {
        let contentHeight = defaultRowHeight + 50
        let eligibleCellCounts = Int((UIScreen.main.bounds.height * 0.7) / defaultRowHeight)
        let eligibleContainerHeight = defaultRowHeight * CGFloat(eligibleCellCounts)
        let initialContainerHeight = min(eligibleContainerHeight, contentHeight)
        if initialContainerHeight == contentHeight {
            collectionView.isScrollEnabled = true
        }
        bottomSheetAppearanceSizes = BottomSheetChildAppearanceSizes(containerHeight: initialContainerHeight,
                                                                     minimumAvailableContainerHeight: initialContainerHeight * 0.3,
                                                                     maximumAvailableHeightCoefficient: 0.7)
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
