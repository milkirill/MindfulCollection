//
//  ViewController.swift
//  MindfulCollection
//
//  Created by Kirill Milekhin on 25/09/2023.
//

import UIKit

class ViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width * 0.7, height: view.frame.height * 0.5)
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.clipsToBounds = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Collection"

        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 16
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        let targetContentOffsetX = targetContentOffset.pointee.x
        let targetItemPoint = CGPoint(x: targetContentOffsetX, y: collectionView.bounds.height / 2)

        guard let indexPath = collectionView.indexPathForItem(at: targetItemPoint),
              let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath),
              let minimumLineSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing
        else { return }

        let widthWithSpacing = layoutAttributes.frame.size.width + minimumLineSpacing
        targetContentOffset.pointee = CGPoint(x: round(targetContentOffsetX / widthWithSpacing) * widthWithSpacing, y: 0)
    }
}
