//
//  CL01ViewController.swift
//  CL01
//
//  Created by Ho Lun Wan on 31/5/2025.
//

import UIKit
import Then
import TinyConstraints

class CL01ViewController: UIViewController, CL01Delegate {
    private let collectionViewLayout = CL01()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private var dataSource: UICollectionViewDiffableDataSource<Int, CL01CategoryItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.do {
            $0.backgroundColor = .systemGroupedBackground
        }
        collectionView.do {
            $0.register(CL01Cell.self, forCellWithReuseIdentifier: "cell")
            $0.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            $0.backgroundColor = .white
            $0.delegate = self
            $0.height(80)
            $0.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let customCell = cell as? CL01Cell {
                customCell.title = itemIdentifier.title
            }
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            let items = await getCL01CategoryItems()
            var snapshot = NSDiffableDataSourceSnapshot<Int, CL01CategoryItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(items)
            await dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func getCL01CategoryItems() async -> [CL01CategoryItem] {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        let items: [CL01CategoryItem] = [
            CL01CategoryItem(title: "Cat", previewImageUrlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk6bAdCzXynKz3ycAf4L01YXR-vnGTxc3olQ&s"),
            CL01CategoryItem(title: "Dog (Also called the domestic dog)", previewImageUrlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLEK0P9kcqYGl4muF8RFCY0NBsp19bTOduEA&s"),
            CL01CategoryItem(title: "Bird", previewImageUrlString: "https://isteam.wsimg.com/ip/1e359bb4-cabe-4e03-bd77-8db8ba90a350/Galah-Australia-3451.jpg/:/cr=t:0%25,l:0%25,w:100%25,h:91.33%25/rs=w:365,h:365,cg:true"),
            CL01CategoryItem(title: "Horse (Equus ferus caballus)", previewImageUrlString: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSC-pCj2nPOw3PRCkLKarXYxwRCeRHTESNtX2pZVzNPbwc719ctXjIqv53RtzNEH9cLi9pTZwjLYQxtbYg6BRwCGpzokMnPUdM_HDeasU_U"),
            CL01CategoryItem(title: "Cow (Mature female cattle)", previewImageUrlString: "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTYleSSoZ9R7Q5n_FtfI2hGSgQBOqVmHcdybNBPO84zCFydSioQb71IOP0a6vqrSgV2q5fKIksB9wnDx7gDH8YB3OOoMW3iikDgkhJfiMjE"),
            CL01CategoryItem(title: "Sheep", previewImageUrlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG3otKEabgklGfEJdsv_N7Gr3ritOltVidGrX62_yraaRviOTJFbzRk17wayOMuyCCwOUIdLeoVMEdZWJ9sU-3UFfEB8AkLGY5uUnmUthcqQ"),
        ]
        return items
    }
    
    // MARK: - CL01Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CL01, titleForItemAt indexPath: IndexPath) -> NSAttributedString {
        let title = dataSource.snapshot().itemIdentifiers(inSection: indexPath.section)[indexPath.item].title
        return CL01Cell.attributedTitle(title)
    }
}
