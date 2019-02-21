//
//  ViewController.swift
//  coreDataSample
//
//  Created by Ahmet Öztemiz on 21.02.2019.
//  Copyright © 2019 Ahmet Öztemiz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var wordsModel: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Core Data Sample"
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEntity(entityTitle: "WordsModel")
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Kelime Oluştur",
                                      message: "Oluşturmak istediğiniz kelimeyi giriniz.",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Kaydet", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let wordToSave = textField.text else {
                    return
            }
            
            self.saveAttribute(name: wordToSave, entityTitle: "WordsModel", key: "word")
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func saveAttribute(name: String,  entityTitle: String, key: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName:  entityTitle, in: managedContext)!
        
        let word = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        word.setValue(name, forKeyPath: key)
        
        // 4
        do {
            try managedContext.save()
            wordsModel.append(word)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchEntity(entityTitle: String) {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityTitle)
        
        //3
        do {
            wordsModel = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let word = wordsModel[indexPath.row]
        
        
        cell.textLabel?.text = word.value(forKeyPath: "word") as? String
        
        return cell
    }
}

