//
//  ViewController.swift
//  Weather_Hiteksha_IOSDemo
//
//  Created by Hiteksha G. Kathiriya on 22/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch
{
    func dropPinZoomIn(placemark:MKPlacemark)
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //CLLocationManager Outlet with locationManager
    let locationManager = CLLocationManager()
    
    // MKMapView Allocation with mapView
    @IBOutlet var mapView: MKMapView!
    
    // Favorite button to set bookmark
    @IBOutlet var btnFavorite: UIButton!
    
    //Display City
    @IBOutlet var lblCity: UILabel!
    
    //Display Address Detail
    @IBOutlet var lblAddressDetail: UILabel!
    
    //Display Address Name
    @IBOutlet var lblAddressName: UILabel!
    
    //Display Country
    @IBOutlet var lblCountry: UILabel!
    
    //Display State
    @IBOutlet var lblState: UILabel!
    
    //UIView objTableView with TableView outlets
    @IBOutlet var objTableView: UIView!
    
    // UITableView outlets
    @IBOutlet var objtbl: UITableView!
    
    //UIView objView with BookMark Description outlets
    @IBOutlet var objView: UIView!
    
    //UIView objBookmarkView with BookMark Page outlets
    @IBOutlet var objBookmarkView: UIView!
    
    //UISearchController outlet with resultSearchController
    var resultSearchController:UISearchController? = nil
    
    //MKPlacemark var declaration with selectedPin
    var selectedPin:MKPlacemark? = nil
    
    //NSMutableArray var declaration with arrBookMark
    var arrBookMark:NSMutableArray = []
    
    //NSMutableArray var declaration with arrBookMarkStored
    var arrBookMarkStored:NSMutableArray = []
    
    //MKPlacemark var declaration with matchingItems
    var matchingItems:[MKPlacemark] = []
    
    //ViewController Life Cycle methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Hide UIView & UITableView
        
        objView.isHidden = true
        if(isKeyPresentInUserDefaults(key: "arrBookMark"))
        {
            let userDefaults = UserDefaults.standard
            arrBookMark = (userDefaults.object(forKey: "arrBookMark") as! NSArray).mutableCopy() as! NSMutableArray
        }
        if(self.arrBookMark.count != 0)
        {
            objTableView.isHidden = false
            objBookmarkView.isHidden = true
            objtbl.delegate = self;
            objtbl.dataSource = self;
            objtbl.reloadData()
        }
        else
        {
            objTableView.isHidden = true
            objBookmarkView.isHidden = false
        }
        //Implement locationManager
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Implement Location serch with SearchController
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

        // Set UI animation in Button favorite...
        let myColor = UIColor.lightGray
        btnFavorite.layer.borderColor = myColor.cgColor
        btnFavorite.layer.cornerRadius = 10
        btnFavorite.layer.borderWidth = 1.0
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool
    {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    // UIButton with Hide/Show PlaceMark
    @IBAction func btnBack(_ sender: UIButton)
    {
        // Hide/Show TableView as per MKPlacemark
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
    
    // UIButton with btnFavoriteclick click event
    @IBAction func btnFavoriteclick(_ sender: Any)
    {
        //Add or Remove Bookmark Location
        if(!btnFavorite.isSelected)
        {
             btnFavorite.isSelected = true
            if let mi = selectedPin
             {
                matchingItems.append(mi)
                var stringDictionary: Dictionary = [String: Any]()
                stringDictionary["Name"] = mi.name
                stringDictionary["Locality"] = mi.locality
                stringDictionary["AdministrativeArea"] = mi.administrativeArea
                stringDictionary["Country"] = mi.country
                stringDictionary["Latitude"] = mi.coordinate.latitude
                stringDictionary["Logitude"] = mi.coordinate.longitude
                arrBookMarkStored.add(stringDictionary)
                let userDefaults = UserDefaults.standard
                userDefaults.set(arrBookMarkStored, forKey:"arrBookMark")
                userDefaults.synchronize()
                
                arrBookMark = (userDefaults.object(forKey: "arrBookMark") as! NSArray).mutableCopy() as! NSMutableArray
             }
        }
        else
        {
           if( matchingItems.count != 0)
           {
                arrBookMarkStored.removeLastObject()
                matchingItems.removeLast()
                let userDefaults = UserDefaults.standard
                userDefaults.set(arrBookMarkStored, forKey:"arrBookMark")
                userDefaults.synchronize()
                arrBookMark = (userDefaults.object(forKey: "arrBookMark") as! NSArray).mutableCopy() as! NSMutableArray
            }
            btnFavorite.isSelected = false
        }
    }
   
     // UIButton with btnSettings click event
    @IBAction func btnSettings(_ sender: Any)
    {
        //Create the AlertController and add Its action like button in Actionsheet with Settings
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Reset Bookmark", style: .default)
        { _ in
            self.matchingItems.removeAll()
            self.arrBookMarkStored.removeAllObjects()
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.arrBookMarkStored, forKey:"arrBookMark")
            userDefaults.synchronize()
            self.arrBookMark = (userDefaults.object(forKey: "arrBookMark") as! NSArray).mutableCopy() as! NSMutableArray
            print(self.arrBookMark)
            if(self.matchingItems.count != 0)
            {
                self.objTableView.isHidden = false
                self.objtbl.reloadData()
            }
            else
            {
                self.objtbl.reloadData()
                self.objTableView.isHidden = true;
                self.objBookmarkView.isHidden = false;
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    // UIButton with btnHelpClick click event
    @IBAction func btnHelpClick(_ sender: Any)
    {
        // Navigate to Help screen
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // UIButton with btnBookMarkClick click event
    @IBAction func btnBookMarkClick(_ sender: Any)
    {
        // Navigate to Location SerchTable if No location added in Bookmark
        if(matchingItems.count != 0)
        {
            objTableView.isHidden = false
            objBookmarkView.isHidden = true
            objView.isHidden = true
        }
        else
        {
            //Dispaly no event in bookmark list
            let alertController = UIAlertController(title: "No bookmark location.", message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //UITableView Delegate & DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrBookMark.count
    }
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var SelectedCell : NSDictionary = [:]
        SelectedCell = arrBookMark[indexPath.row] as! NSDictionary
        cell.textLabel?.text =  SelectedCell.value(forKey: "Name") as? String
        
        var city = SelectedCell.value(forKey: "Locality") as? String
        if ((city ?? "").isEmpty)
        {
            city = ""
        }
        else
        {
            city = SelectedCell.value(forKey: "Locality") as? String
        }
        
        var state = SelectedCell.value(forKey: "AdministrativeArea") as? String
        if ((state ?? "").isEmpty){
            state = ""
        }
        else
        {
            state = SelectedCell.value(forKey: "AdministrativeArea") as? String
        }
        var cuntry = SelectedCell.value(forKey: "Country") as? String
       
        if ((cuntry ?? "").isEmpty){
            cuntry = ""
        }
        else
        {
            cuntry =  SelectedCell.value(forKey: "Country") as? String
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
            if(matchingItems.count != 0)
            {
                matchingItems.remove(at: indexPath.row)
                arrBookMarkStored.removeObject(at: indexPath.row)
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.arrBookMarkStored, forKey:"arrBookMark")
                userDefaults.synchronize()
                self.arrBookMark = (userDefaults.object(forKey: "arrBookMark") as! NSArray).mutableCopy() as! NSMutableArray
            }
            else
            {
                arrBookMark.removeObject(at: indexPath.row)
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.arrBookMark, forKey:"arrBookMark")
                userDefaults.synchronize()
                self.arrBookMark = (userDefaults.object(forKey: "arrBookMark") as! NSArray).mutableCopy() as! NSMutableArray
            }
           
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Redirect to WeatherViewController
        var SelectedCell : NSDictionary = [:]
        SelectedCell = arrBookMark[indexPath.row] as! NSDictionary
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        if let Latitude = SelectedCell.value(forKey: "Latitude") as? NSNumber
        {
            vc?.Latitude = Latitude.floatValue
        }
        if let Longitude = SelectedCell.value(forKey: "Logitude") as? NSNumber
        {
            vc?.Longitude = Longitude.floatValue
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}


// CLLocationManagerDelegate to display Current controller
extension ViewController : CLLocationManagerDelegate
{
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

//Drop Pin when user search location
extension ViewController: HandleMapSearch
{
    func dropPinZoomIn(placemark:MKPlacemark)
    {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea
        {
            let space = " "
            annotation.subtitle = city + space + state
        }
        objView.isHidden = false
        objTableView.isHidden = true
        objBookmarkView.isHidden = true
        btnFavorite.isSelected = false
        
        //Dispaly Address Detail
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

//MKMapViewDelegate methods
extension ViewController : MKMapViewDelegate
{
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
    
    //Navigate to Direction screen
    @objc func getDirections()
    {
        if let selectedPin = selectedPin
        {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}
