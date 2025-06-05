//
//  CatalogViewController.swift
//  Backyard
//
//  Created by Ho Lun Wan on 6/6/2025.
//

import UIKit
import Then
import TinyConstraints

private struct CatalogItemInfo: Hashable {
    let isExpanded: Bool
    let level: Int // Level of indentation or hierarchy depth
    let item: CatalogItem
    
    func copyWith(isExpanded: Bool? = nil, level: Int? = nil, item: CatalogItem? = nil) -> CatalogItemInfo {
        return CatalogItemInfo(
            isExpanded: isExpanded ?? self.isExpanded,
            level: level ?? self.level,
            item: item ?? self.item
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(item.id)
        hasher.combine(isExpanded)
        hasher.combine(level)
    }
    
    static func == (lhs: CatalogItemInfo, rhs: CatalogItemInfo) -> Bool {
        return lhs.item.id == rhs.item.id && lhs.isExpanded == rhs.isExpanded && lhs.level == rhs.level
    }
}

class CatalogViewController: UIViewController, UITableViewDelegate {
    private let cellReuseIdentifier = "cell"
    private let rootItems: [CatalogItem] = [
        CatalogItem(name: "OS", children: [
            CatalogItem(name: "Installed Fonts"),
        ]),
    ]
    private var itemInfoMap: [CatalogItem.ID: CatalogItemInfo] = [:]
    private var dataSource: UITableViewDiffableDataSource<Int, CatalogItem.ID>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Catalog"
        
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        view.addSubview(tableView)
        tableView.do {
            $0.register(CatalogItemCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            $0.delegate = self
            $0.edgesToSuperview()
        }
        
        buildItemInfoMap(&itemInfoMap, traversing: rootItems, level: 0)
        configureDataSource(tableView)
        rebuildSnapshot(animatingDifferences: false)
    }
    
    private func buildItemInfoMap(_ itemInfoMap: inout [CatalogItem.ID: CatalogItemInfo], traversing items: [CatalogItem], level: Int) {
        for item in items {
            // Default to not expanded
            itemInfoMap[item.id] = CatalogItemInfo(isExpanded: true, level: level, item: item)
            if let children = item.children {
                buildItemInfoMap(&itemInfoMap, traversing: children, level: level + 1) // Recursively traverse children
            }
        }
    }

    private func configureDataSource(_ tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] (tableView, indexPath, itemId) -> UITableViewCell? in
            guard let self = self, let itemInfo = self.itemInfoMap[itemId] else { return nil }

            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemInfo.item.name
            configuration.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
            
            if itemInfo.item.isSectionItem {
                updateCell(&configuration, isExpanded: itemInfo.isExpanded)
            }

            cell.contentConfiguration = configuration
            cell.indentationLevel = itemInfo.level

            return cell
        }
    }
    
    private func rebuildSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CatalogItem.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(buildSnapshotItems(for: rootItems))
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func buildSnapshotItems(for items: [CatalogItem]) -> [CatalogItem.ID] {
        var itemInfos: [CatalogItem.ID] = []
        for item in items {
            if let info = itemInfoMap[item.id] {
                itemInfos.append(item.id)
                if item.isSectionItem && info.isExpanded, let children = item.children {
                    itemInfos.append(contentsOf: buildSnapshotItems(for: children))
                }
            }
        }
        return itemInfos
    }
    
    private func updateCell(_ configuration: inout UIListContentConfiguration, isExpanded: Bool) {
        configuration.secondaryText = isExpanded ? "▼" : "▶"
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedItemId = dataSource.itemIdentifier(for: indexPath),
              let selectedItemInfo = itemInfoMap[selectedItemId],
              let cell: CatalogItemCell = tableView.cellForRow(at: indexPath) as? CatalogItemCell,
              var configuration = cell.contentConfiguration as? UIListContentConfiguration
        else { return }
        
        if selectedItemInfo.item.isSectionItem {
            // Toggle expansion for section items
            let updatedInfo = selectedItemInfo.copyWith(isExpanded: !selectedItemInfo.isExpanded)
            itemInfoMap[selectedItemInfo.item.id] = updatedInfo
            updateCell(&configuration, isExpanded: updatedInfo.isExpanded)
            cell.contentConfiguration = configuration
            rebuildSnapshot()
        } else {
            // Navigate to detail
        }
    }
}
