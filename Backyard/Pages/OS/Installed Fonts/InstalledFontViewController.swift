//
//  InstalledFontViewController.swift
//  Backyard
//
//  Created by Ho Lun Wan on 10/6/2025.
//

import Foundation
import UIKit
import Then
import TinyConstraints

class InstalledFontViewController: UIViewController {
    private let cellReuseIdentifier = "cell"
    private var fonts: [UIFont] = []
    private var dataSource: UITableViewDiffableDataSource<Int, UIFont>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Installed Fonts"
        
        let tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.do {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
//            $0.delegate = self
            $0.edgesToSuperview()
        }
        
        configureDataSource(tableView)
        rebuildSnapshot(animatingDifferences: false)
        
        Task {
            await loadInstalledFonts()
            rebuildSnapshot()
        }
    }

    private func configureDataSource(_ tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] (tableView, indexPath, font) -> UITableViewCell? in
            guard let self = self else { return nil }

            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = font.fontName
            configuration.textProperties.font = font
            cell.contentConfiguration = configuration

            return cell
        }
    }
    
    private func rebuildSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIFont>()
        snapshot.appendSections([0])
        snapshot.appendItems(fonts)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func loadInstalledFonts() async {
        fonts = []
        for familyName in UIFont.familyNames.sorted() {
            for fontName in UIFont.fontNames(forFamilyName: familyName).sorted() {
                let font = UIFont(name: fontName, size: UIFont.systemFontSize)!
                fonts.append(font)
            }
        }
    }
        
}
