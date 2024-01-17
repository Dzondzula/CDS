//
//  AllUsersViewController.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 13.1.22..
//
import FirebaseDatabase
import Firebase
import UIKit

protocol MemberListDelegate: AnyObject {
    func fetchMembers(completion: @escaping ([UserInfo]) -> Void)
}


class MemebersViewController: UIViewController {
    var navController: UINavigationController!
    var dataManager: ClientManager!
    var viewModel: MemberTableViewModel!
    var filteredUsers: [UserInfo] = []
    var didSendSingOutEvent: (() -> Void)!

    weak var coordinator: AdminMembersCoordinator?

    init(navController: UINavigationController) {
        super.init(nibName: nil, bundle: nil)
        self.navController = navController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)

        table.delegate = self
        table.dataSource = self
        table.separatorColor = .clear
        table.register(MemberTableViewCellSwiftUI.self, forCellReuseIdentifier: "userCell")
        return table
    }()

     var searchController: UISearchController!

    deinit {
    print("DEINITIALIZED ALLUSERS")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.fetchMembers { [weak self] members in
            self?.viewModel.members = members
            self?.tableView.reloadData()
            print(members)
        }
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))
        self.navigationItem.rightBarButtonItem = signOutButton
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white

        view.addSubview(tableView)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find fighter"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["All", "Active", "Expired"]
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self

        self.navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataManager.checkPaymentStatus()
    }


    enum NetworkError: Error {
        case noDataAvailable
        case canNotProcessData
    }
    @objc private func signOutTapped() {

        //        guard let user = Auth.auth().currentUser else {return}
        //        let onlineRef = DataObjects.rootRef.child("online/\(user.uid)")
        //
        //        onlineRef.removeValue { error,_ in
        //            print("removing failed")
        //            return
        //        }

        do {
            try Auth.auth().signOut()
            resetDefaults()
            didSendSingOutEvent()
           // coordinator?.parentCoordinator?.finish()
            // self.navigationController?.popToRootViewController(animated: true)

        } catch {
            print("Auth sign out failed")
        }
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension MemebersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
        return viewModel.members.count - 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as! MemberTableViewCellSwiftUI
        if isFiltering {
            let model = viewModel.memberViewModel(users: filteredUsers, for: indexPath.row)
            return  MemberTableViewCellSwiftUI(member: model)
        }

        let model = viewModel.memberViewModel(users: viewModel.members, for: indexPath.row)
        return  MemberTableViewCellSwiftUI(member: model)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        coordinator?.showMember(viewModel.members[indexPath.row])
    }
}



extension MemebersViewController: UISearchResultsUpdating, UISearchBarDelegate {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
        searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive &&
        (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, category: selectedScope)
        print("Selected scope \(selectedScope)")
    }
    func filterContentForSearchText(_ searchText: String,
                                    category: Int) {
        filteredUsers = viewModel.members.filter { (user: UserInfo) -> Bool in
            let doesCategoryMatch = category == 0
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && !user.admin && (user.firstName.lowercased().contains(searchText.lowercased()) || user.lastName.lowercased().contains(searchText.lowercased()))
            }
        }
print("Category \(category)")
        tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!, category: searchController.searchBar.selectedScopeButtonIndex)
    }

    func setUpElements() {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.isTranslucent = false
    }
}

 typealias Dispatch = DispatchQueue

 extension Dispatch {

    static func background(_ task: @escaping () -> ()) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }

    static func main(_ task: @escaping () -> ()) {
        Dispatch.main.async {
            task()
        }
    }
 }
// Usage :
//
// Dispatch.background {
//    // do stuff
//
//    Dispatch.main {
//        // update UI
//    }
// }
