//
//  ViewController.swift
//  Today
//
//  Created by Ольга Егорова on 17.12.2022.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    var dataSourse: DataSourse!
    var reminders: [Reminder] = Reminder.sampleData

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let listLayot = listLayot()
        collectionView.collectionViewLayout = listLayot
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSourse = DataSourse(collectionView: collectionView){ (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        var snapShot = SnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(reminders.map{ $0.id})
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

