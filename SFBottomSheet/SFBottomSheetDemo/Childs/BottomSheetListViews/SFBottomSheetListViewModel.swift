//
//  SFBottomSheetListViewModel.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import Foundation

class SFBottomSheetListViewModel: SFBottomSheetListViewModelProtocol {
    
    // MARK: - Properties
    
    var dataSource: [SFBottomSheetTableViewCellModel] = []
    
    init() {
        setupData()
    }

    func numberOfCellsInSection(_ section: Int) -> Int {
        return dataSource.count
    }
    
    func cellData(for index: Int) -> SFBottomSheetTableViewCellModel? {
        guard dataSource.indices.contains(index) else { return nil}
        return dataSource[index]
    }
    
    private func setupData() {
        for index in 0...Int.random(in: 10...20) {
            dataSource.append(SFBottomSheetTableViewCellModel(title: "Title \(index)", description: "Description \(index)", balance: "\(1000 + index)"))
        }
    }
    
}
