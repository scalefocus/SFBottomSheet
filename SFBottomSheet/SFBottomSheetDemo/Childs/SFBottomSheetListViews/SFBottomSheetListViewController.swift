//
//  SFBottomSheetListViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

protocol SFBottomSheetListViewModelProtocol {
    
    var dataSource: [SFBottomSheetTableViewCellModel] { get }
    
    func numberOfCellsInSection(_ section: Int) -> Int
    
}

class SFBottomSheetListViewController: UIViewController, SFBottomSheetChildControllerProtocol {
    
    fileprivate var viewModel: SFBottomSheetListViewModelProtocol!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var bottomSheetAppearance = BottomSheetChildAppearance(containerHeight: 300,
                                                           minimumAvailableContainerHeight: 300 * 0.2,
                                                           maximumAvailableHeightCoefficient: 0.90)
    var didRequestCloseAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupTableView()
    }
    
    private func setupScene() {
        let defaultRowHeight: CGFloat = 70
        let contentHeight = CGFloat(viewModel.dataSource.count) * defaultRowHeight
        let eligibleCellCounts = Int((UIScreen.main.bounds.height * 0.80) / defaultRowHeight)
        let eligibleContainerHeight = defaultRowHeight * CGFloat(eligibleCellCounts)
        let initialContainerHeight = min(eligibleContainerHeight, contentHeight)
        if initialContainerHeight == contentHeight {
            tableView.isScrollEnabled = false
        }
        bottomSheetAppearance = BottomSheetChildAppearance(containerHeight: initialContainerHeight,
                                                           minimumAvailableContainerHeight: initialContainerHeight * 0.2,
                                                           maximumAvailableHeightCoefficient: 0.90)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "\(SFBottomSheetListTableViewCell.self)", bundle: nil),
                           forCellReuseIdentifier: "\(SFBottomSheetListTableViewCell.self)")
        tableView.backgroundColor = .white
    }
    
}

// MARK: - UITableViewDelegate

extension SFBottomSheetListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.dataSource.indices.indices.contains(indexPath.row) else { return }
        didRequestCloseAction?()
    }
    
}

// MARK: - UITableViewDataSource

extension SFBottomSheetListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCellsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SFBottomSheetListTableViewCell.self)", for: indexPath) as? SFBottomSheetListTableViewCell
        else { return UITableViewCell() }
        cell.configureWith(viewModel.dataSource[indexPath.row])
        return cell
    }
    
}

struct SFBottomSheetListSceneConfigurator {
    static func createScene() -> SFBottomSheetListViewController? {
        let controller = SFBottomSheetListViewController()
        let viewModel = SFBottomSheetListViewModel()
        controller.viewModel = viewModel
        return controller
    }
}
