//
//  SFBottomSheetListViewController.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import UIKit

protocol SFBottomSheetListViewModelProtocol {
    
    func numberOfCellsInSection(_ section: Int) -> Int
    func cellData(for index: Int) -> SFBottomSheetTableViewCellModel?
    
}

class SFBottomSheetListViewController: UIViewController, SFBottomSheetChildControllerProtocol {

    fileprivate var viewModel: SFBottomSheetListViewModelProtocol!

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var defaultContainerHeight: CGFloat = .zero
    var defaultRowHeight: CGFloat = 70
    var minimumAvailableContainerHeight: CGFloat {
        return defaultContainerHeight * 0.2
    }
    var maximumAvailableHeightCoefficient: CGFloat = 0.75
    var childContainerLeadingDefaultConstraint: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func getContainerHeight(_ maximumAvailableContainerHeight: CGFloat) -> CGFloat {
        let contentHeight = tableView.contentSize.height
        let eligibleCellCounts = Int(maximumAvailableContainerHeight / defaultRowHeight)
        let eligibleContainerHeight = defaultRowHeight * CGFloat(eligibleCellCounts)
        defaultContainerHeight = min(eligibleContainerHeight, tableView.contentSize.height)
        if defaultContainerHeight == contentHeight {
            tableView.isScrollEnabled = false
        }
        return defaultContainerHeight
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "\(SFBottomSheetTableViewCell.self)", bundle: nil),
                           forCellReuseIdentifier: "\(SFBottomSheetTableViewCell.self)")
        
        setupTableViewHeight()
    }

    private func setupTableViewHeight() {
        tableView.reloadData()
    }

}

// MARK: - UITableViewDelegate

extension SFBottomSheetListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedModel = viewModel.cellData(for: indexPath.row) else { return }
        print(selectedModel)
    }

}

// MARK: - UITableViewDataSource

extension SFBottomSheetListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCellsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(SFBottomSheetTableViewCell.self)", for: indexPath) as? SFBottomSheetTableViewCell,
            let cellModel = viewModel.cellData(for: indexPath.row)
        else { return UITableViewCell() }
        cell.configureWith(cellModel)
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
