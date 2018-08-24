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
    // UISearchBar
    @IBOutlet weak var searchBar: UISearchBar!
    // UITableView
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* ナビゲーションバーの設定 */
        // 端末に応じたタイトルの設定
        //self.navigationBar.title = (firstLang().hasPrefix("ja")) ? "広告ブロック" : "Ads Block"
        
        /* イベント通知の登録 */
        // NotificationCenterに登録する
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(catchNotification(notification:)), name: .myNotificationName, object: nil)
        
        /* サーチバーの設定 */
        // キーボードタイプの設定
        self.searchBar.keyboardType = UIKeyboardType.URL
        
        /* テーブルビューの設定 */
        // タップの設定
        self.tableView.allowsSelection = false
        tableView.separatorColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        /* リフレッシュコントローラーの設定 */
        let refreshControler = UIRefreshControl()
        self.tableView.refreshControl = refreshControler
        refreshControler.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        /* ブロックリストの設定 */
        // 検索結果配列にデータをコピー
        searchAdList = createBlockList()
        
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
            // 共有フォルダに書き込み
            JSONManager.createJSONFile(adList: self.adList)
            
            // 保存されたデータがない場合
        } else {
            // 共有フォルダに書き込み
            JSONManager.createJSONFile(adList: self.adList)
            //　読み込んだJSONからurlのみを取得
            for url in JSONManager.createURLFilterArray() {
                // 要素を追加
                adList.append((text: url, switchs: false))
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
        ///キーボードの表示設定
        searchBar.endEditing(true)
    }
    
    // 検索するメソッド
    func searchItems(searchText: String) {
        // 検索結果を格納した配列を空にする
        searchAdList.removeAll()
        
        // 文字列が入力された場合
        if searchText != "" {
            // 大文字・小文字を区別しない
            self.searchAdList = adList.filter { $0.text.lowercased().contains(self.searchBar.text!.lowercased()) }
        } else {
            // 文字列が空の場合は全てを表示
            searchAdList = adList
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath)
        // 値を設定
        cell.textLabel?.text = searchAdList[indexPath.row].text
        
        /* スイッチの設定 */
        let tableSwitch = UISwitch()
        tableSwitch.onTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        // タグにセルの要素番号を設定
        tableSwitch.tag = indexPath.row
        // コールバックを設定
        tableSwitch.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)
        
        // スイッチデータを共通(再描画時のバグ解消)
        searchAdList[tableSwitch.tag].switchs = self.adList[tableSwitch.tag].switchs
        
        // tag番目の要素がtrueの場合
        if searchAdList[tableSwitch.tag].switchs == true {
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
        let searchIndex = adList.findIndex(includeElement: { $0 == (text: searchAdList[sender.tag].text,switchs:!sender.isOn)} )
        // 状態が変化した要素番号が取得できた場合
        if searchIndex.isEmpty == false {
            // tag番目の要素に状態を設定
            adList[searchIndex[0]].switchs = sender.isOn
        } else {
            print("error")
        }
        
        // データの保存
        let saveData: [[String: Any]] = adList.map { ["text": $0.text, "switchs": $0.switchs] }
        AppGroupsManager.saveData(data: saveData, key: "adList")
        
        /* JSON */
        // 共有ファイルにJSON文字列を書き込む
        JSONManager.createJSONFile(adList: self.adList)
        
        // コンテンツブロッカーを更新
        ContentBlockerManager.reloadContentBlocker()
    }
    
    // テーブルビューを更新するメソッド
    @objc private func refresh(sender: UIRefreshControl) {
        // 検索結果配列にデータをコピー
        searchAdList = createBlockList()
        // テーブルビューを更新
        self.tableView.reloadData()
        
        // 更新表示を非表示に設定
        sender.endRefreshing()
    }
    
    // イベント通知を受け取りテーブルを更新するメソッド
    @objc func catchNotification(notification: Notification) {
        // テーブルビューを更新
        searchAdList = createBlockList()
        self.tableView.reloadData()
    }
    
    // MARK: - UITableView Delegete
    // セルの個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの個数を設定
        return searchAdList.count
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
