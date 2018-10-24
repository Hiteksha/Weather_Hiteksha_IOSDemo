//
//  ViewController.swift
//  Weather_Hiteksha_IOSDemo
//
//  Created by Hiteksha G. Kathiriya on 20/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var btnFavorite: UIButton!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblAddressDetail: UILabel!
    @IBOutlet var lblAddressName: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblState: UILabel!
    
    var resultSearchController:UISearchController? = nil

    var selectedPin:MKPlacemark? = nil
    var arrBookMark:NSMutableArray = []
    
    
    @IBOutlet var objTableView: UIView!
    var matchingItems:[MKPlacemark] = []
    @IBOutlet var objtbl: UITableView!
    @IBOutlet var objView: UIView!
    @IBOutlet var objBookmarkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objTableView.isHidden = true
        objView.isHidden = true
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self

        let myColor = UIColor.lightGray
        btnFavorite.layer.borderColor = myColor.cgColor
        btnFavorite.layer.cornerRadius = 10
        btnFavorite.layer.borderWidth = 1.0
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        if (!objView.isHidden)
        {
            objView.isHidden = true;
            
            if(matchingItems.count != 0)
            {
                objTableView.isHidden = false;
                objtbl.delegate = self;
                objtbl.dataSource = self;
                objtbl.reloadData()
            }
            else
            {
                objBookmarkView.isHidden = false;
                objTableView.isHidden = true;
            }
        }
        else
        {
            objView.isHidden = false;
            objTableView.isHidden = true;
        }
        
    }
    
    @IBAction func btnFavoriteclick(_ sender: Any)
    {
        if(!btnFavorite.isSelected)
        {
             btnFavorite.isSelected = true
            if let mi = selectedPin as? MKPlacemark {
                matchingItems.append(mi)
            }
        }

        else
        {
            btnFavorite.isSelected = false
        }
    }
    
   
    @IBAction func btnHelpClick(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController
      
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnBookMarkClick(_ sender: Any)
    {
        if(matchingItems.count != 0)
        {
            objTableView.isHidden = false
            objBookmarkView.isHidden = true
            objView.isHidden = true
        }
        else
        {
            let alertController = UIAlertController(title: "No bookmark location.", message: nil, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row]
        cell.textLabel?.text = selectedItem.name
        var city = selectedItem.locality
        if ((city ?? "").isEmpty)
        {
            city = ""
        }
        else
        {
            city = selectedItem.locality
        }
        var state = selectedItem.administrativeArea
        if ((state ?? "").isEmpty){
            state = ""
        }
        else
        {
            state = selectedItem.administrativeArea
        }
        var cuntry = selectedItem.country
       
        if ((cuntry ?? "").isEmpty){
            cuntry = ""
        }
        else
        {
            cuntry = selectedItem.country
        }
        let space = " "
        cell.detailTextLabel?.text = city! + space + state! + space + cuntry!
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            matchingItems.remove(at: indexPath.row)
            if(matchingItems.count != 0)
            {
                objTableView.isHidden = false
                 objtbl.reloadData()
                
            }
            else
            {
                
                 objtbl.reloadData()
                objTableView.isHidden = true;
                objBookmarkView.isHidden = false;
                
            }
           
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        vc?.Latitude = Float(selectedItem.coordinate.latitude)
        vc?.Longitude = Float(selectedItem.coordinate.longitude)
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            let space = " "
            annotation.subtitle = city + space + state
        }
            objView.isHidden = false
            objTableView.isHidden = true
            objBookmarkView.isHidden = true
       btnFavorite.isSelected = false
        lblAddressName.text = placemark.title
        lblAddressDetail.text = placemark.name
        lblCity.text = placemark.locality
        lblState.text = placemark.administrativeArea
        lblCountry.text = placemark.country
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation
        {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
         let button = UIButton(frame: CGRect(origin: CGPoint(), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: [])
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    @objc func getDirections()
    {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}
