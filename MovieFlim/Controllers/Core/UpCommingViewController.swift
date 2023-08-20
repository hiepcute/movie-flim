//
//  UpCommingViewController.swift
//  MovieFlim
//
//  Created by MACBOOK on 05/08/2023.
//

import UIKit

class UpCommingViewController: UIViewController {
    private lazy var upCommingTable: UITableView  = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()
    public var titles: [Movie] = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcomming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode  = .always
        view.addSubview(upCommingTable)
        upCommingTable.delegate = self
        upCommingTable.dataSource = self
        fetchUpcomming()

       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upCommingTable.frame = view.bounds
    }
    private func fetchUpcomming() {
        APIcaller.shared.getUpCommingMovie{[weak self] result in
            switch result {
            case.success(let movie):
                self?.titles = movie
                DispatchQueue.main.async {
                    self?.upCommingTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        
            
        }
    }
    
}

extension UpCommingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "unknown" , posterURL: title.poster_path ?? ""
                                           ))
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        APIcaller.shared.getMovie(with: titleName) {[weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                self?.navigationController?.pushViewController(vc, animated: true)
            }
              
                
            case . failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


