//
//  SearchResultViewController.swift
//  MovieFlim
//
//  Created by MACBOOK on 16/08/2023.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func SearchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
    
}

class SearchResultViewController: UIViewController {
    public weak var delegate: SearchResultViewControllerDelegate?
    
    
    
    public var titles: [Movie] = [Movie]()
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    

    

}
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        let titleName = title.original_title ?? ""
        APIcaller.shared.getMovie(with: titleName ) {[weak self] result in
            switch result {
            case .success(let videoElement):
                print("videoElement",videoElement)
                DispatchQueue.main.async {
                    self?.delegate?.SearchResultViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_name ?? "",  youtubeView: videoElement, titleOverview: title.overview ?? ""))
            }
              
            case . failure(let error):
                print(error.localizedDescription)
            }
        }

    
    
      
        
    }
    
    
    
}
