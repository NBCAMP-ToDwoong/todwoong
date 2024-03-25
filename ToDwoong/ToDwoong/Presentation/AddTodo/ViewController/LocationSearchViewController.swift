//
//  LocationSearchViewController.swift
//  ToDwoong
//
//  Created by mirae on 3/23/24.
//

import MapKit
import UIKit

import SnapKit
import TodwoongDesign

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelectSearchResult(_ mapItem: MKMapItem)
}

class LocationSearchViewController: UITableViewController, UISearchResultsUpdating, MKLocalSearchCompleterDelegate {
    weak var delegate: SearchResultsViewControllerDelegate?
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseButton()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        searchCompleter.delegate = self
        let koreaCenter = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        let koreaRegion = MKCoordinateRegion(center: koreaCenter,
                                             latitudinalMeters: 1000000, // 1000km 범위
                                             longitudinalMeters: 1000000)
        searchCompleter.region = koreaRegion
        searchCompleter.resultTypes = [.address, .pointOfInterest]
    }
    
    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        closeButton.tintColor = TDStyle.color.mainTheme
        navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let completion = searchResults[indexPath.row]
        cell.textLabel?.text = "\(completion.title)\n\(completion.subtitle)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let response = response else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            if let mapItem = response.mapItems.first {
                self?.delegate?.didSelectSearchResult(mapItem)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
