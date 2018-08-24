//
//  LeftMenuViewController.swift
//  adblock
//
//  Created by admin on 2018/08/10.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UITabelView
    @IBOutlet weak var tableView: UITableView!
    
    let sectionTitle = ["高度なブロック", "設定", "使い方"]
    let section0 = ["アクセス解析をブロック", "ソーシャルボタンをブロック", "セレクタをブロック", "画像をブロック"]
    let section1 = ["すべてのブロックリストの有効化・無効化", "テーマカラー"]
    let section2 = ["ブロックリストの有効化", "ブロックリストの追加", "ブロックリストの共有"]
    
    // メニューに表示する値を設定( 多言語対応 )
    var menuList: [String] = []
    let menuListEN: [String] = ["○  adblock", "○  Swift", "○  iPhone"]
    let menuListJA: [String] = ["○  アドブロック","○  スウィフト","○  アイフォン"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 端末の言語に応じてmenuListを設定
        menuList = (firstLang().hasPrefix("ja")) ? menuListJA : menuListEN
        
        // ステータスバーを非表示に設定
        self.setNeedsStatusBarAppearanceUpdate()
        
        // 使用していないセルを非表示に設定
        //tableView.tableFooterView = UIView(frame: .zero)
        // テーブルビューのセパレータを非表示に設定
        tableView.separatorStyle = .none
        
        // テーブルビューのデータソースを設定
        tableView.dataSource = self
        // テーブルビューのデリゲートを設定
        tableView.delegate = self
    }
    
    // ステータスバーを非表示にするメソッド
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    // セルに値を設定するメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // テーブルのセルを参照する
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(section0[indexPath.row])"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(section1[indexPath.row])"
        } else if indexPath.section == 2 {
            cell.textLabel?.text = "\(section2[indexPath.row])"
        }
        
        // セルに表示する文字色を白に設定
        cell.textLabel?.textColor = #colorLiteral(red: 0.8872416945, green: 0.8791114916, blue: 0.8789492458, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Custom", size: 28)
        
        // セル選択時の色を設定
        let selectedView = UIView()
        selectedView.backgroundColor = #colorLiteral(red: 0.6785587072, green: 0.1762746572, blue: 0.2450017035, alpha: 1)
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    // MARK: - UITableViewDelegete
    
    // セルの個数を設定するメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの個数を設定
        if section == 0 {
            return section0.count
        } else if section == 1 {
            return section1.count
        } else if section == 2 {
            return section2.count
        } else {
            return 0
        }
    }
    
    // セクション数を返すメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // セクションタイトルを返すメソッド
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    // セルが選択された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択状態を解除
        tableView.deselectRow(at: indexPath, animated: false)
        // タップした行を取得する
        if indexPath.section == 0 {
            print("\(section0[indexPath.row])")
        } else if indexPath.section == 1 {
            print("\(section1[indexPath.row])")
        } else if indexPath.section == 2 {
            print("\(section2[indexPath.row])")
        }
    }
    
    // MARK - Language
    
    //端末で設定された先頭の言語を受け取るメソッド
    func firstLang() -> String {
        // 設定された言語の先頭を取得
        let prefLang = Locale.preferredLanguages.first
        
        return prefLang!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
