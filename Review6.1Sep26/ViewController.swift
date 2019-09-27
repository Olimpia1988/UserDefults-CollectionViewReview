import UIKit

class ViewController: UIViewController {
    
    var imageForCell = UIImage()
    
    var books = [BookGeneralInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.BookCollectionView.reloadData()
            }
        }
    }
    
    var bookCathegories = [Results]() {
        didSet {
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    var bookItems = [BookItems]() {
        didSet {
            DispatchQueue.main.async {
                self.BookCollectionView.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var BookCollectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesSetUp()
        loadBookIteams()
        loadData()
        loadCathegoriesData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCathegoriesData()
        loadData()
        
    }
    
    func loadCathegoriesData() {
        if let category = UserDefaults.standard.object(forKey: "categories") as? String {
            loadGeneralData(keyword: category)
        } else {
            loadGeneralData(keyword: "humor")
        }
    }
    
    
    func loadBookIteams() {
        if let category = UserDefaults.standard.object(forKey: "categories") as? String {
            APIManager.manager.getBook(category: category ) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let data):
                        self.bookItems = data
                    
                    }
                }
            }
        } else {
            loadGeneralData(keyword: "humor")
        }
        
       
    }
    
    
    
    @IBAction func showPickerView(_ sender: Any) {
        self.pickerView.isHidden = false
    }
    
    
    func delegatesSetUp() {
        self.pickerView.isHidden = true
        BookCollectionView.dataSource = self
        BookCollectionView.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    
    func loadGeneralData(keyword: String) {
        BookGeneralData.manager.getGeneralData(cathegory: keyword) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                self.books = data
            }
        }
        
    }
    
    
    
    func loadData() {
        APIMAnagerWithCathegories.manager.getCathegories { (results) in
            switch results {
            case .failure(let error):
                print(error)
            case .success(let data):
                do {
                    self.bookCathegories = data
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell else { return UICollectionViewCell() }
        let singleBook = books[indexPath.row]
   
        cell.label.text = singleBook.bookDetails[0].title
//        
//        ImageHelper.shared.getImage(urlStr: bookItems[0].volumeInfo.imageLinks.smallThumbnail, completionHandler: { (resutl) in
//            switch resutl {
//            case .failure(let error):
//                print(error)
//            case .success(let image):
//                cell.image.image = image
//                
//            }
//        })
        

          return cell
        
                }
    
            }

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookCathegories.count
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categories = bookCathegories[row]
        return categories.listName
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadGeneralData(keyword: bookCathegories[row].listName)
        UserDefaults.standard.set(bookCathegories[row].listName, forKey: "categories")
    }
    
}
