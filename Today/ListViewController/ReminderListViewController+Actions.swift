//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Ольга Егорова on 30.12.2022.
//

import Foundation
import UIKit

extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else {return}
        completeReminder(with: id)
    }
}
