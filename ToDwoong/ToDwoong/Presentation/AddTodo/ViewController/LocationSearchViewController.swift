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
    func didSelectSearchResult(_ mapItem: MKMapItem, at coordinate: CLLocationCoordinate2D)
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
                                             latitudinalMeters: 1000000,
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
    
    func cleanUpAddress(_ address: String) -> String {
        let withoutPostalCode = address.replacingOccurrences(of: "\\d{5,}", with: "", options: .regularExpression)
        let withoutCountryName = withoutPostalCode.replacingOccurrences(of: "대한민국", with: "")
        
        let cleanedAddress = withoutCountryName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ", ,", with: ",")
            .trimmingCharacters(in: CharacterSet(charactersIn: ", "))
        
        return cleanedAddress
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let completion = searchResults[indexPath.row]
        
        let searchText = searchController.searchBar.text ?? ""
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: TDStyle.font.title3(style: .bold)]
        let attributedTitle = NSMutableAttributedString(string: completion.title, attributes: titleAttributes)
        
        if !searchText.isEmpty {
            let range = (completion.title as NSString).range(of: searchText, options: .caseInsensitive)
            if range.location != NSNotFound {
                attributedTitle.addAttribute(.foregroundColor, value: TDStyle.color.mainDarkTheme, range: range)
            }
        }

        let subtitle = cleanUpAddress(completion.subtitle)
        if !subtitle.isEmpty {
            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: TDStyle.font.body(style: .regular),
                .foregroundColor: UIColor.gray
            ]
            let attributedSubtitle = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
            attributedTitle.append(attributedSubtitle)
        }

        cell.textLabel?.attributedText = attributedTitle
        cell.textLabel?.numberOfLines = 0

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let response = response, let mapItem = response.mapItems.first else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let coordinate = mapItem.placemark.coordinate
            self?.searchController.isActive = false
            self?.delegate?.didSelectSearchResult(mapItem, at: coordinate)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
}
