//
//  ReminderListViewController+DataSourse.swift
//  Today
//
//  Created by Ольга Егорова on 18.12.2022.
//

import UIKit

extension ReminderListViewController {
    typealias DataSourse = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    //UICollectionViewDiffableDataSource - обеспечивает поведение, которое эффективно и безопасно управляет обновлениями данных вашего представления коллекции.
    
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder comleted value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapShot = SnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(reminders.map{ $0.id })
        if !ids.isEmpty {
            snapShot.reloadItems(ids)
        }
        dataSourse.apply(snapShot)
    }
    
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID){
        let reminder =  reminder(for: id)
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
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = UIColor(named: "todayBackgroundColor")
        cell.backgroundConfiguration = backgroundConfiguration
        
        // UICollectionViewListCell имеет 3 конфигуриремых свойства:
          //contentConfiguration — Describes the cell’s labels, images, buttons, and more
       //   backgroundConfiguration — Describes the cell’s background color, gradient, image, and other visual attributes
      //    configurationState — Describes the cell’s style when the user selects, highlights, drags, or otherwise interacts with it
    }
    
    func completeReminder(with id: Reminder.ID){
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self]action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        return action
    }
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func update(_ reminder: Reminder, with id: Reminder.ID){
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
}
