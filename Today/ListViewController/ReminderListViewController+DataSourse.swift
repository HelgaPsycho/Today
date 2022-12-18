//
//  ReminderListViewController+DataSourse.swift
//  Today
//
//  Created by Ольга Егорова on 18.12.2022.
//

import UIKit

extension ReminderListViewController {
    typealias DataSourse = UICollectionViewDiffableDataSource<Int, String>
    //UICollectionViewDiffableDataSource - обеспечивает поведение, которое эффективно и безопасно управляет обновлениями данных вашего представления коллекции.
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>
    
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String){
        let reminder =  Reminder.sampleData[indexPath.item]
        //1. запрашиваем временный экземпляр конфигурации ячейки:
        var contentConfiguration = cell.defaultContentConfiguration()
       //2. устанавливаем значения для свойств, котторые хотим изменить
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        //3. присваиваем свойства конфигурации обратно ячейке
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = UIColor(named: "todayListCellDoneButtonTint")
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = UIColor(named: "todayBackgroundColor")
        cell.backgroundConfiguration = backgroundConfiguration
        
        // UICollectionViewListCell имеет 3 конфигуриремых свойства:
          //contentConfiguration — Describes the cell’s labels, images, buttons, and more
       //   backgroundConfiguration — Describes the cell’s background color, gradient, image, and other visual attributes
      //    configurationState — Describes the cell’s style when the user selects, highlights, drags, or otherwise interacts with it
    }
    
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = UIButton()
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
}
