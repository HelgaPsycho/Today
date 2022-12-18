//
//  ViewController.swift
//  Today
//
//  Created by Ольга Егорова on 17.12.2022.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    typealias DataSourse = UICollectionViewDiffableDataSource<Int, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSourse: DataSourse!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let listLayot = listLayot()
        collectionView.collectionViewLayout = listLayot
        
        let cellRegistration = UICollectionView.CellRegistration{ (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let reminder =  Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        dataSourse = DataSourse(collectionView: collectionView){ (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        var snapShot = SnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(Reminder.sampleData.map{ $0.title})
        dataSourse.apply(snapShot)
        
        collectionView.dataSource = dataSourse
  }
    private func listLayot() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

