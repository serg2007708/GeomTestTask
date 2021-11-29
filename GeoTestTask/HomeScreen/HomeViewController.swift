//
//  ViewController.swift
//  GeoTestTask
//
//  Created by Mayorov Genrikh on 25.10.2021.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

final class HomeViewController: UIViewController {
    private let viewModel: UsersListViewModel
    private let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navbar color fix for XCode 13
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        setupTableView()
        viewModel.getUsers()
        self.title = String.listTitle
    }
    
    private func showDetailScreen(user: User) {
        let detailVC = DetailedUserInfoViewController(viewModel: UserDetailsViewModel(with: user))
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func setupTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.register(UserCellView.self, forCellReuseIdentifier: UserCellView.cellIdentidier)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        
        tableView.rx.modelSelected(User.self).subscribe(onNext: { [weak self] item in
            self?.viewModel.didSelectUser(user: item)
        })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        })
            .disposed(by: disposeBag)
        
        viewModel.users.bind(
            to: tableView.rx.items(
                cellIdentifier: UserCellView.cellIdentidier,
                cellType: UserCellView.self
            )
        ) { row, item, cell in
            let viewModel = UserCellViewModel()
            cell.setData(viewModel: viewModel)
            viewModel.userName.onNext(item.fullName)
            viewModel.userAvatar.onNext(item.avatar)
        }
        .disposed(by: disposeBag)
        
        tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.getUsers()
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserCellView.cellHeight
    }
}
