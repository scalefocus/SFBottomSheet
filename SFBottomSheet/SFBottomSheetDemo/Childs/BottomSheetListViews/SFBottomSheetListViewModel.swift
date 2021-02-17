//
//  SFBottomSheetListViewModel.swift
//  SFBottomSheetDemo
//
//  Created by Aleksandar Gyuzelov on 16.02.21.
//

import Foundation

class SFBottomSheetListViewModel: SFBottomSheetListViewModelProtocol {
    
    // MARK: - Properties
    
    private var data: [SFBottomSheetTableViewCellModel] = []
    
    init() {
        setupData()
    }

    func numberOfCellsInSection(_ section: Int) -> Int {
        return data.count
    }
    
    func cellData(for index: Int) -> SFBottomSheetTableViewCellModel? {
        guard data.indices.contains(index) else { return nil}
        return data[index]
    }
    
    private func setupData() {
        for index in 0...Int.random(in: 10...20) {
            data.append(SFBottomSheetTableViewCellModel(title: "Title \(index)", description: "Description \(index)", balance: "\(1000 + index)"))
        }
    }
    
}
