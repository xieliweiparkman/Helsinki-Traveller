//
//  MainViewController.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MainViewModelProtocol!
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindUI()
        bindViewModel()
    }

    func bindUI() {
        UserDefaults.standard.rx
            .observe([String: Event].self, "favouriteEvents")
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.favouriateEvents.accept(UserDefaultsManager.shared.favouriteEventsArray())
                //self?.tableView.reloadData()
            }).disposed(by: bag)
    }
    
    func bindViewModel() {
        viewModel.cleanEvents.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.didAddedEvent.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.didAddEventToAlert()
        }).disposed(by: bag)
        
        viewModel.didRemovedEvent.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.didRemoveEventFromAlert()
        }).disposed(by: bag)
        
        viewModel.error.subscribe(onNext: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.showErrorAlert(error: error.description)
        }).disposed(by: bag)
    }
    
    func didAddEventToAlert() {
        let alert = UIAlertController(title: "Did add this event to your calendar", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.view.tintColor = UIColor.appGreenColor()
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func didRemoveEventFromAlert() {
        let alert = UIAlertController(title: "Did remove this event from your calendar", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.view.tintColor = UIColor.appGreenColor()
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Oops", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.view.tintColor = UIColor.appGreenColor()
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: appWidth, height: 60))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: appWidth-40, height: 60))
        label.font = UIFont.appSemiBoldFont(size: 20)
        label.textColor = UIColor.appBlackColor()
        view.addSubview(label)
        
        let button = UIButton(frame: CGRect(x: appWidth - 150, y: 0, width: 130, height: 60))
        button.setTitleColor(UIColor.appBlackColor(), for: .normal)
        button.setTitle("View on map", for: .normal)
        button.titleLabel?.font = UIFont.appRegularFont(size: 14)
        button.titleLabel?.contentMode = .right
        
        switch section {
        case 1:
            label.text = "Events"
            view.addSubview(button)
            button.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.transition.onNext(.ShowMapViewController(isEvent: true))
            }).disposed(by: bag)
        case 2:
            label.text = "Places"
            view.addSubview(button)
            button.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.transition.onNext(.ShowMapViewController(isEvent: false))
            }).disposed(by: bag)
        default:
            label.text = "My favouriate events"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell
        cell.viewModel = viewModel
        cell.configure()
        cell.tag = indexPath.section
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FavouriteTableViewCell else { return }
        cell.collectionView.reloadData()
        cell.collectionView.contentOffset.x = viewModel.storedOffsets[cell.tag] ?? 0

    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FavouriteTableViewCell else { return }
        viewModel.storedOffsets[cell.tag] = cell.collectionView.contentOffset.x

    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}
