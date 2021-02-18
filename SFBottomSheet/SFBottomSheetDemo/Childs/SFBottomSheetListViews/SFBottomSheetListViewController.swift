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
    
    weak var delegate: SFBottomSheetChildDelegate?

    fileprivate var viewModel: SFBottomSheetListViewModelProtocol!

    // MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!

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
        let contentHeight = CGFloat(viewModel.dataSource.count) * defaultRowHeight
        let eligibleCellCounts = Int(maximumAvailableContainerHeight / defaultRowHeight)
        let eligibleContainerHeight = defaultRowHeight * CGFloat(eligibleCellCounts)
        defaultContainerHeight = min(eligibleContainerHeight, contentHeight)
        if defaultContainerHeight == contentHeight {
            tableView.isScrollEnabled = false
        }
        return defaultContainerHeight
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
        print(viewModel.dataSource[indexPath.row])
        dismiss(animated: true)
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
