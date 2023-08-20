//
//  HomeViewController.swift
//  MovieFlim
//
//  Created by MACBOOK on 05/08/2023.
//

import UIKit

enum Section: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcomming = 3
    case Toprated = 4
}

class HomeViewController: UIViewController {
    private var randomTrendingMovie: Movie?
    
    private var headerView: HeroHeaderUIView?
    
    
    let sectionTitles: [String] = ["Trending Movies","Trending TV","Popular","UpComming Movies","Top Rated"]
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero,style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 470))
        homeFeedTable.tableHeaderView = headerView
        configNabBar()
        fetchData()
        configureHeroHeaderview()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        
    }
    private func fetchData() {
//        APIcaller.shared.getTrendingMovies{ results in
//            switch results{
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//
//
//        APIcaller.shared.getTrendingTvs{ results in
//
//        }
       
//
    }
    
    private func configureHeroHeaderview() {
        APIcaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case.success(let movies):
                let selectedTitle = movies.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configureX(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func configNabBar() {
        var  image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .black
    }
    
    

   

}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:
            APIcaller.shared.getTrendingMovies{ result in
                switch result {
                case .success(let movie):
                    cell.configure(with: movie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TrendingTv.rawValue:
            APIcaller.shared.getTrendingTvs{ result in
                switch result {
                case .success(let movie):
                    cell.configure(with: movie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Popular.rawValue:
            APIcaller.shared.getPopular{ result in
                switch result {
                case .success(let movie):
                    cell.configure(with: movie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Section.Upcomming.rawValue:
            APIcaller.shared.getUpCommingMovie{ result in
                switch result {
                case .success(let movie):
                    cell.configure(with: movie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Toprated.rawValue:
            APIcaller.shared.getTopRated{ result in
                switch result {
                case .success(let movie):
                    cell.configure(with: movie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
           
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset  = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 10, height: header.bounds.height)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.UpperCaseFirstLetter()
    }
    
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDIdTapCell(_cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
