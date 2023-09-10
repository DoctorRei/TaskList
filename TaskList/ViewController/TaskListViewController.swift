//
//  ViewController.swift
//  TaskList
//
//  Created by Alexey Efimov on 02.04.2023.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private let cellID = "task"
    private let dataStore = StorageManager.shared
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
        
    }
    
    private func addNewTask() {
        showAddTaskAlert(withTitle: "New Task", andMessage: "What do you want to do?")
    }
    	
    
    // MARK: - Alert Controllers
    
    private func showAddTaskAlert(withTitle title: String, andMessage message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { [weak self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self?.save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func showEditTaskAlert(withTitle title: String, andMessage message: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let editConformAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let taskEddit = alert.textFields?.first?.text, !taskEddit.isEmpty else { return }
            completion(taskEddit)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(editConformAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Edit Task"
        }
        
        
        present(alert, animated: true)
        
    }
    
    // MARK: - Private Support methods
    
    private func fetchData() {
        dataStore.fetchData { [unowned self] result in
            switch result {
            case .success(let taskList):
                self.taskList = taskList
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func save(_ taskName: String) {
        dataStore.create(taskName) { task in
            taskList.append(task)
            tableView.insertRows(at: [IndexPath(row: self.taskList.count - 1, section: 0)], with: .automatic)
        }
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [unowned self] _ in
                addNewTask()
            }
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showEditTaskAlert(withTitle: "Edit", andMessage: "") { [unowned self] edditTask in
            self.dataStore.edditing(task, newValue: edditTask)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        // Этот код просто моя гордость. Плевать, как он ущербен, но я смог сам написать комплишен, реализовать его и все получилось! Я уже всю уверенность потерять, а тут смог все сделать! Захватил из другого аллерта текст из текстфилда, перенес сюда и заюзал!
        // Единственное, что у меня тут проблема. Я выбираю одну строку - редактирование не вызывается. Я выбираю другую строку - вызывается редактирование. И при редактировании изменяется та строка, которую я выбирал до этого. + Диселект роу не работает почему-то. Но честно, я уже обозлен на это задание и весь учебный настрой оно мне сбило. Можно щемить меня упреками, все принимаю, только подскажите как эту фигню пофиксить ))
        
    
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            dataStore.delete(that: task)
        }
    }
    
    
    
}
