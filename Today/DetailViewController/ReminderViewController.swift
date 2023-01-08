//
//  ReminderViewController.swift
//  Today
//
//  Created by Ольга Егорова on 31.12.2022.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    private typealias DataSourse = UICollectionViewDiffableDataSource<Section, Row>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder
    private var dataSourse: DataSourse!
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
        
    }
    
    required init?(coder: NSCoder){
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSourse = DataSourse(collectionView: collectionView){(collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        //UIViewController имеем свойство editButtonItem, нажатие на кнопку Edit автоматически переключает между режимами "Edit" и "Done" и вызывает метод setEditing(_:animated:). Присваиваем эту кнопку к правой кнопке navigation controller-a.
        navigationItem.rightBarButtonItem = editButtonItem
    
        updateSnapshotForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            updateSnapshotForEditing()
        } else {
            updateSnapshotForViewing()
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row){
        let section = section(for: indexPath)
        switch (section, row) {
        case(.view, _):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = text(for: row)
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguration.image = row.image
            cell.contentConfiguration = contentConfiguration
            
        default:
            fatalError("Unexpected combination of section and row.")
        }
        cell.tintColor = .todayPrimaryTint
    }
    
    func updateSnapshotForEditing() {
        var snapshot = SnapShot()
        snapshot.appendSections([.title, .date, .notes])
        dataSourse.apply(snapshot)
    }
    
    func updateSnapshotForViewing() {
        var snapshot = SnapShot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.viewTitle, .viewDate, .viewTime, .viewNotes],  toSection: .view)
        dataSourse.apply(snapshot)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matchin section")
        }
        return section
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .viewDate: return reminder.dueDate.dayText
        case .viewNotes: return reminder.notes
        case .viewTime: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .viewTitle: return reminder.title
        }
    }

   
}
