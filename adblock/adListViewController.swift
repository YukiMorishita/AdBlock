import UIKit
import SafariServices

class adListViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // 予定
    class AdList {
    }
    
    /* App Groups */
    // Group ID
    let suiteName = "group.jp.ac.osakac.cs.hisalab.adblock"
    // Share Key
    let keyName = "shareData"
    
    // ブロックリストとスイッチのON・OFFを設定
    var adList = [(text: String, switchs: Bool)]()
    // 検索結果を設定
    var searchAdList = [(text: String, switchs: Bool)]()
    
    /* Outlet */
    // UINavigationBar
    @IBOutlet weak var navigationBar: UINavigationItem!
    // UISearchBar
    @IBOutlet weak var searchBar: UISearchBar!
    // UITableView
    @IBOutlet weak var tableView: UITableView!
    
    /* Action */
    // ナビゲーションバーの左側のボタンがタップされた時
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        // 左画のメニューを開く
        self.slideMenuController()?.openLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* ナビゲーションバーの設定 */
        // 端末に応じたタイトルの設定
        self.navigationBar.title = (firstLang().hasPrefix("ja")) ? "広告ブロック" : "Ads Block"
        
        /* スイッチ操作ボタンの設定 */
        let switchsStateButton = UIBarButtonItem()
        // イメージの設定
        let swichsStateButtonImage = UIImage(named: "switch-icon")
        switchsStateButton.image = swichsStateButtonImage
        // カラーの設定
        switchsStateButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // タップ時の処理設定
        switchsStateButton.action = #selector(switchsStateButtonTriggerd)
        // ナビゲーションバーの右側に設定
        self.navigationBar.rightBarButtonItem = switchsStateButton
        
        /* サーチバーの設定 */
        // キーボードタイプの設定
        self.searchBar.keyboardType = UIKeyboardType.URL
        
        /* テーブルビューの設定 */
        // タップの設定
        tableView.allowsSelection = false
        
        /* リフレッシュコントローラーの設定 */
        let refreshControler = UIRefreshControl()
        self.tableView.refreshControl = refreshControler
        refreshControler.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        /* ブロックリストの設定 */
        // 検索結果配列にデータをコピー
        self.searchAdList = self.createBlockList()
        
        /* デリゲートの設定 */
        searchBar.delegate = self
        tableView.delegate = self
        /* データソースの設定 */
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ブロックリストを管理するメソッド
    func createBlockList() -> [(text: String, switchs: Bool)] {
        // データの取得
        if let loadData = AppGroupsManager.loadData(key: "adList") {
            self.adList = loadData.map { (text: $0["text"], switchs: $0["switchs"]) } as! [(text: String, switchs: Bool)]
            
            /* JSON */
            // 共有フォルダに書き込み
            self.createJSONFile()
            
            // 保存されたデータがない場合
        } else {
            /* JSON */
            // 共有フォルダに書き込み
            self.createJSONFile()
            //　読み込んだJSONからurlのみを取得
            for url in self.createURLFilterArray() {
                // 要素を追加
                self.adList.append((text: url, switchs: false))
            }
        }
        
        /* シェアデータの設定 */
        // 保存されたシェアデータがある場合
        if let sharedLoadData: String = AppGroupsManager.sharedLoadData(key: self.keyName) {
            self.adList.append((text: sharedLoadData, switchs: false))
            
            // 保存されたシェアデータがない場合
        } else {
            print("Shared data does not exist")
        }
        
        // 保存された値を追加した時、保存された値を削除
        let sharedDefaults = UserDefaults(suiteName: self.suiteName)
        sharedDefaults?.removeObject(forKey: self.keyName)
        
        // データの保存
        let saveData: [[String: Any]] = self.adList.map { ["text": $0.text, "switchs": $0.switchs] }
        AppGroupsManager.saveData(data: saveData, key: "adList")
        
        return self.adList
    }
    
    // MARK - Language
    //端末で設定された先頭の言語を受け取るメソッド
    func firstLang() -> String {
        // 設定された言語の先頭を取得
        let prefLang = Locale.preferredLanguages.first
        return prefLang!
    }
    
    // MARK: - UISearchBar Delegete
    // 検索ボタンタップした時のメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /* キーボードの表示設定 */
        // 非表示
        searchBar.endEditing(true)
    }
    
    // 検索するメソッド
    func searchItems(searchText: String) {
        // 検索結果を格納した配列を空にする
        self.searchAdList.removeAll()
        
        // 文字列が入力された場合
        if searchText != "" {
            // 大文字・小文字を区別しない
            self.searchAdList = self.adList.filter { $0.text.lowercased().contains(self.searchBar.text!.lowercased()) }
        } else {
            // 文字列が空の場合は全てを表示
            self.searchAdList = adList
        }
        // テーブルを更新
        self.tableView.reloadData()
    }
    
    // テキスト変更時に呼ばれるメソッド
    func searchBar(_ sender: UISearchBar, textDidChange searchText: String) {
        // 検索
        searchItems(searchText: searchText)
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* テーブルビューセルの設定 */
        // 参照
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        // 値を設定
        cell.textLabel?.text = self.searchAdList[indexPath.row].text
        
        /* スイッチの設定 */
        let tableSwitch = UISwitch()
        // タグにセルの要素番号を設定
        tableSwitch.tag = indexPath.row
        // コールバックを設定
        tableSwitch.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)
        
        // スイッチデータを共通(再描画時のバグ解消)
        self.searchAdList[tableSwitch.tag].switchs = self.adList[tableSwitch.tag].switchs
        
        // tag番目の要素がtrueの場合
        if self.searchAdList[tableSwitch.tag].switchs == true {
            // ONに設定
            tableSwitch.isOn = true
        // それ以外の場合
        } else {
            // OFFに設定
            tableSwitch.isOn = false
        }
        
        // テーブルビューに表示
        cell.accessoryView = tableSwitch
        return cell
    }
    
    // スイッチをタップした時のコールバック
    @objc private func switchTriggered(sender: UISwitch) {
        /* スイッチの設定 */
        // 状態が変化した要素番号(adList内)を取得
        let searchIndex = self.adList.findIndex(includeElement: { $0 == (text: self.searchAdList[sender.tag].text,switchs:!sender.isOn)} )
        // 状態が変化した要素番号が取得できた場合
        if searchIndex.isEmpty == false {
            // tag番目の要素に状態を設定
            self.adList[searchIndex[0]].switchs = sender.isOn
        } else {
            print("error")
        }
        
        // データの保存
        let saveData: [[String: Any]] = self.adList.map { ["text": $0.text, "switchs": $0.switchs] }
        AppGroupsManager.saveData(data: saveData, key: "adList")
        
        /* JSON */
        // 共有ファイルにJSON文字列を書き込む
        self.createJSONFile()
        
        // コンテンツブロッカーを更新
        ContentBlockerManager.reloadContentBlocker()
    }
    
    // テーブルビューを更新するメソッド
    @objc private func refresh(sender: UIRefreshControl) {
        // 検索結果配列にデータをコピー
        self.searchAdList = self.createBlockList()
        // テーブルビューを更新
        self.tableView.reloadData()
        
        // 更新表示を非表示に設定
        sender.endRefreshing()
    }
    
    // スイッチの状態変更ボタンをタップした時のコールバック
    @objc private func switchsStateButtonTriggerd(sender: UIBarButtonItem) {
        /* アラートシートの設定 */
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // アラートシートのボタンを設定
        let Enable = UIAlertAction(title: "Enable All", style: .default)
        {
            (action: UIAlertAction) in
            // 以下Enableボタンがタップされた時の処理
            
            // adListのテキストを保存
            let textData = self.adList.map { $0.text }
            // リセット
            self.adList.removeAll()
            // データの書き換え
            for text in textData {
                self.adList.append( (text: text, switchs: true) )
            }
            
            // データの保存
            let saveData: [[String: Any]] = self.adList.map { ["text": $0.text, "switchs": $0.switchs] }
            AppGroupsManager.saveData(data: saveData, key: "adList")
            
            /* JSON */
            // 共有ファイルにJSON文字列を書き込む
            self.createJSONFile()
            
            // テーブルビューを更新
            self.tableView.reloadData()
            
            // コンテンツブロッカーを更新
            ContentBlockerManager.reloadContentBlocker()
        }
        
        let Disable = UIAlertAction(title: "Disable All", style: .default)
        {
            (action: UIAlertAction) in
            // 以下Enableボタンがタップされた時の処理
            
            // adListのテキストを保存
            let textData = self.adList.map { $0.text }
            // リセット
            self.adList.removeAll()
            // データの書き換え
            for text in textData {
                self.adList.append( (text: text, switchs: false) )
            }
            
            // データの保存
            let saveData: [[String: Any]] = self.adList.map { ["text": $0.text, "switchs": $0.switchs] }
            AppGroupsManager.saveData(data: saveData, key: "adList")
            
            /* JSON */
            // 共有ファイルにJSON文字列を書き込む
            self.createJSONFile()
            
            // テーブルビューを更新
            self.tableView.reloadData()
            
            // コンテンツブロッカーを更新
            ContentBlockerManager.reloadContentBlocker()
        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // ボタンの追加
        alert.addAction(Enable)
        alert.addAction(Disable)
        alert.addAction(Cancel)
        
        // アラートシートの表示
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableView Delegete
    // セルの個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの個数を設定
        return self.searchAdList.count
    }
    
    // MARK: - JSON
    // JSONファイルを取得するメソッド（ 共有ファイル || リソース ）
    func getJSONFile() -> String {
        // JSON文字列
        var json = ""
        // JSONファイルの名前
        let jsonFileName = "blockerList.json"
        /* ファイルマネージャーの設定 */
        let fileManager = FileManager.default
        // 共有ファイルのパス
        let containerURL = (fileManager.containerURL(forSecurityApplicationGroupIdentifier: suiteName)?.appendingPathComponent(jsonFileName))!.path
        // ファイルの有無
        let fileExists = fileManager.fileExists(atPath: containerURL)
        
        // JSONファイルのフルパスが存在する場合
        if fileExists {
            // JSONデータを文字列で設定
            let jsonData = try? String(contentsOfFile: containerURL, encoding: String.Encoding.utf8)
            // JSONデータをパース（解析）
            json = JSON(parseJSON: jsonData!).rawString()!
            
        // JSONファイルのフルパスが存在しない場合
        } else {
            // リソースのJSONファイルのパスを設定
            let resourcePath = Bundle.main.path(forResource: jsonFileName, ofType: nil)
            // JSONデータを文字列で設定
            let jsonData = try? String(contentsOfFile: resourcePath!, encoding: String.Encoding.utf8)
            // JSONデータをパース（解析）
            json = JSON(parseJSON: jsonData!).rawString()!
        }
        // JSON文字列を戻す
        return json
    }
    
    // 共有ファイルに書き込むメソッド
    func createJSONFile() {
        // 書き込むファイル名
        let jsonFileName = "blockerList.json"
        // フラグ
        var flag = false
        // 書き込むJSON文字列
        var jsonRule = ""
        
        /* ファイルマネージャーの設定 */
        let fileManager = FileManager.default
        // 共有ファイルのパス
        let containerURL = (fileManager.containerURL(forSecurityApplicationGroupIdentifier: suiteName)?.appendingPathComponent(jsonFileName))!.path
        // ファイルの有無
        let fileExists = fileManager.fileExists(atPath: containerURL)
        
        // ブロックリストからスイッチがONの状態のtextを取得
        let writeURL = adList.filter { $0.switchs == true }.map { $0.text }
        // 1回だけの処理
        flag = (flag == false) ? true : flag
        // 1度目の時は、カギカッコと改行, 2度目の時は、何もしない
        jsonRule += (flag == true) ? "[\n" : ""
        
        // writeURLに要素がある場合
        if writeURL.isEmpty == false {
            // writeURLの要素数繰り返す
            for url in writeURL {
                jsonRule +=
                """
                    {
                        "action": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": "\(url)",
                            "load-type": [
                                "third-party"
                            ]
                        }
                    }
                """
                
                // 繰り返しが途中なら改行してカンマ, 最後なら改行してカギカッコ
                jsonRule += (url != writeURL.last!) ? ",\n" : "\n]\n"
            }
            
            /* 書き込みの設定 */
            do {
                try jsonRule.write(toFile: containerURL, atomically: true, encoding: String.Encoding.utf8)
            // 書き込みに失敗した場合
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
            
        // 共有ファイルが存在し、書き込む文字列がない場合
        } else if fileExists && writeURL.isEmpty == true {
            print("not data")
            //　書き込むJSON文字列
            let jsonText =
            """
                [
                    {
                        "action": {
                            "type": "block"
                        },
                        "trigger": {
                            "url-filter": ".*",
                            "if-domain": [".*"]
                        }
                    }
                ]
            """
            
            // ファイルの書き込み(空白)
            do {
                try jsonText.write(toFile: containerURL, atomically: true, encoding: String.Encoding.utf8)
            // 書き込みに失敗した場合
            } catch let error as NSError {
                print("failed to write: \(error)")
            }
            
        // 共有ファイルを作らない
        } else {
            print("not create shared file")
        }
        
    }
    
    // JSON文字列からurl-filterのみを取得し、配列に格納するメソッド
    func createURLFilterArray() -> Array<String> {
        // JSONデータから取得したURLを設定
        var jsonURLArray = [String]()
        // JSONデータの文字列を設定
        let jsonText = JSON(parseJSON: self.getJSONFile())
        // JSONデータの要素数を設定
        let jsonCount = jsonText[].count
        
        // jsonTextに文字列がある場合
        if jsonText != "" {
            // JSON要素の数繰り返す 0から始まるが、リストの数は1から始まるため-1を行う
            for i in 0...jsonCount - 1 {
                // jsonデータのトリガからurl-filterを取得
                let jsonTriggerURL = jsonText[i]["trigger"]["url-filter"].rawString()
                // 配列に取得したJSONデータのurl-filterを設定
                jsonURLArray.append(jsonTriggerURL!)
            }
        }
        // JSONデータのurl-filterを設定し,配列を戻す
        return jsonURLArray
    }
    
}

// MARK: - Extension
// 配列の機能を拡張
extension Array {
    // 配列内の要素番号を取得するメソッド
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        // 要素番号を格納する配列
        var indexArray = [Int]()
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
}
